/**
* ## Project: infra-assets
*
* Stores ActiveStorage blobs uploaded via Content Publisher.
*/

variable "aws_region" {
  type        = "string"
  description = "AWS region"
  default     = "eu-west-1"
}

variable "aws_backup_region" {
  type        = "string"
  description = "AWS backup region"
  default     = "eu-west-2"
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

resource "aws_s3_bucket" "assets" {
  bucket = "govuk-assets-${var.aws_environment}"

  tags {
    Name            = "govuk-assets-${var.aws_environment}"
    aws_environment = "${var.aws_environment}"
  }

  logging {
    target_bucket = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    target_prefix = "s3/govuk-assets-${var.aws_environment}/"
  }

  versioning {
    enabled = true
  }

  replication_configuration {
    role = "${aws_iam_role.backup.arn}"

    rules {
      id     = "govuk-${var.aws_environment}-assets-replication-rule"
      prefix = ""
      status = "Enabled"

      destination {
        bucket        = "${aws_s3_bucket.assets_backup.arn}"
        storage_class = "STANDARD"
      }
    }
  }
}

resource "aws_iam_user" "app_user" {
  name = "govuk-assets-${var.aws_environment}-user"
}

resource "aws_iam_policy" "s3_writer" {
  name   = "govuk-${var.aws_environment}-assets-s3-writer-policy"
  policy = "${data.template_file.s3_writer_policy.rendered}"
}

resource "aws_iam_policy_attachment" "s3_writer" {
  name       = "govuk-${var.aws_environment}-assets-s3-writer-policy-attachment"
  users      = ["${aws_iam_user.app_user.name}"]
  policy_arn = "${aws_iam_policy.s3_writer.arn}"
}

data "template_file" "s3_writer_policy" {
  template = "${file("s3_writer_policy.tpl")}"

  vars {
    bucket = "${aws_s3_bucket.assets.id}"
  }
}
