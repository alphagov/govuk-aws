/**
* ## Project: app-custom-formats-mapit-storage
*
* Creates S3 bucket for custom-formats-mapit
*
* Migrated from:
* https://github.com/alphagov/govuk-terraform-provisioning/tree/master/projects/custom_formats_mapit_storage
*
* NOTES: currently the policy does not have any attachment
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
  default = "govuk-custom-formats-mapit-storage"
}

# Resources
# --------------------------------------------------------------

terraform {
  backend          "s3"             {}
  required_version = "= 0.11.14"
}

resource "aws_s3_bucket" "custom_formats_mapit" {
  bucket = "${var.bucket_name}-${var.aws_environment}"

  tags {
    Environment = "${var.aws_environment}"
    Team        = "custom_formats"
  }
}

resource "aws_iam_policy" "developer_readwrite" {
  name        = "${var.bucket_name}_developer_readwrite_policy"
  description = "${var.bucket_name} allows developer read / write access"
  policy      = "${data.aws_iam_policy_document.developer_readwrite.json}"
}

resource "aws_iam_policy_attachment" "publishing_api_event_log_developer_readwrite_attachment" {
  name       = "${var.bucket_name}_developer_readwrite_attachment_policy"
  groups     = []
  policy_arn = "${aws_iam_policy.developer_readwrite.arn}"
}
