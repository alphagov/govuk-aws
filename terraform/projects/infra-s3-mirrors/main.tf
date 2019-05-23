/**
* ## Project: infra-s3-mirrors
*
* This creates two s3 buckets
*
* govuk-mirror-{env}-access-logs: The bucket that will hold the access logs
* govuk-mirror-{env}: The bucket that will hold the mirror content
*
*/

variable "aws_environment" {
  type        = "string"
  description = "AWS Environment"
}

variable "aws_region" {
  type        = "string"
  description = "AWS region"
  default     = "eu-west-1"
}

# Resources
# --------------------------------------------------------------

# Set up the backend & provider for each region
terraform {
  backend          "s3"             {}
  required_version = "= 0.11.7"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "1.40.0"
}

resource "aws_s3_bucket" "govuk_mirror_access_logs" {
  bucket = "govuk-mirror-${var.aws_environment}-access-logs"
  acl    = "log-delivery-write"
}

module "govuk_mirror" {
  source                       = "../../modules/aws/s3_bucket_lifecycle"
  aws_environment              = "${var.aws_environment}"
  bucket_name                  = "govuk-mirror-${var.aws_environment}"
  target_bucketid_for_logs     = "${aws_s3_bucket.govuk_mirror_access_logs.id}"
  enable_noncurrent_expiration = "true"
}

resource "aws_s3_bucket_policy" "govuk_mirror_read_policy" {
  bucket = "${module.govuk_mirror.bucket_id}"
  policy = "${data.aws_iam_policy_document.s3_mirror_read_policy_doc.json}"
}
