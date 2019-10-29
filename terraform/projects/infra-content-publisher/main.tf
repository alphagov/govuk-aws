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

variable "aws_replica_region" {
  type        = "string"
  description = "AWS region"
  default     = "eu-west-2"
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

resource "aws_s3_bucket" "activestorage" {
  bucket = "govuk-${var.aws_environment}-content-publisher-activestorage"

  tags {
    Name            = "govuk-${var.aws_environment}-content-publisher-activestorage"
    aws_environment = "${var.aws_environment}"
  }

  logging {
    target_bucket = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    target_prefix = "s3/govuk-${var.aws_environment}-content-publisher-activestorage/"
  }

  versioning {
    enabled = true
  }

  replication_configuration {
    role = "${aws_iam_role.govuk_content_publisher_activestorage_replication_role.arn}"

    rules {
      id     = "govuk-content-publisher-activestorage-replication-whole-bucket-rule"
      prefix = ""
      status = "Enabled"

      destination {
        bucket        = "${aws_s3_bucket.activestorage_replica.arn}"
        storage_class = "STANDARD"
      }
    }
  }
}

resource "aws_s3_bucket" "activestorage_replica" {
  bucket   = "govuk-${var.aws_environment}-content-publisher-activestorage-replica"
  region   = "${var.aws_replica_region}"
  provider = "aws.aws_replica"

  tags {
    Name            = "govuk-${var.aws_environment}-content-publisher-activestorage-replica"
    aws_environment = "${var.aws_environment}"
  }

  versioning {
    enabled = true
  }
}

data "template_file" "s3_govuk_content_publisher_activestorage_replication_role_template" {
  template = "${file("${path.module}/../../policies/s3_govuk_content_publisher_activestorage_replication_role.tpl")}"
}

resource "aws_iam_role" "govuk_content_publisher_activestorage_replication_role" {
  name               = "${var.stackname}-content-publisher-activestorage-replication-role"
  assume_role_policy = "${data.template_file.s3_govuk_content_publisher_activestorage_replication_role_template.rendered}"
}

data "template_file" "s3_govuk_content_publisher_activestorage_policy_template" {
  template = "${file("${path.module}/../../policies/s3_govuk_content_publisher_activestorage_replication_policy.tpl")}"

  vars {
    govuk_content_publisher_activestorage_arn         = "${aws_s3_bucket.activestorage.arn}"
    govuk_content_publisher_activestorage_replica_arn = "${aws_s3_bucket.activestorage_replica.arn}"
  }
}

resource "aws_iam_policy" "govuk_content_publisher_activestorage_replication_policy" {
  name        = "govuk-${var.aws_environment}-content-publisher-activestorage-replication-policy"
  policy      = "${data.template_file.s3_govuk_content_publisher_activestorage_policy_template.rendered}"
  description = "Allows replication of the content publisher activestorage bucket"
}

resource "aws_iam_policy_attachment" "govuk_content_publisher_activestorage_replication_policy_attachment" {
  name       = "s3-govuk-content-publisher-activestorage-replication-policy-attachment"
  roles      = ["${aws_iam_role.govuk_content_publisher_activestorage_replication_role.name}"]
  policy_arn = "${aws_iam_policy.govuk_content_publisher_activestorage_replication_policy.arn}"
}

resource "aws_iam_user" "app_user" {
  name = "govuk-${var.aws_environment}-content-publisher-app"
}

resource "aws_iam_policy" "s3_writer" {
  name   = "govuk-${var.aws_environment}-content-publisher-app-s3-writer-policy"
  policy = "${data.template_file.s3_writer_policy.rendered}"
}

resource "aws_iam_policy_attachment" "s3_writer" {
  name       = "govuk-${var.aws_environment}-content-publisher-s3-writer-policy-attachment"
  users      = ["${aws_iam_user.app_user.name}"]
  policy_arn = "${aws_iam_policy.s3_writer.arn}"
}

data "template_file" "s3_writer_policy" {
  template = "${file("s3_writer_policy.tpl")}"

  vars {
    bucket = "${aws_s3_bucket.activestorage.id}"
  }
}
