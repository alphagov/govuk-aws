# == Manifest: projects::app-frontend-lb
#
# Frontend application servers
#
# === Variables:
#
# aws_region
# remote_state_govuk_vpc_key
# remote_state_govuk_vpc_bucket
# stackname
#
# === Outputs:
#

variable "aws_region" {
  type        = "string"
  description = "AWS region"
  default     = "eu-west-1"
}

variable "remote_state_govuk_vpc_key" {
  type        = "string"
  description = "VPC TF remote state key"
}

variable "remote_state_govuk_vpc_bucket" {
  type        = "string"
  description = "VPC TF remote state bucket"
}

variable "remote_state_govuk_networking_key" {
  type        = "string"
  description = "VPC TF remote state key"
}

variable "remote_state_govuk_networking_bucket" {
  type        = "string"
  description = "VPC TF remote state bucket"
}

variable "remote_state_govuk_security_groups_key" {
  type        = "string"
  description = "VPC TF remote state key"
}

variable "remote_state_govuk_security_groups_bucket" {
  type        = "string"
  description = "VPC TF remote state bucket"
}

variable "remote_state_govuk_internal_dns_zone_key" {
  type        = "string"
  description = "VPC TF remote state key"
}

variable "remote_state_govuk_internal_dns_zone_bucket" {
  type        = "string"
  description = "VPC TF remote state bucket"
}

variable "stackname" {
  type        = "string"
  description = "Stackname"
}

variable "ssh_public_key" {
  type        = "string"
  description = "Default public key material"
}

# Resources
# --------------------------------------------------------------
terraform {
  backend          "s3"             {}
  required_version = "= 0.9.10"
}

provider "aws" {
  region = "${var.aws_region}"
}

data "terraform_remote_state" "govuk_vpc" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_govuk_vpc_bucket}"
    key    = "${var.remote_state_govuk_vpc_key}"
    region = "eu-west-1"
  }
}

data "terraform_remote_state" "govuk_networking" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_govuk_networking_bucket}"
    key    = "${var.remote_state_govuk_networking_key}"
    region = "eu-west-1"
  }
}

data "terraform_remote_state" "govuk_security_groups" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_govuk_security_groups_bucket}"
    key    = "${var.remote_state_govuk_security_groups_key}"
    region = "eu-west-1"
  }
}

data "terraform_remote_state" "govuk_internal_dns_zone" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_govuk_internal_dns_zone_bucket}"
    key    = "${var.remote_state_govuk_internal_dns_zone_key}"
    region = "eu-west-1"
  }
}

resource "aws_elb" "frontend-lb_elb" {
  name            = "${var.stackname}-frontend-lb"
  subnets         = ["${data.terraform_remote_state.govuk_networking.private_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.govuk_security_groups.sg_frontend-lb_elb_id}"]
  internal        = "true"

  listener {
    instance_port     = 443
    instance_protocol = "tcp"
    lb_port           = 443
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3

    target   = "TCP:443"
    interval = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = "${map("Name", "${var.stackname}-frontend-lb", "Project", var.stackname, "aws_migration", "frontend_lb")}"
}

resource "aws_route53_record" "frontend-lb_service_record" {
  zone_id = "${data.terraform_remote_state.govuk_internal_dns_zone.internal_service_zone_id}"
  name    = "frontend-lb"
  type    = "A"

  alias {
    name                   = "${aws_elb.frontend-lb_elb.dns_name}"
    zone_id                = "${aws_elb.frontend-lb_elb.zone_id}"
    evaluate_target_health = true
  }
}

module "frontend-lb" {
  source                               = "../../modules/aws/node_group"
  name                                 = "${var.stackname}-frontend-lb"
  vpc_id                               = "${data.terraform_remote_state.govuk_vpc.vpc_id}"
  default_tags                         = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_migration", "frontend_lb", "aws_hostname", "frontend-lb-1")}"
  instance_subnet_ids                  = "${data.terraform_remote_state.govuk_networking.private_subnet_ids}"
  instance_security_group_ids          = ["${data.terraform_remote_state.govuk_security_groups.sg_frontend-lb_id}", "${data.terraform_remote_state.govuk_security_groups.sg_management_id}"]
  instance_type                        = "t2.medium"
  create_instance_key                  = true
  instance_key_name                    = "${var.stackname}-frontend-lb"
  instance_public_key                  = "${var.ssh_public_key}"
  instance_additional_user_data_script = "${file("${path.module}/additional_user_data.txt")}"
  instance_elb_ids                     = ["${aws_elb.frontend-lb_elb.id}"]
  asg_max_size                         = "2"
  asg_min_size                         = "2"
  asg_desired_capacity                 = "2"
}

# Outputs
# --------------------------------------------------------------

output "frontend-lb_elb_dns_name" {
  value       = "${aws_elb.frontend-lb_elb.dns_name}"
  description = "DNS name to access the frontend-lb service"
}

output "service_dns_name" {
  value       = "${aws_route53_record.frontend-lb_service_record.fqdn}"
  description = "DNS name to access the service"
}
