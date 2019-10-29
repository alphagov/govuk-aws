variable "aws_environment" {
  type        = "string"
  description = "AWS Environment"
}

variable "aws_region" {
  type        = "string"
  description = "AWS region"
  default     = "eu-west-1"
}

variable "bucket_name" {
  type    = "string"
  default = "govuk-mongodb-backup-s3"
}

variable "username" {
  type    = "string"
  default = "govuk-mongodb-backup-s3"
}

variable "stackname" {
  type        = "string"
  description = "Stackname"
}

terraform {
  backend          "s3"             {}
  required_version = "= 0.11.14"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "2.33.0"
}

resource "template_file" "readwrite_policy_file" {
  template = "${file("templates/readwrite_policy.tpl")}"

  vars {
    bucket_name     = "${var.bucket_name}"
    aws_environment = "${var.aws_environment}"
  }
}

module "govuk-mongodb-backup-s3" {
  source                       = "../../modules/aws/s3_bucket_lifecycle"
  aws_environment              = "${var.aws_environment}"
  bucket_name                  = "${var.bucket_name}-${var.aws_environment}"
  target_bucketid_for_logs     = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  target_prefix_for_logs       = "s3/${var.bucket_name}-${var.aws_environment}/"
  enable_noncurrent_expiration = "true"
}

module "govuk-mongodb-backup-s3-daily" {
  source                       = "../../modules/aws/s3_bucket_lifecycle"
  aws_environment              = "${var.aws_environment}"
  bucket_name                  = "${var.bucket_name}-daily-${var.aws_environment}"
  target_bucketid_for_logs     = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  target_prefix_for_logs       = "s3/${var.bucket_name}-daily-${var.aws_environment}/"
  enable_noncurrent_expiration = "true"
}

resource "aws_iam_policy" "readwrite_policy" {
  name        = "${var.bucket_name}_${var.username}-policy"
  description = "${var.bucket_name} allows writes"
  policy      = "${template_file.readwrite_policy_file.rendered}"
}

resource "aws_iam_user" "iam_user" {
  name = "${var.username}"
}

resource "aws_iam_policy_attachment" "iam_policy_attachment" {
  name       = "${var.bucket_name}_${var.username}_attachment_policy"
  users      = ["${aws_iam_user.iam_user.name}"]
  policy_arn = "${aws_iam_policy.readwrite_policy.arn}"
}
