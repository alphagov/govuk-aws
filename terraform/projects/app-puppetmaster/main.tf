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

variable "ssh_public_key" {
  type        = "string"
  description = "Puppetmaster default public key material"
}

variable "instance_ami_filter_name" {
  type        = "string"
  description = "Name to use to find AMI images"
  default     = ""
}

# Resources
# --------------------------------------------------------------
terraform {
  backend          "s3"             {}
  required_version = "= 0.10.7"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "1.0.0"
}

resource "aws_elb" "puppetmaster_bootstrap_elb" {
  name            = "${var.stackname}-puppetmaster-bootstrap"
  subnets         = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_offsite_ssh_id}"]

  access_logs {
    bucket        = "${data.terraform_remote_state.infra_aws_logging.aws_logging_bucket_id}"
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

resource "aws_security_group_rule" "puppetmaster_from_elb_in_22" {
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
    bucket        = "${data.terraform_remote_state.infra_aws_logging.aws_logging_bucket_id}"
    bucket_prefix = "elb/${var.stackname}-puppetmaster-internal-elb"
    interval      = 60
  }

  listener {
    instance_port     = "8140"
    instance_protocol = "tcp"
    lb_port           = "8140"
    lb_protocol       = "tcp"
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
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.internal_zone_id}"
  name    = "puppet.${data.terraform_remote_state.infra_stack_dns_zones.internal_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.puppetmaster_internal_elb.dns_name}"
    zone_id                = "${aws_elb.puppetmaster_internal_elb.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "puppetdb_service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.internal_zone_id}"
  name    = "puppetdb.${data.terraform_remote_state.infra_stack_dns_zones.internal_domain_name}"
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
  vpc_id                        = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "puppetmaster", "aws_hostname", "puppetmaster-1")}"
  instance_subnet_ids           = "${data.terraform_remote_state.infra_networking.private_subnet_ids}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_puppetmaster_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "m4.xlarge"
  create_instance_key           = true
  instance_key_name             = "${var.stackname}-puppetmaster_bootstrap"
  instance_public_key           = "${var.ssh_public_key}"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids              = ["${aws_elb.puppetmaster_bootstrap_elb.id}", "${aws_elb.puppetmaster_internal_elb.id}"]
  instance_ami_filter_name      = "${var.instance_ami_filter_name}"
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

module "alarms-elb-puppetmaster-internal" {
  source                         = "../../modules/aws/alarms/elb"
  name_prefix                    = "${var.stackname}-puppetmaster-internal"
  alarm_actions                  = ["${data.terraform_remote_state.infra_stack_sns_alerts.sns_topic_alerts_arn}"]
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
  value       = "${aws_elb.puppetmaster_bootstrap_elb.dns_name}"
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
