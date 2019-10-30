/**
* ## Project: infra-govuk-cdn-logs-monitor-bucket
*
* Stores data that is being archived due to the retirement of
* [govuk-cdn-logs-monitor](https://github.com/alphagov/govuk-cdn-logs-monitor).
* The intention is for this to be temporary and data won't be added to this
* after archiving. So if you're reading this in June 2019 this is pretty safe
* to delete.
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
  version = "2.33.0"
}

resource "aws_s3_bucket" "cdn_logs_monitor" {
  bucket = "govuk-${var.aws_environment}-cdn-logs-monitor-archive"

  tags {
    Name            = "govuk-${var.aws_environment}-cdn-logs-monitor-archive"
    aws_environment = "${var.aws_environment}"
  }

  logging {
    target_bucket = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    target_prefix = "s3/govuk-${var.aws_environment}-cdn-logs-monitor-archive/"
  }
}
