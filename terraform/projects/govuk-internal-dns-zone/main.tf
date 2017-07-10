# == Manifest: projects::govuk-internal-dns-zone
#
# This module creates the internal DNS zone used by internal services
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
# internal_service_zone_id
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

variable "stackname" {
  type        = "string"
  description = "Stackname"
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

resource "aws_route53_zone" "internal_zone" {
  name   = "${var.stackname}.internal"
  vpc_id = "${data.terraform_remote_state.govuk_vpc.vpc_id}"

  tags {
    Project = "${var.stackname}"
  }
}

# Outputs
# --------------------------------------------------------------
output "internal_service_zone_id" {
  value       = "${aws_route53_zone.internal_zone.zone_id}"
  description = "Route53 Zone ID"
}
