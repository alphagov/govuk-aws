/**
* ## Project: graphite-backups-bucket
*
* This creates an s3 bucket for storing the Graphite backups of whisper files
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

variable "expiration_time" {
  type        = "string"
  description = "Expiration time in days of S3 Objects"
  default     = "7"
}

# Resources
# --------------------------------------------------------------
terraform {
  backend "s3" {}
  required_version = "= 0.11.15"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "2.46.0"
}

resource "aws_s3_bucket" "graphite_backups" {
  bucket = "govuk-${var.aws_environment}-graphite-backups"
  region = "${var.aws_region}"

  tags {
    Name            = "govuk-${var.aws_environment}-graphite-backups"
    aws_environment = "${var.aws_environment}"
  }

  logging {
    target_bucket = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    target_prefix = "s3/govuk-${var.aws_environment}-graphite-backups/"
  }

  lifecycle_rule {
    enabled = true

    expiration {
      days = "${var.expiration_time}"
    }
  }
}

resource "aws_iam_policy" "graphite_backups_access" {
  name        = "govuk-${var.aws_environment}-graphite-backups-access-policy"
  policy      = "${data.aws_iam_policy_document.graphite_backups_access.json}"
  description = "Allows read/write access to the graphite_backups bucket"
}

data "aws_iam_policy_document" "graphite_backups_access" {
  statement {
    sid = "ReadListOfBuckets"

    actions = [
      "s3:ListAllMyBuckets",
    ]

    resources = ["*"]
  }

  statement {
    sid = "ReadBucketLists"

    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.graphite_backups.id}",
    ]
  }

  statement {
    sid = "AccessObjects"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.graphite_backups.id}",
      "arn:aws:s3:::${aws_s3_bucket.graphite_backups.id}/*",
    ]
  }
}

# Outputs
#--------------------------------------------------------------

output "s3_graphite_backups_bucket_name" {
  value       = "${aws_s3_bucket.graphite_backups.id}"
  description = "The name of the graphite backups bucket"
}

output "access_graphite_backups_bucket_policy_arn" {
  value       = "${aws_iam_policy.graphite_backups_access.arn}"
  description = "ARN of the access graphite-backups-bucket policy"
}
