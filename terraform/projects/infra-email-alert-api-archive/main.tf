/**
* ## Project: infra-email-alert-archive
*
* Stores log data from Email Alert API of all of the emails sent for analytics
* purposes.
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

resource "aws_s3_bucket" "email_alert_api_archive" {
  bucket        = "govuk-${var.aws_environment}-email-alert-api-archive"
  force_destroy = true

  tags {
    Name            = "govuk-${var.aws_environment}-email-alert-api-archive"
    aws_environment = "${var.aws_environment}"
  }

  logging {
    target_bucket = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    target_prefix = "s3/govuk-${var.aws_environment}-email-alert-api-archive/"
  }
}
