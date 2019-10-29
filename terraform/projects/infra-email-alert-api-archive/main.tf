/**
* ## Project: infra-email-alert-archive
*
* Stores log data from Email Alert API of all of the emails sent for analytics
* purposes.
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
  required_version = "= 0.11.14"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "2.33.0"
}

resource "aws_s3_bucket" "email_alert_api_archive" {
  bucket = "govuk-${var.aws_environment}-email-alert-api-archive"

  tags {
    Name            = "govuk-${var.aws_environment}-email-alert-api-archive"
    aws_environment = "${var.aws_environment}"
  }

  logging {
    target_bucket = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    target_prefix = "s3/govuk-${var.aws_environment}-email-alert-api-archive/"
  }
}

resource "aws_iam_user" "email_alert_api_app" {
  name = "govuk-${var.aws_environment}-email-alert-api-app"
}

resource "aws_iam_policy" "s3_writer" {
  name        = "govuk-${var.aws_environment}-email-alert-api-s3-writer-policy"
  policy      = "${data.template_file.s3_writer_policy_template.rendered}"
  description = "Allows writing to to the govuk-${var.aws_environment}-email-alert-api-archive bucket"
}

resource "aws_iam_policy_attachment" "s3_writer" {
  name       = "archive-writer-policy-attachment"
  users      = ["${aws_iam_user.email_alert_api_app.name}"]
  policy_arn = "${aws_iam_policy.s3_writer.arn}"
}

data "template_file" "s3_writer_policy_template" {
  template = "${file("${path.module}/../../policies/email_alert_api_s3_writer_policy.tpl")}"

  vars {
    aws_environment = "${var.aws_environment}"
    bucket          = "${aws_s3_bucket.email_alert_api_archive.id}"
  }
}

resource "aws_glue_catalog_database" "email_archive" {
  name        = "email_alert_api_archive"
  description = "Stores email sent data from the email-alert-api application"
}

resource "aws_iam_role_policy_attachment" "aws-glue-service-role-service-attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
  role       = "${aws_iam_role.glue.name}"
}

resource "aws_iam_role" "glue" {
  name = "AWSGlueServiceRole-email-alert-api-archive"

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

resource "aws_iam_role_policy" "glue_policy" {
  name = "govuk-${var.aws_environment}-email-alert-api-archive-glue-policy"
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
        "arn:aws:s3:::${aws_s3_bucket.email_alert_api_archive.id}",
        "arn:aws:s3:::${aws_s3_bucket.email_alert_api_archive.id}/*"
      ]
    }
  ]
}
EOF
}

resource "aws_glue_crawler" "email_archive" {
  name          = "Email Alert API Archive"
  description   = "Crawls the JSON logs provided by Email Alert API"
  database_name = "${aws_glue_catalog_database.email_archive.name}"
  role          = "${aws_iam_role.glue.name}"
  schedule      = "cron(30 */4 * * ? *)"

  s3_target {
    path = "s3://${aws_s3_bucket.email_alert_api_archive.bucket}/email-archive"
  }

  schema_change_policy {
    delete_behavior = "DEPRECATE_IN_DATABASE"
    update_behavior = "LOG"
  }

  configuration = <<EOF
{
  "Version": 1.0,
  "CrawlerOutput": {
    "Partitions": {
      "AddOrUpdateBehavior": "InheritFromTable"
    }
  }
}
EOF
}

resource "aws_glue_catalog_table" "email_archive" {
  name          = "email_archive"
  description   = "Maps the JSON output to a database schema"
  database_name = "${aws_glue_catalog_database.email_archive.name}"
  table_type    = "EXTERNAL_TABLE"

  storage_descriptor {
    compressed    = true
    location      = "s3://${aws_s3_bucket.email_alert_api_archive.bucket}/email-archive/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      name = "ser_de_name"

      parameters {
        paths = "archived_at_utc,content_change,created_at_utc,finished_sending_at_utc,id,sent,subject,subscriber_id"
      }

      serialization_library = "org.openx.data.jsonserde.JsonSerDe"
    }

    columns = [
      {
        name    = "id"
        type    = "string"
        comment = "UUID that corresponds with the entry in the email table"
      },
      {
        name    = "finished_sending_at_utc"
        type    = "timestamp"
        comment = "Time the email was sent or when we aborted trying to send the email"
      },
      {
        name    = "sent"
        type    = "boolean"
        comment = "Whether the email was sent or not"
      },
      {
        name    = "subscriber_id"
        type    = "bigint"
        comment = "ID which corresponds with the entry in the subscribers table in Email Alert API"
      },
      {
        name    = "subject"
        type    = "string"
        comment = "Subject of the Email"
      },
      {
        name    = "content_change"
        type    = "struct<content_change_ids:array<string>,digest_run_id:int,subscription_ids:array<string>>"
        comment = "Data specifically associated with a content change. Present if this email was sent for one"
      },
      {
        name    = "created_at_utc"
        type    = "timestamp"
        comment = "Time the email was generated in Email Alert API"
      },
      {
        name    = "archived_at_utc"
        type    = "timestamp"
        comment = "Time that this Email was archvied"
      },
    ]
  }

  // these correspond to directory ordering of:
  // /year=YYYY/month=MM/date=DD/file.json.gz
  partition_keys = [
    {
      name = "year"
      type = "int"
    },
    {
      name = "month"
      type = "int"
    },
    {
      name = "date"
      type = "int"
    },
  ]

  parameters {
    classification  = "json"
    compressionType = "gzip"
    typeOfData      = "file"
  }
}

# Outputs
# --------------------------------------------------------------

output "s3_writer_bucket_policy_arn" {
  value       = "${aws_iam_policy.s3_writer.arn}"
  description = "ARN of the S3 writer bucket policy"
}
