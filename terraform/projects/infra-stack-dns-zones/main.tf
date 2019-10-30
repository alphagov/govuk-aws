/**
* ## Project: infra-stack-dns-zones
*
* This module creates the internal and external DNS zones used by our stacks.
*
* When we select to create a DNS zone, the domain name and ID of the zone that
* manages the root domain needs to be provided to register the DNS delegation
* and NS servers of the created zone. The domain name of the new zone is created
* from the variables provided as <stackname>.<root_domain_internal|external_name>
*
* We can't create a internal DNS zone per stack because on AWS we can't overlap
* internal domain names. Instead we use the same internal zone for all the sacks
* and we use the name schema `<service>.<stackname>.<root_domain>`
*
* The outputs of this project should be used by the stacks to create the right
* service records on the internal and external DNS zones.
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

variable "stackname" {
  type        = "string"
  description = "Stackname"
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

data "aws_route53_zone" "external_selected" {
  name         = "${var.root_domain_external_name}"
  private_zone = false
}

resource "aws_route53_zone" "external_zone" {
  count = "${var.create_external_zone}"
  name  = "${var.stackname}.${var.root_domain_external_name}"

  tags {
    Project       = "${var.stackname}"
    aws_stackname = "${var.stackname}"
  }
}

resource "aws_route53_record" "external_zone_ns" {
  count   = "${var.create_external_zone}"
  zone_id = "${data.aws_route53_zone.external_selected.zone_id}"
  name    = "${var.stackname}.${var.root_domain_external_name}"
  type    = "NS"
  ttl     = "30"

  records = [
    "${aws_route53_zone.external_zone.name_servers.0}",
    "${aws_route53_zone.external_zone.name_servers.1}",
    "${aws_route53_zone.external_zone.name_servers.2}",
    "${aws_route53_zone.external_zone.name_servers.3}",
  ]
}

data "aws_route53_zone" "internal_selected" {
  name         = "${var.root_domain_internal_name}"
  vpc_id       = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  private_zone = true
}

# Outputs
# --------------------------------------------------------------
output "internal_zone_id" {
  value       = "${data.aws_route53_zone.internal_selected.zone_id}"
  description = "Route53 Internal Zone ID"
}

output "internal_domain_name" {
  value       = "${var.stackname}.${var.root_domain_internal_name}"
  description = "Route53 Internal Domain Name"
}

output "external_zone_id" {
  value       = "${join("", aws_route53_zone.external_zone.*.zone_id)}"
  description = "Route53 External Zone ID"
}

output "external_domain_name" {
  value       = "${join("", aws_route53_zone.external_zone.*.name)}"
  description = "Route53 External Domain Name"
}
