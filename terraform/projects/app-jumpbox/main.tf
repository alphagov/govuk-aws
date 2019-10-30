/**
* ## Project: app-jumpbox
*
* Jumpbox node
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

variable "instance_ami_filter_name" {
  type        = "string"
  description = "Name to use to find AMI images"
  default     = ""
}

variable "external_zone_name" {
  type        = "string"
  description = "The name of the Route53 zone that contains external records"
}

variable "external_domain_name" {
  type        = "string"
  description = "The domain name of the external DNS records, it could be different from the zone name"
}

variable "create_external_elb" {
  description = "Create the external ELB"
  default     = true
}

variable "instance_type" {
  type        = "string"
  description = "Instance type used for EC2 resources"
  default     = "t2.micro"
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

data "aws_route53_zone" "external" {
  name         = "${var.external_zone_name}"
  private_zone = false
}

resource "aws_elb" "jumpbox_external_elb" {
  count = "${var.create_external_elb}"

  name            = "${var.stackname}-jumpbox"
  subnets         = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_offsite_ssh_id}"]
  internal        = "false"

  access_logs {
    bucket        = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    bucket_prefix = "elb/${var.stackname}-jumpbox-external-elb"
    interval      = 60
  }

  listener {
    instance_port     = "22"
    instance_protocol = "tcp"
    lb_port           = "22"
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

  tags = "${map("Name", "${var.stackname}-jumpbox", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "jumpbox")}"
}

resource "aws_route53_record" "service_record" {
  count = "${var.create_external_elb}"

  zone_id = "${data.aws_route53_zone.external.zone_id}"
  name    = "jumpbox.${var.external_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.jumpbox_external_elb.dns_name}"
    zone_id                = "${aws_elb.jumpbox_external_elb.zone_id}"
    evaluate_target_health = true
  }
}

locals {
  instance_elb_ids_length = "${var.create_external_elb ? 1 : 0}"
  instance_elb_ids        = "${compact(list(join("", aws_elb.jumpbox_external_elb.*.id)))}"
}

module "jumpbox" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-jumpbox"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "jumpbox", "aws_hostname", "jumpbox-1")}"
  instance_subnet_ids           = "${data.terraform_remote_state.infra_networking.private_subnet_ids}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_jumpbox_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "${var.instance_type}"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids              = ["${local.instance_elb_ids}"]
  instance_elb_ids_length       = "${local.instance_elb_ids_length}"
  instance_ami_filter_name      = "${var.instance_ami_filter_name}"
  asg_notification_topic_arn    = "${data.terraform_remote_state.infra_monitoring.sns_topic_autoscaling_group_events_arn}"
  root_block_device_volume_size = "64"
}

locals {
  surgequeuelength_threshold = "${var.create_external_elb ? 200 : 0}"
  healthyhostcount_threshold = "${var.create_external_elb ? 1 : 0}"
}

module "alarms-elb-jumpbox-internal" {
  source                         = "../../modules/aws/alarms/elb"
  name_prefix                    = "${var.stackname}-jumpbox-external"
  alarm_actions                  = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  elb_name                       = "${join("", aws_elb.jumpbox_external_elb.*.name)}"
  httpcode_backend_4xx_threshold = "0"
  httpcode_backend_5xx_threshold = "0"
  httpcode_elb_4xx_threshold     = "0"
  httpcode_elb_5xx_threshold     = "0"
  surgequeuelength_threshold     = "${local.surgequeuelength_threshold}"
  healthyhostcount_threshold     = "${local.healthyhostcount_threshold}"
}

# Outputs
# --------------------------------------------------------------

output "jumpbox_elb_address" {
  value       = "${join("", aws_elb.jumpbox_external_elb.*.dns_name)}"
  description = "AWS' internal DNS name for the jumpbox ELB"
}

output "service_dns_name" {
  value       = "${join("", aws_route53_record.service_record.*.name)}"
  description = "DNS name to access the node service"
}
