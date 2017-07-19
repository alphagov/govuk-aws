# == Manifest: projects::infra-vpc
#
# Creates the base VPC layer for an AWS stack.
#
# === Variables:
#
# aws_region
# stackname
# vpc_name
# vpc_cidr
#
# === Outputs:
#
# vpc_id
# vpc_cidr
# internet_gateway_id
# route_table_public_id
#

variable "aws_region" {
  type        = "string"
  description = "AWS region"
  default     = "eu-west-1"
}

variable "stackname" {
  type        = "string"
  description = "Stackname"
  default     = ""
}

variable "vpc_name" {
  type        = "string"
  description = "A name tag for the VPC"
}

variable "vpc_cidr" {
  type        = "string"
  description = "VPC IP address range, represented as a CIDR block"
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

module "vpc" {
  source       = "../../modules/aws/network/vpc"
  name         = "${var.vpc_name}"
  cidr         = "${var.vpc_cidr}"
  default_tags = "${map("Project", var.stackname)}"
}

# Outputs
# --------------------------------------------------------------

output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "vpc_cidr" {
  value = "${module.vpc.vpc_cidr}"
}

output "internet_gateway_id" {
  value = "${module.vpc.internet_gateway_id}"
}

output "route_table_public_id" {
  value = "${module.vpc.route_table_public_id}"
}
