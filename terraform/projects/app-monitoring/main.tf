/**
* ## Project: app-monitoring
*
* Monitoring node
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
  description = "AWS Environment"
}

variable "ebs_encrypted" {
  type        = "string"
  description = "Whether or not the EBS volume is encrypted"
}

variable "instance_ami_filter_name" {
  type        = "string"
  description = "Name to use to find AMI images"
  default     = ""
}

variable "elb_external_certname" {
  type        = "string"
  description = "The ACM cert domain name to find the ARN of"
}

variable "elb_internal_certname" {
  type        = "string"
  description = "The ACM cert domain name to find the ARN of"
}

variable "monitoring_subnet" {
  type        = "string"
  description = "Name of the subnet to place the monitoring instance and the EBS volume"
}

# Resources
# --------------------------------------------------------------
terraform {
  backend          "s3"             {}
  required_version = "= 0.11.7"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "1.40.0"
}

data "aws_acm_certificate" "elb_external_cert" {
  domain   = "${var.elb_external_certname}"
  statuses = ["ISSUED"]
}

data "aws_acm_certificate" "elb_internal_cert" {
  domain   = "${var.elb_internal_certname}"
  statuses = ["ISSUED"]
}

resource "aws_elb" "monitoring_external_elb" {
  name            = "${var.stackname}-monitoring-external"
  subnets         = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_monitoring_external_elb_id}"]
  internal        = "false"

  access_logs {
    bucket        = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    bucket_prefix = "elb/${var.stackname}-monitoring-external-elb"
    interval      = 60
  }

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 443
    lb_protocol       = "https"

    ssl_certificate_id = "${data.aws_acm_certificate.elb_external_cert.arn}"
  }

  listener {
    instance_port     = 6514
    instance_protocol = "tcp"
    lb_port           = 6514
    lb_protocol       = "ssl"

    ssl_certificate_id = "${data.aws_acm_certificate.elb_external_cert.arn}"
  }

  listener {
    instance_port     = 6515
    instance_protocol = "tcp"
    lb_port           = 6515
    lb_protocol       = "ssl"

    ssl_certificate_id = "${data.aws_acm_certificate.elb_external_cert.arn}"
  }

  listener {
    instance_port     = 6516
    instance_protocol = "tcp"
    lb_port           = 6516
    lb_protocol       = "ssl"

    ssl_certificate_id = "${data.aws_acm_certificate.elb_external_cert.arn}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3

    target   = "TCP:80"
    interval = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = "${map("Name", "${var.stackname}-monitoring", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "monitoring")}"
}

resource "aws_elb" "monitoring_internal_elb" {
  name            = "${var.stackname}-monitoring"
  subnets         = ["${data.terraform_remote_state.infra_networking.private_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_monitoring_internal_elb_id}"]
  internal        = "true"

  listener {
    instance_port     = 22
    instance_protocol = "tcp"
    lb_port           = 22
    lb_protocol       = "tcp"
  }

  listener {
    instance_port     = 5667
    instance_protocol = "tcp"
    lb_port           = 5667
    lb_protocol       = "tcp"
  }

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 443
    lb_protocol       = "https"

    ssl_certificate_id = "${data.aws_acm_certificate.elb_internal_cert.arn}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3

    target   = "TCP:5667"
    interval = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = "${map("Name", "${var.stackname}-monitoring", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "monitoring")}"
}

module "monitoring" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-monitoring"
  vpc_id                        = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "monitoring", "aws_hostname", "monitoring-1")}"
  instance_subnet_ids           = "${matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.monitoring_subnet))}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_monitoring_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "m5.xlarge"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids_length       = "2"
  instance_elb_ids              = ["${aws_elb.monitoring_external_elb.id}", "${aws_elb.monitoring_internal_elb.id}"]
  instance_ami_filter_name      = "${var.instance_ami_filter_name}"
  asg_notification_topic_arn    = "${data.terraform_remote_state.infra_monitoring.sns_topic_autoscaling_group_events_arn}"
}

resource "aws_ebs_volume" "monitoring" {
  availability_zone = "${lookup(data.terraform_remote_state.infra_networking.private_subnet_names_azs_map, var.monitoring_subnet)}"
  encrypted         = "${var.ebs_encrypted}"
  type              = "gp2"
  size              = 20

  tags {
    Name            = "${var.stackname}-monitoring"
    Project         = "${var.stackname}"
    ManagedBy       = "terraform"
    aws_stackname   = "${var.stackname}"
    aws_environment = "${var.aws_environment}"
    aws_migration   = "monitoring"
    aws_hostname    = "monitoring-1"
    Device          = "xvdf"
  }
}

resource "aws_iam_policy" "monitoring-iam_policy" {
  name   = "${var.stackname}-monitoring-additional"
  path   = "/"
  policy = "${file("${path.module}/additional_policy.json")}"
}

resource "aws_iam_role_policy_attachment" "monitoring_iam_role_policy_attachment" {
  role       = "${module.monitoring.instance_iam_role_name}"
  policy_arn = "${aws_iam_policy.monitoring-iam_policy.arn}"
}

resource "aws_route53_record" "external_service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.external_zone_id}"
  name    = "alert.${data.terraform_remote_state.infra_stack_dns_zones.external_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.monitoring_external_elb.dns_name}"
    zone_id                = "${aws_elb.monitoring_external_elb.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "internal_service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.internal_zone_id}"
  name    = "alert.${data.terraform_remote_state.infra_stack_dns_zones.internal_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.monitoring_internal_elb.dns_name}"
    zone_id                = "${aws_elb.monitoring_internal_elb.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "terraboard_external_service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.external_zone_id}"
  name    = "terraboard.${data.terraform_remote_state.infra_stack_dns_zones.external_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.monitoring_internal_elb.dns_name}"
    zone_id                = "${aws_elb.monitoring_internal_elb.zone_id}"
    evaluate_target_health = true
  }
}

module "alarms-elb-monitoring-internal" {
  source                         = "../../modules/aws/alarms/elb"
  name_prefix                    = "${var.stackname}-monitoring-internal"
  alarm_actions                  = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  elb_name                       = "${aws_elb.monitoring_internal_elb.name}"
  httpcode_backend_4xx_threshold = "0"
  httpcode_backend_5xx_threshold = "0"
  httpcode_elb_4xx_threshold     = "0"
  httpcode_elb_5xx_threshold     = "0"
  surgequeuelength_threshold     = "200"
  healthyhostcount_threshold     = "1"
}

module "alarms-elb-monitoring-external" {
  source                         = "../../modules/aws/alarms/elb"
  name_prefix                    = "${var.stackname}-monitoring-external"
  alarm_actions                  = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  elb_name                       = "${aws_elb.monitoring_external_elb.name}"
  httpcode_backend_4xx_threshold = "0"
  httpcode_backend_5xx_threshold = "100"
  httpcode_elb_4xx_threshold     = "0"
  httpcode_elb_5xx_threshold     = "100"
  surgequeuelength_threshold     = "0"
  healthyhostcount_threshold     = "0"
}

# Outputs
# --------------------------------------------------------------

output "monitoring_external_elb_dns_name" {
  value       = "${aws_elb.monitoring_external_elb.dns_name}"
  description = "External DNS name to access the monitoring service"
}

output "monitoring_internal_elb_dns_name" {
  value       = "${aws_elb.monitoring_internal_elb.dns_name}"
  description = "Internal DNS name to access the monitoring service"
}
