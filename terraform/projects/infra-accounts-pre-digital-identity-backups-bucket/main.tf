/**
* ## Project: accounts-pre-digital-identity-backups-bucket
*
* This bucket has been creating for storing databases that were used on the
* GOV.UK accounts prototype. This service has now been superseded by DI.
* We however made a commitment to storing our backups for 2 years and it
* contains data (the audit log in the security_activities table) which wasn't
* migrated to digital identity.
*
* The likelihood of us actually needing these files is low, and once we reach
* November 3rd 2023 they will be removed (we can then remove this bucket).
*/
variable "aws_region" {
  type        = "string"
  description = "AWS region"
  default     = "eu-west-1"
}

variable "aws_environment" {
  type        = "string"
  description = "AWS Environment"
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
  version = "2.46.0"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "govuk-${var.aws_environment}-accounts-pre-digital-identity-backups"

  tags {
    Name            = "govuk-${var.aws_environment}-accounts-pre-digital-identity-backups"
    aws_environment = "${var.aws_environment}"
  }

  logging {
    target_bucket = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    target_prefix = "s3/govuk-${var.aws_environment}-accounts-pre-digital-identity-backups/"
  }

  lifecycle_rule {
    id      = "whole_bucket_lifecycle_rule_integration"
    enabled = "true"

    expiration {
      days = "644" # days from 28 January 2022 until November 3rd 2023
    }
  }
}
