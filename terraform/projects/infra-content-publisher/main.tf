/**
* ## Project: infra-content-publisher
*
* Stores ActiveStorage blobs uploaded via Content Publisher.
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
  required_version = "= 0.11.7"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "1.40.0"
}

resource "aws_s3_bucket" "content_publisher_activestorage" {
  bucket = "govuk-${var.aws_environment}-content-publisher-activestorage"

  tags {
    Name            = "govuk-${var.aws_environment}-content-publisher-activestorage"
    aws_environment = "${var.aws_environment}"
  }

  logging {
    target_bucket = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    target_prefix = "s3/govuk-${var.aws_environment}-content-publisher-activestorage/"
  }
}

resource "aws_iam_user" "content_publisher_app" {
  name = "govuk-${var.aws_environment}-content-publisher-app"
}

resource "aws_iam_policy" "s3_writer" {
  name        = "govuk-${var.aws_environment}-content-publisher-app-s3-writer-policy"
  policy      = "${data.template_file.s3_writer_policy_template.rendered}"
  description = "Allows writing to to the govuk-${var.aws_environment}-content-publisher-activestorage"
}

resource "aws_iam_policy_attachment" "s3_writer" {
  name       = "archive-writer-policy-attachment"
  users      = ["${aws_iam_user.content_publisher_app.name}"]
  policy_arn = "${aws_iam_policy.s3_writer.arn}"
}

data "template_file" "s3_writer_policy_template" {
  template = "${file("${path.module}/../../policies/content_publisher_s3_writer_policy.tpl")}"

  vars {
    aws_environment = "${var.aws_environment}"
    bucket          = "${aws_s3_bucket.content_publisher_activestorage.id}"
  }
}

# Outputs
# --------------------------------------------------------------

output "s3_writer_bucket_policy_arn" {
  value       = "${aws_iam_policy.s3_writer.arn}"
  description = "ARN of the S3 writer bucket policy"
}
