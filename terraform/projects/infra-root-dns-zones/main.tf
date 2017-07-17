# == Manifest: projects::infra-root-dns-zones
#
# This module creates the internal and external root DNS zones.
#
# === Variables:
#
# aws_region
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

variable "remote_state_bucket" {
  type        = "string"
  description = "S3 bucket we store our terraform state in"
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
  count  = "${var.create_internal_zone}"
  name   = "${var.root_domain_internal_name}"
  vpc_id = "${data.terraform_remote_state.infra_vpc.vpc_id}"

  tags {
    Project = "infra-root-dns-zones"
  }
}

resource "aws_route53_zone" "external_zone" {
  count = "${var.create_external_zone}"
  name  = "${var.root_domain_external_name}"

  tags {
    Project = "infra-root-dns-zones"
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
