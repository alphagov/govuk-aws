/**
* ## Project: infra-root-dns-zones
*
* This module creates the internal and external root DNS zones.
*/
variable "aws_region" {
  type        = "string"
  description = "AWS region"
  default     = "eu-west-1"
}

variable "remote_state_bucket" {
  type        = "string"
  description = "S3 bucket we store our terraform state in"
}

variable "remote_state_infra_vpc_key_stack" {
  type        = "string"
  description = "Override infra_vpc remote state path"
  default     = ""
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

variable "create_internal_zone_dns_validation" {
  type        = "string"
  description = "Create a public DNS zone to validate the internal domain certificate (default false)"
  default     = false
}

variable "stackname" {
  type        = "string"
  description = "Stackname"
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

data "terraform_remote_state" "infra_vpc" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket}"
    key    = "${coalesce(var.remote_state_infra_vpc_key_stack, var.stackname)}/infra-vpc.tfstate"
    region = "${var.aws_region}"
  }
}

resource "aws_route53_zone" "internal_zone" {
  count = "${var.create_internal_zone}"
  name  = "${var.root_domain_internal_name}"

  vpc {
    vpc_id = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  }

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

resource "aws_route53_zone" "internal_zone_dns_validation" {
  count = "${var.create_internal_zone_dns_validation}"
  name  = "${var.root_domain_internal_name}"

  tags {
    Project = "infra-root-dns-zones"
  }
}

# Outputs
# --------------------------------------------------------------

output "internal_root_zone_id" {
  value       = "${join("", aws_route53_zone.internal_zone.*.zone_id)}"
  description = "Route53 Internal Root Zone ID"
}

output "internal_root_domain_name" {
  value       = "${join("", aws_route53_zone.internal_zone.*.name)}"
  description = "Route53 Internal Root Domain Name"
}

output "external_root_zone_id" {
  value       = "${join("", aws_route53_zone.external_zone.*.zone_id)}"
  description = "Route53 External Root Zone ID"
}

output "external_root_domain_name" {
  value       = "${join("", aws_route53_zone.external_zone.*.name)}"
  description = "Route53 External Root Domain Name"
}

output "internal_root_dns_validation_zone_id" {
  value       = "${join("", aws_route53_zone.internal_zone_dns_validation.*.zone_id)}"
  description = "Route53 Zone ID for DNS certificate validation of the internal domain"
}
