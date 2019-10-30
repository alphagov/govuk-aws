/**
* ## Project: app-puppetmaster
*
* Puppetmaster node
*/
variable "aws_region" {
  type        = "string"
  description = "AWS region"
  default     = "eu-west-1"
}

variable "stackname" {
  type        = "string"
  description = "Stackname"
}

variable "aws_environment" {
  type        = "string"
  description = "AWS environment"
}

variable "instance_ami_filter_name" {
  type        = "string"
  description = "Name to use to find AMI images"
  default     = ""
}

variable "enable_bootstrap" {
  type        = "string"
  description = "Whether to create the ELB which allows a user to SSH to the Puppetmaster from the office"
  default     = false
}

variable "elb_internal_certname" {
  type        = "string"
  description = "The ACM cert domain name to find the ARN of"
}

variable "internal_zone_name" {
  type        = "string"
  description = "The name of the Route53 zone that contains internal records"
}

variable "internal_domain_name" {
  type        = "string"
  description = "The domain name of the internal DNS records, it could be different from the zone name."
}

variable "instance_type" {
  type        = "string"
  description = "Instance type used for EC2 resources"
  default     = "m5.xlarge"
}

# Resources
# --------------------------------------------------------------
terraform {
  backend          "s3"             {}
  required_version = "= 0.11.14"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "2.33.0"
}

data "aws_acm_certificate" "elb_internal_cert" {
  domain   = "${var.elb_internal_certname}"
  statuses = ["ISSUED"]
}

data "aws_caller_identity" "current" {}

data "aws_route53_zone" "internal" {
  name         = "${var.internal_zone_name}"
  private_zone = true
}

resource "aws_elb" "puppetmaster_bootstrap_elb" {
  count           = "${var.enable_bootstrap}"
  name            = "${var.stackname}-puppetmaster-bootstrap"
  subnets         = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_offsite_ssh_id}"]

  access_logs {
    bucket        = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    bucket_prefix = "elb/${var.stackname}-puppetmaster-bootstrap-external-elb"
    interval      = 60
  }

  listener {
    instance_port     = 22
    instance_protocol = "tcp"
    lb_port           = 22
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:22"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
    Name    = "${var.stackname}_puppetmaster_bootstrap"
    Project = "${var.stackname}"
  }
}

resource "aws_security_group_rule" "puppetmaster_ingress_offsite-ssh_22" {
  count                    = "${var.enable_bootstrap}"
  type                     = "ingress"
  from_port                = "22"
  to_port                  = "22"
  protocol                 = "tcp"
  source_security_group_id = "${data.terraform_remote_state.infra_security_groups.sg_offsite_ssh_id}"
  security_group_id        = "${data.terraform_remote_state.infra_security_groups.sg_puppetmaster_id}"
}

resource "aws_elb" "puppetmaster_internal_elb" {
  name            = "${var.stackname}-puppetmaster"
  subnets         = ["${data.terraform_remote_state.infra_networking.private_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_puppetmaster_elb_id}"]
  internal        = "true"

  access_logs {
    bucket        = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    bucket_prefix = "elb/${var.stackname}-puppetmaster-internal-elb"
    interval      = 60
  }

  listener {
    instance_port     = "8140"
    instance_protocol = "tcp"
    lb_port           = "8140"
    lb_protocol       = "tcp"
  }

  listener {
    instance_port     = "80"
    instance_protocol = "http"
    lb_port           = "443"
    lb_protocol       = "https"

    ssl_certificate_id = "${data.aws_acm_certificate.elb_internal_cert.arn}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:8140"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = "${map("Name", "${var.stackname}-puppetmaster", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "puppetmaster")}"
}

resource "aws_route53_record" "service_record" {
  zone_id = "${data.aws_route53_zone.internal.zone_id}"
  name    = "puppet.${var.internal_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.puppetmaster_internal_elb.dns_name}"
    zone_id                = "${aws_elb.puppetmaster_internal_elb.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "puppetdb_service_record" {
  zone_id = "${data.aws_route53_zone.internal.zone_id}"
  name    = "puppetdb.${var.internal_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.puppetmaster_internal_elb.dns_name}"
    zone_id                = "${aws_elb.puppetmaster_internal_elb.zone_id}"
    evaluate_target_health = true
  }
}

module "puppetmaster" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-puppetmaster"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "puppetmaster", "aws_hostname", "puppetmaster-1")}"
  instance_subnet_ids           = "${data.terraform_remote_state.infra_networking.private_subnet_ids}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_puppetmaster_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "${var.instance_type}"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids              = ["${aws_elb.puppetmaster_internal_elb.id}", "${aws_elb.puppetmaster_bootstrap_elb.*.id}"]
  instance_elb_ids_length       = "${var.enable_bootstrap > 0 ? 2 : 1}"
  instance_ami_filter_name      = "${var.instance_ami_filter_name}"
  asg_notification_topic_arn    = "${data.terraform_remote_state.infra_monitoring.sns_topic_autoscaling_group_events_arn}"
  root_block_device_volume_size = "50"
}

resource "aws_iam_policy" "puppetmaster_iam_policy" {
  name   = "${var.stackname}-puppetmaster-additional"
  path   = "/"
  policy = "${file("${path.module}/additional_policy.json")}"
}

resource "aws_iam_role_policy_attachment" "puppetmaster_iam_role_policy_attachment" {
  role       = "${module.puppetmaster.instance_iam_role_name}"
  policy_arn = "${aws_iam_policy.puppetmaster_iam_policy.arn}"
}

data "aws_iam_policy_document" "ssm_getparameter_policy_doc" {
  statement {
    sid = "1"

    actions = [
      "ssm:GetParameter",
      "ssm:DescribeParameters",
    ]

    resources = [
      "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/*",
    ]
  }
}

resource "aws_iam_policy" "puppetmaster_ssm_getparameter_policy" {
  name   = "${var.stackname}-puppetmaster-ssm-getparameter"
  policy = "${data.aws_iam_policy_document.ssm_getparameter_policy_doc.json}"
}

resource "aws_iam_role_policy_attachment" "puppetmaster_iam_role_policy_attachment_2" {
  role       = "${module.puppetmaster.instance_iam_role_name}"
  policy_arn = "${aws_iam_policy.puppetmaster_ssm_getparameter_policy.arn}"
}

module "alarms-elb-puppetmaster-internal" {
  source                         = "../../modules/aws/alarms/elb"
  name_prefix                    = "${var.stackname}-puppetmaster-internal"
  alarm_actions                  = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  elb_name                       = "${aws_elb.puppetmaster_internal_elb.name}"
  httpcode_backend_4xx_threshold = "0"
  httpcode_backend_5xx_threshold = "0"
  httpcode_elb_4xx_threshold     = "0"
  httpcode_elb_5xx_threshold     = "0"
  surgequeuelength_threshold     = "200"
  healthyhostcount_threshold     = "1"
}

# Outputs
# --------------------------------------------------------------

output "puppetmaster_internal_elb_dns_name" {
  value       = "${aws_elb.puppetmaster_internal_elb.dns_name}"
  description = "DNS name to access the puppetmaster service"
}

output "puppetmaster_bootstrap_elb_dns_name" {
  value       = "${join("", aws_elb.puppetmaster_bootstrap_elb.*.dns_name)}"
  description = "DNS name to access the puppetmaster bootstrap service"
}

output "service_dns_name" {
  value       = "${aws_route53_record.service_record.fqdn}"
  description = "DNS name to access the node service"
}

output "puppetdb_service_dns_name" {
  value       = "${aws_route53_record.puppetdb_service_record.fqdn}"
  description = "DNS name to access the node service"
}
