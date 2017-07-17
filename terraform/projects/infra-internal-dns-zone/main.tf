# == Manifest: projects::govuk-internal-dns-zone
#
# This module creates the internal DNS zone used by internal services
#
# === Variables:
#
# aws_region
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

variable "remote_state_bucket" {
  type        = "string"
  description = "S3 bucket we store our terraform state in"
}

variable "stackname" {
  type        = "string"
  description = "Stackname"
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

data "terraform_remote_state" "infra_vpc" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket}"
    key    = "${var.stackname}/infra-vpc.tfstate"
    region = "eu-west-1"
  }
}

resource "aws_route53_zone" "internal_zone" {
  name   = "${var.stackname}.internal"
  vpc_id = "${data.terraform_remote_state.infra_vpc.vpc_id}"

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
