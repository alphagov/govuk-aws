/**
* ## Module: projects/infra-dev_vm
*
* Creates an S3 bucket to store the development VMs used in govuk-puppet
* Vagrantfile
*
* Mifrated from:
* https://github.com/alphagov/govuk-terraform-provisioning/tree/master/old-projects/dev_vm
*/

variable "aws_region" {
  type        = "string"
  description = "AWS region"
  default     = "eu-west-1"
}

variable "stackname" {
  type        = "string"
  description = "Stackname"
  default     = ""
}

variable "aws_environment" {
  type        = "string"
  description = "AWS Environment"
}

variable "bucket_name" {
  type    = "string"
  default = "govuk-dev-boxes"
}

variable "team" {
  type    = "string"
  default = "Infrastructure"
}

variable "username" {
  type    = "string"
  default = "govuk-dev-box-uploader"
}

# Resources
# --------------------------------------------------------------

terraform {
  backend "s3" {}
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "2.33.0"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "${var.bucket_name}-${var.aws_environment}"
  policy = "${data.aws_iam_policy_document.readonly_policy.json}"

  tags {
    Environment = "${var.aws_environment}"
    Team        = "${var.team}"
  }
}

resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket = "${aws_s3_bucket.bucket.id}"

  block_public_acls   = false
  block_public_policy = false
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
