/**
* ## Project: infra-ask-export
*
* GOV.UK Ask Export
*
* This data export process requires cross account permissions to S3 as an export target. Outside of the production environment, this terraform can be configured to create a bucket.
*/

variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-1"
}

variable "aws_environment" {
  type        = string
  description = "AWS Environment"
}

variable "stackname" {
  type        = string
  description = "Stackname"
}

variable "export_s3_bucket_name" {
  type        = string
  description = "Bucket name to allow write permissions"
}

variable "create_bucket" {
  type        = string
  description = "Whether to create the bucket, in production we're expecting to use a bucket in a different AWS account - should be specified as a string boolean, terraform 0.11 doesn't have booleans"
  default     = "false"
}

# Resources
# --------------------------------------------------------------
terraform {
  backend "s3" {}
  required_version = "~> 0.12.31"
}

provider "aws" {
  region  = var.aws_region
  version = "2.46.0"
}

resource "aws_s3_bucket" "ask_export_bucket" {
  count  = var.create_bucket ? 1 : 0
  bucket = var.export_s3_bucket_name

  tags {
    Name            = var.export_s3_bucket_name
    aws_environment = var.aws_environment
  }
}

resource "aws_iam_user" "ask_export" {
  name = "govuk-${var.aws_environment}-ask-export"
}

resource "aws_iam_policy" "ask_export_s3_writer" {
  name        = "govuk-${var.aws_environment}-ask-export-s3-writer-policy"
  policy      = data.template_file.s3_writer_policy_template.rendered
  description = "Allows write permission to specific S3 buckets"
}

resource "aws_iam_policy_attachment" "s3_writer" {
  name       = "ask-export-s3-writer-policy-attachment"
  users      = ["${aws_iam_user.ask_export.name}"]
  policy_arn = aws_iam_policy.ask_export_s3_writer.arn
}

data "template_file" "s3_writer_policy_template" {
  template = file("${path.module}/../../policies/ask_export_s3_writer_policy.tpl")

  vars {
    bucket = var.export_s3_bucket_name
  }
}
