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
  version = "2.33.0"
}

provider "aws" {
  region  = "${var.aws_replica_region}"
  alias   = "aws_replica"
  version = "2.33.0"
}

resource "aws_s3_bucket" "custom_formats_mapit" {
  bucket = "${var.bucket_name}-${var.aws_environment}"

  tags {
    Environment = "${var.aws_environment}"
    Team        = "custom_formats"
  }

  versioning {
    enabled = true
  }

  replication_configuration {
    role = "${aws_iam_role.govuk_custom_formats_mapit_storage_replication_role.arn}"

    rules {
      id     = "govuk-custom-formats-mapit-storage-replication-whole-bucket-rule"
      prefix = ""
      status = "Enabled"

      destination {
        bucket        = "${aws_s3_bucket.custom_formats_mapit_replica.arn}"
        storage_class = "STANDARD"
      }
    }
  }
}

resource "aws_s3_bucket" "custom_formats_mapit_replica" {
  bucket   = "${var.bucket_name}-replica-${var.aws_environment}"
  region   = "${var.aws_replica_region}"
  provider = "aws.aws_replica"

  tags {
    Name            = "custom_formats_mapit_replica"
    aws_environment = "${var.aws_environment}"
  }

  versioning {
    enabled = true
  }
}

data "template_file" "s3_govuk_custom_formats_mapit_storage_replication_role_template" {
  template = "${file("${path.module}/../../policies/s3_backup_replica_role.tpl")}"
}

resource "aws_iam_role" "govuk_custom_formats_mapit_storage_replication_role" {
  name               = "${var.stackname}-custom-formats-mapit-storage-replication-role"
  assume_role_policy = "${data.template_file.s3_govuk_custom_formats_mapit_storage_replication_role_template.rendered}"
}

data "template_file" "s3_govuk_custom_formats_mapit_storage_replication_policy_template" {
  template = "${file("${path.module}/../../policies/s3_backup_replica_policy.json")}"

  vars {
    govuk_s3_bucket = "${aws_s3_bucket.custom_formats_mapit.arn}"
    govuk_s3_backup = "${aws_s3_bucket.custom_formats_mapit_replica.arn}"
  }
}

resource "aws_iam_policy" "govuk_custom_formats_mapit_storage_replication_policy" {
  name        = "govuk-custom-formats_mapit-storage-replication-policy"
  policy      = "${data.template_file.s3_govuk_custom_formats_mapit_storage_replication_policy_template.rendered}"
  description = "Allows replication of the govuk-custom-formats-mapit-storage bucket"
}

resource "aws_iam_policy_attachment" "govuk_custom_formats_mapit_storage_replication_policy_attachment" {
  name       = "s3-govuk-custom-formats-mapit-storage-replication-policy-attachment"
  roles      = ["${aws_iam_role.govuk_custom_formats_mapit_storage_replication_role.name}"]
  policy_arn = "${aws_iam_policy.govuk_custom_formats_mapit_storage_replication_policy.arn}"
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
