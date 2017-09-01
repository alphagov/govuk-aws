# == Manifest: projects:: Wraith-bucket :: buckets
#
# This creates 2 s3 buckets
#
# * wraith-logs -- The bucket that will hold the logs produced by wraith
# * wraith_access_logs -- Bucket for logs to go to
#
# === Variables:
#
# aws_region
# aws_environment
#
# === Outputs:
#

variable "aws_region" {
  type        = "string"
  description = "AWS region"
  default     = "eu-west-1"
}

variable "aws_environment" {
  type        = "string"
  description = "AWS Environment"
}

# Set up the backend & provider for each region
terraform {
  backend          "s3"             {}
  required_version = "= 0.9.10"
}

provider "aws" {
  region = "${var.aws_region}"
}

# Create the buckets
# Logs bucket
resource "aws_s3_bucket" "wraith_access_logs" {
  bucket = "govuk-${var.aws_environment}-wraith-access-logs"
  acl    = "log-delivery-write"

  versioning {
    enabled = true
  }
}

# Main bucket
resource "aws_s3_bucket" "wraith" {
  bucket = "govuk-${var.aws_environment}-wraith"
  acl    = "public-read"

  tags {
    Name            = "govuk-${var.aws_environment}-wraith"
    aws_environment = "${var.aws_environment}"
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = "${aws_s3_bucket.wraith_access_logs.id}"
    target_prefix = "log/"
  }
}
