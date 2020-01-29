/**
* ## Project: app-developer-docs
*
* Creates S3 bucket for govuk-developer-docs
*
* Migrated from:
* https://github.com/alphagov/govuk-terraform-provisioning/tree/master/projects/developer_docs
*
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
  default = "govuk-developer-documentation"
}

variable "aws_replica_region" {
  type        = "string"
  description = "AWS region"
  default     = "eu-west-2"
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

resource "aws_iam_user" "developer-docs-user" {
  name = "${var.bucket_name}_user"
}

data "template_file" "developer_docs_automated_read_write" {
  template = "${file("templates/read_write_user.tpl")}"

  vars {
    bucket_name     = "${var.bucket_name}"
    aws_environment = "${var.aws_environment}"
    owner           = "Finding Things"
  }
}

resource "aws_iam_policy" "developer_docs_automated_read_write" {
  name        = "${var.bucket_name}_user_policy"
  description = "${var.bucket_name} allows read/write"
  policy      = "${data.template_file.developer_docs_automated_read_write.rendered}"
}

resource "aws_iam_policy_attachment" "developer_docs_attachment" {
  name       = "${var.bucket_name}_user_attachment_policy"
  users      = ["${aws_iam_user.developer-docs-user.name}"]
  policy_arn = "${aws_iam_policy.developer_docs_automated_read_write.arn}"
}

resource "aws_s3_bucket" "developer_docs" {
  bucket = "${var.bucket_name}-${var.aws_environment}"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}
