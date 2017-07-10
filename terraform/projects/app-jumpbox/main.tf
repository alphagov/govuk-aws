# == Manifest: projects::app-jumpbox
#
# Jumpbox node
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

variable "jumpbox_public_key" {
  type        = "string"
  description = "Jumpbox default public key material"
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

module "jumpbox" {
  source                               = "../../modules/aws/node_group"
  name                                 = "${var.stackname}-jumpbox"
  vpc_id                               = "${data.terraform_remote_state.govuk_vpc.vpc_id}"
  default_tags                         = "${map("Project", var.stackname, "aws_migration", "jumpbox", "aws_hostname", "jumpbox-1")}"
  elb_internal                         = false
  elb_subnet_ids                       = "${data.terraform_remote_state.govuk_networking.public_subnet_ids}"
  elb_security_group_ids               = ["${data.terraform_remote_state.govuk_security_groups.sg_offsite_ssh_id}"]
  elb_listener_instance_port           = "22"
  elb_listener_lb_port                 = "22"
  elb_health_check_target              = "TCP:22"
  instance_subnet_ids                  = "${data.terraform_remote_state.govuk_networking.private_subnet_ids}"
  instance_security_group_ids          = ["${data.terraform_remote_state.govuk_security_groups.sg_jumpbox_id}", "${data.terraform_remote_state.govuk_security_groups.sg_management_id}"]
  instance_type                        = "t2.micro"
  create_instance_key                  = true
  instance_key_name                    = "${var.stackname}-jumpbox"
  instance_public_key                  = "${var.jumpbox_public_key}"
  instance_additional_user_data_script = "${file("${path.module}/jumpbox_additional_user_data.txt")}"
}

# Outputs
# --------------------------------------------------------------

