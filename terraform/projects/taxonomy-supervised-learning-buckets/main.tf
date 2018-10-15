/**
* ## Project: taxonomy-supervised-learning-buckets
*
* This creates
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

variable "remote_state_bucket" {
  type        = "string"
  description = "S3 bucket we store our terraform state in"
}

variable "remote_state_infra_monitoring_key_stack" {
  type        = "string"
  description = "Override stackname path to infra_monitoring remote state "
  default     = ""
}

variable "office_ips" {
  type        = "list"
  description = "A list of the office IPs"
}

# Set up the backend & provider for each region
terraform {
  backend          "s3"             {}
  required_version = "= 0.11.1"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "1.0.0"
}

resource "aws_s3_bucket" "source-data" {
  bucket = "govuk-${var.aws_environment}-source-data"

  tags {
    Name            = "govuk-${var.aws_environment}-taxonomy-source-data"
    aws_environment = "${var.aws_environment}"
  }

  logging {
    target_bucket = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    target_prefix = "s3/govuk-${var.aws_environment}-source-data/"
  }
}
