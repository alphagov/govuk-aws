/**
* ## Project: app-govuk-attachments
*
* Creates S3 bucket for asset master attachments storage
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
  default = "govuk-attachments"
}

variable "team" {
  type    = "string"
  default = "Infrastructure"
}

variable "username" {
  type    = "string"
  default = "govuk-attachments"
}

variable "versioning" {
  type    = "string"
  default = "true"
}

variable "lifecycle" {
  type    = "string"
  default = false
}

variable "days_to_keep" {
  type    = "string"
  default = 30
}

variable "additional_policy_attachment_roles" {
  type        = "list"
  description = "Additional roles to attach to the readwrite policy, for legacy compatibility."
  default     = []
}

# Resources
# --------------------------------------------------------------

terraform {
  backend          "s3"             {}
  required_version = "= 0.11.14"
}

resource "aws_s3_bucket" "bucket" {
  count = "${var.lifecycle}"

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

    expiration {
      days = "${var.days_to_keep}"
    }
  }
}

resource "aws_s3_bucket" "bucket_without_lifecycle" {
  count = "${1 - var.lifecycle}"

  bucket = "${var.bucket_name}-${var.aws_environment}"
  acl    = "private"

  tags {
    Environment = "${var.aws_environment}"
    Team        = "${var.team}"
  }

  versioning {
    enabled = "${var.versioning}"
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
  roles      = ["${var.additional_policy_attachment_roles}"]
  policy_arn = "${aws_iam_policy.readwrite_policy.arn}"
}
