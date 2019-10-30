/**
* ## Project: infra-certificates
*
* This module creates the environment certificates
*/
variable "aws_region" {
  type        = "string"
  description = "AWS region"
}

variable "remote_state_bucket" {
  type        = "string"
  description = "S3 bucket we store our terraform state in"
}

variable "remote_state_infra_root_dns_zones_key_stack" {
  type        = "string"
  description = "Override stackname path to infra_root_dns_zones remote state "
  default     = ""
}

variable "certificate_external_domain_name" {
  type        = "string"
  description = "Domain name for which the external certificate should be issued"
}

variable "certificate_external_subject_alternative_names" {
  type        = "list"
  description = "List of domains that should be SANs in the external issued certificate"
  default     = []
}

variable "certificate_internal_domain_name" {
  type        = "string"
  description = "Domain name for which the internal certificate should be issued"
}

variable "certificate_internal_subject_alternative_names" {
  type        = "list"
  description = "List of domains that should be SANs in the internal issued certificate"
  default     = []
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

data "terraform_remote_state" "infra_root_dns_zones" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket}"
    key    = "${coalesce(var.remote_state_infra_root_dns_zones_key_stack, var.stackname)}/infra-root-dns-zones.tfstate"
    region = "${var.aws_region}"
  }
}

resource "aws_acm_certificate" "certificate_external" {
  domain_name               = "${var.certificate_external_domain_name}"
  subject_alternative_names = ["${var.certificate_external_subject_alternative_names}"]
  validation_method         = "DNS"
}

resource "aws_route53_record" "certificate_external_validation" {
  count = "${length(aws_acm_certificate.certificate_external.domain_validation_options)}"

  name    = "${lookup(aws_acm_certificate.certificate_external.domain_validation_options[count.index], "resource_record_name")}"
  type    = "${lookup(aws_acm_certificate.certificate_external.domain_validation_options[count.index], "resource_record_type")}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.external_root_zone_id}"
  records = ["${lookup(aws_acm_certificate.certificate_external.domain_validation_options[count.index], "resource_record_value")}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "certificate_external" {
  certificate_arn         = "${aws_acm_certificate.certificate_external.arn}"
  validation_record_fqdns = ["${aws_route53_record.certificate_external_validation.*.fqdn}"]
}

resource "aws_acm_certificate" "certificate_internal" {
  domain_name               = "${var.certificate_internal_domain_name}"
  subject_alternative_names = ["${var.certificate_internal_subject_alternative_names}"]
  validation_method         = "DNS"
}

resource "aws_route53_record" "certificate_internal_validation" {
  count = "${length(aws_acm_certificate.certificate_internal.domain_validation_options)}"

  name    = "${lookup(aws_acm_certificate.certificate_internal.domain_validation_options[count.index], "resource_record_name")}"
  type    = "${lookup(aws_acm_certificate.certificate_internal.domain_validation_options[count.index], "resource_record_type")}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_dns_validation_zone_id}"
  records = ["${lookup(aws_acm_certificate.certificate_internal.domain_validation_options[count.index], "resource_record_value")}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "certificate_internal" {
  certificate_arn         = "${aws_acm_certificate.certificate_internal.arn}"
  validation_record_fqdns = ["${aws_route53_record.certificate_internal_validation.*.fqdn}"]
}

# Outputs
# --------------------------------------------------------------

output "external_certificate_arn" {
  value       = "${aws_acm_certificate_validation.certificate_external.certificate_arn}"
  description = "ARN of the external certificate"
}

output "internal_certificate_arn" {
  value       = "${aws_acm_certificate_validation.certificate_internal.certificate_arn}"
  description = "ARN of the internal certificate"
}
