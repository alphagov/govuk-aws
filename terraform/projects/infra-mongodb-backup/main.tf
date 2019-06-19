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

variable "team" {
  type    = "string"
  default = "Infrastructure"
}

variable "username" {
  type    = "string"
  default = "govuk-mongodb-backup-s3"
}

variable "versioning" {
  type    = "string"
  default = "true"
}

terraform {
  backend          "s3"             {}
  required_version = "= 0.11.14"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "1.60.0"
}

resource "template_file" "readwrite_policy_file" {
  template = "${file("templates/readwrite_policy.tpl")}"

  vars {
    bucket_name     = "${var.bucket_name}"
    aws_environment = "${var.aws_environment}"
  }
}

resource "aws_s3_bucket" "govuk-mongodb-backup-s3" {
  bucket = "${var.bucket_name}-${var.aws_environment}"

  tags {
    Environment = "${var.aws_environment}"
    Team        = "${var.team}"
  }

  versioning {
    enabled = "${var.versioning}"
  }

  lifecycle_rule {
    prefix  = ""
    enabled = true

    expiration {
      days = 7
    }

    noncurrent_version_expiration {
      days = 7
    }
  }
}

resource "aws_s3_bucket" "govuk-mongodb-backup-s3-daily" {
  bucket = "${var.bucket_name}-daily-${var.aws_environment}"

  tags {
    Environment = "${var.aws_environment}"
    Team        = "${var.team}"
  }

  versioning {
    enabled = "${var.versioning}"
  }

  lifecycle_rule {
    prefix  = ""
    enabled = true

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }

    expiration {
      days = 365
    }
  }
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
