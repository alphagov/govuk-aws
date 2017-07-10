# == Manifest: projects::app-puppetmaster
#
# PUppetmaster node
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

variable "stackname" {
  type        = "string"
  description = "Stackname"
}

variable "puppetmaster_bootstrap_public_key" {
  type        = "string"
  description = "Puppetmaster default public key material"
}

# Resources
# --------------------------------------------------------------
terraform {
  backend "s3" {}
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

resource "aws_elb" "puppetmaster_bootstrap_elb" {
  name            = "${var.stackname}-puppetmaster-bootstrap"
  subnets         = ["${data.terraform_remote_state.govuk_networking.public_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.govuk_security_groups.sg_offsite_ssh_id}"]

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
  source_security_group_id = "${data.terraform_remote_state.govuk_security_groups.sg_offsite_ssh_id}"
  security_group_id        = "${data.terraform_remote_state.govuk_security_groups.sg_puppetmaster_id}"
}

module "puppetmaster" {
  source                               = "../../modules/aws/node_group"
  name                                 = "${var.stackname}-puppetmaster"
  vpc_id                               = "${data.terraform_remote_state.govuk_vpc.vpc_id}"
  default_tags                         = "${map("Project", var.stackname, "aws_migration", "puppetmaster", "aws_hostname", "puppetmaster-1")}"
  elb_subnet_ids                       = "${data.terraform_remote_state.govuk_networking.private_subnet_ids}"
  elb_security_group_ids               = ["${data.terraform_remote_state.govuk_security_groups.sg_puppetmaster_elb_id}"]
  elb_listener_instance_port           = "8140"
  elb_listener_lb_port                 = "8140"
  elb_health_check_target              = "TCP:8140"
  instance_subnet_ids                  = "${data.terraform_remote_state.govuk_networking.private_subnet_ids}"
  instance_security_group_ids          = ["${data.terraform_remote_state.govuk_security_groups.sg_puppetmaster_id}", "${data.terraform_remote_state.govuk_security_groups.sg_management_id}"]
  instance_type                        = "t2.medium"
  create_instance_key                  = true
  instance_key_name                    = "${var.stackname}-puppetmaster_bootstrap"
  instance_public_key                  = "${var.puppetmaster_bootstrap_public_key}"
  instance_additional_user_data_script = "${file("${path.module}/puppetmaster_additional_user_data.txt")}"
}

# Outputs
# --------------------------------------------------------------

output "puppetmaster_dns_name" {
  value       = "${module.puppetmaster.service_dns_name}"
  description = "DNS name to access the puppetmaster service"
}

output "puppetmaster_bootstrap_dns_name" {
  value       = "${aws_elb.puppetmaster_bootstrap_elb.dns_name}"
  description = "DNS name to access the puppetmaster bootstrap service"
}
