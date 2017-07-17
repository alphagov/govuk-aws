# == Manifest: projects::govuk-root-dns-zones
#
# This module creates the internal and external root DNS zones.
#
# === Variables:
#
# aws_region
# remote_state_govuk_vpc_key
# remote_state_govuk_vpc_bucket
# create_internal_zone
# root_domain_internal_name
# create_external_zone
# root_domain_external_name
#
# === Outputs:
#
# internal_root_zone_id
# external_root_zone_id
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

variable "create_internal_zone" {
  type        = "string"
  description = "Create an internal DNS zone (default true)"
  default     = true
}

variable "root_domain_internal_name" {
  type        = "string"
  description = "Internal DNS root domain name. Override default for Integration, Staging, Production if create_internal_zone is true"
  default     = "mydomain.internal"
}

variable "create_external_zone" {
  type        = "string"
  description = "Create an external DNS zone (default true)"
  default     = true
}

variable "root_domain_external_name" {
  type        = "string"
  description = "External DNS root domain name. Override default for Integration, Staging, Production if create_external_zone is true"
  default     = "mydomain.external"
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

resource "aws_route53_zone" "internal_zone" {
  count  = "${var.create_internal_zone}"
  name   = "${var.root_domain_internal_name}"
  vpc_id = "${data.terraform_remote_state.govuk_vpc.vpc_id}"

  tags {
    Project = "govuk-root-dns-zones"
  }
}

resource "aws_route53_zone" "external_zone" {
  count = "${var.create_external_zone}"
  name  = "${var.root_domain_external_name}"

  tags {
    Project = "govuk-root-dns-zones"
  }
}

# Outputs
# --------------------------------------------------------------
output "internal_root_zone_id" {
  value       = "${aws_route53_zone.internal_zone.zone_id}"
  description = "Route53 Internal Root Zone ID"
}

output "external_root_zone_id" {
  value       = "${aws_route53_zone.external_zone.zone_id}"
  description = "Route53 External Root Zone ID"
}
