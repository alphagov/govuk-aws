/**
* ## Project: app-wal-e-backups-postgresql
*
* Creates S3 bucket for postgresql wal-e-backups
*
* Migrated from:
* https://github.com/alphagov/govuk-terraform-provisioning/tree/master/old-projects/wal-e_backups_postgresql
*/
variable "aws_region" {
  type        = "string"
  description = "AWS region"
  default     = "eu-west-1"
}

variable "stackname" {
  type        = "string"
  description = "Stackname"
}

variable "aws_environment" {
  type        = "string"
  description = "AWS Environment"
}

variable "bucket_name" {
  type    = "string"
  default = "govuk-wal-e-backups-postgresql"
}

variable "team" {
  type    = "string"
  default = "Infrastructure"
}

variable "username" {
  type    = "string"
  default = "govuk-wal-e-backups-postgresql"
}

variable "versioning" {
  type    = "string"
  default = "false"
}

variable "lifecycle" {
  type    = "string"
  default = "false"
}

variable "lifecycle_with_transition" {
  type    = "string"
  default = false
}

variable "days_to_keep" {
  type    = "string"
  default = 91
}

# Resources
# --------------------------------------------------------------

terraform {
  backend "s3" {}
  required_version = "= 0.11.15"
}

resource "aws_s3_bucket" "bucket" {
  count = "${1 - var.lifecycle_with_transition}"

  bucket = "${var.bucket_name}-${var.aws_environment}"
  acl    = "private"

  tags {
    Environment = "${var.aws_environment}"
    Team        = "${var.team}"
  }

  versioning {
    enabled = "${var.versioning}"
  }

  lifecycle_rule {
    prefix  = ""
    enabled = "${var.lifecycle}"

    noncurrent_version_expiration {
      days = 5
    }

    expiration {
      days = 5
    }
  }
}

resource "aws_s3_bucket" "bucket_with_transition" {
  count = "${var.lifecycle_with_transition}"

  bucket = "${var.bucket_name}-${var.aws_environment}"
  acl    = "private"

  tags {
    Environment = "${var.aws_environment}"
    Team        = "${var.team}"
  }

  versioning {
    enabled = "${var.versioning}"
  }

  lifecycle_rule {
    prefix  = ""
    enabled = "${var.lifecycle}"

    transition {
      storage_class = "STANDARD_IA"
      days          = 30
    }

    transition {
      storage_class = "GLACIER"
      days          = 90
    }

    expiration {
      days                         = "${var.days_to_keep}"
      expired_object_delete_marker = false
    }
  }
}

resource "aws_iam_policy" "readwrite_policy" {
  name        = "${var.bucket_name}_${var.username}-policy"
  description = "${var.bucket_name} allows writes"
  policy      = "${data.aws_iam_policy_document.readwrite_policy.json}"
}

resource "aws_iam_user" "iam_user" {
  name = "${var.username}"
}

resource "aws_iam_policy_attachment" "iam_policy_attachment" {
  name       = "${var.bucket_name}_${var.username}_attachment_policy"
  users      = ["${aws_iam_user.iam_user.name}"]
  policy_arn = "${aws_iam_policy.readwrite_policy.arn}"
}
