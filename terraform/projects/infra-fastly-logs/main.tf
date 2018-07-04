/**
* ## Project: infra-fastly-logs
*
* Manages the Fastly logging data which is sent from Fastly to S3.
*/
variable "aws_region" {
  type        = "string"
  description = "AWS region"
  default     = "eu-west-1"
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
  required_version = "= 0.11.7"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "1.25.0"
}

resource "aws_s3_bucket" "fastly_logs" {
  bucket = "govuk-${var.aws_environment}-fastly-logs"

  tags {
    Name            = "govuk-${var.aws_environment}-fastly-logs"
    aws_environment = "${var.aws_environment}"
  }

  logging {
    target_bucket = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    target_prefix = "s3/govuk-${var.aws_environment}-fastly-logs/"
  }
}

# We require a user for Fastly to write to S3 buckets
resource "aws_iam_user" "logs_writer" {
  name = "govuk-${var.aws_environment}-fastly-logs-writer"
}

resource "aws_iam_policy" "logs_writer" {
  name        = "fastly-logs-${var.aws_environment}-logs-writer-policy"
  policy      = "${data.template_file.logs_writer_policy_template.rendered}"
  description = "Allows writing to to the fastly-logs bucket"
}

resource "aws_iam_policy_attachment" "logs_writer" {
  name       = "logs-writer-policy-attachment"
  users      = ["${aws_iam_user.logs_writer.name}"]
  policy_arn = "${aws_iam_policy.logs_writer.arn}"
}

data "template_file" "logs_writer_policy_template" {
  template = "${file("${path.module}/../../policies/fastly_logs_writer_policy.tpl")}"

  vars {
    aws_environment = "${var.aws_environment}"
    bucket          = "${aws_s3_bucket.fastly_logs.id}"
  }
}

resource "aws_glue_catalog_database" "fastly_logs" {
  name        = "fastly_logs"
  description = "Used to browse the CDN log files that Fastly sends"
}

resource "aws_iam_role_policy_attachment" "aws-glue-service-role-service-attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
  role       = "${aws_iam_role.glue.name}"
}

resource "aws_iam_role" "glue" {
  name               = "AWSGlueServiceRole-fastly-logs"
  // I did want to set a path of /service-role/ here but that seems to break
  // creating the crawler
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "glue.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "fastly_logs_policy" {
  name = "govuk-${var.aws_environment}-fastly-logs-glue-policy"
  role = "${aws_iam_role.glue.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.fastly_logs.id}",
        "arn:aws:s3:::${aws_s3_bucket.fastly_logs.id}/*"
      ]
    }
  ]
}
EOF
}

# Outputs
# --------------------------------------------------------------

output "logs_writer_bucket_policy_arn" {
  value       = "${aws_iam_policy.logs_writer.arn}"
  description = "ARN of the logs writer bucket policy"
}
