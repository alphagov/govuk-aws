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

resource "aws_glue_crawler" "govuk_www" {
  name          = "GOV.UK fastly logs"
  description   = "Crawls the GOV.UK logs from fastly for allowing Athena querying"
  database_name = "${aws_glue_catalog_database.fastly_logs.name}"
  role          = "${aws_iam_role.glue.name}"
  schedule      = "cron(30 */4 * * ? *)"

  s3_target {
    path = "s3://${aws_s3_bucket.fastly_logs.bucket}/govuk_www"
  }

  schema_change_policy {
    delete_behavior = "DELETE_FROM_DATABASE"
    update_behavior = "LOG"
  }

  configuration  = <<EOF
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

resource "aws_glue_catalog_table" "govuk_www" {
  name          = "govuk_www"
  description   = "Maps the tab-seperated value log file to columns"
  database_name = "${aws_glue_catalog_database.fastly_logs.name}"
  table_type    = "EXTERNAL_TABLE"

  storage_descriptor {
    compressed    = true
    location      = "s3://${aws_s3_bucket.fastly_logs.bucket}/govuk_www/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      name = "ser_de_name"
      parameters {
        field.delim = "\t"
      }
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
    }

    // These columns corellate with the log format set up in Fastly which is:
    // %h\t%u\t%{%Y-%m-%d %H:%M:%S.}t%{msec_frac}t\t%{%z}t\t%m\t%{req.url}V\t%>s\tv$%{time.elapsed.sec}V.%{time.elapsed.msec_frac}V\t%{time.to_first_byte}V\t%B\t%{Content-Type}o\t%{User-Agent}i\t%{Fastly-Backend-Name}o\t%{server.datacenter}V\t%{if(resp.http.X-Cache ~"HIT", "HIT", "MISS")}V\t%{tls.client.protocol}V\t%{tls.client.cipher}V
    columns = [
      // %h
      {
        name    = "remote_host"
        type    = "string",
        comment = "Host that made this request, most likely an IP address"
      },
      // %u
      {
        name    = "remote_user"
        type    = "string",
        comment = "Basic auth user for this request"
      },
      // %{%Y-%m-%d %H:%M:%S.}t%{msec_frac}t
      {
        name    = "request_received",
        type    = "timestamp",
        comment = "Time we received the request"
      },
      // This field is separate from the timestamp above as the Presto version
      // on AWS Athena doesn't support timestamps - expectation is that this is
      // always +0000 though
      // %{%z}t
      {
        name    = "request_received_offset",
        type    = "string",
        comment = "Time offset of the request, expected to be +0000 always"
      },
      // %m
      {
        name    = "method",
        type    = "string"
        comment = "HTTP method for this request"
      },
      // %{req.url}V
      {
        name    = "url",
        type    = "string",
        comment = "URL requested with query string"
      },
      // %>s
      {
        name    = "status",
        type    = "int",
        comment = "HTTP status code returned"
      },
      // $%{time.elapsed.sec}V.%{time.elapsed.msec_frac}V
      {
        name    = "request_time",
        type    = "float",
        comment = "Time until user received full response in seconds"
      },
      // %{time.to_first_byte}V
      {
        name    = "time_to_generate_response",
        type    = "float",
        comment = "Time spent generating a response for varnish, in seconds"
      },
      // %B
      {
        name    = "bytes",
        type    = "bigint",
        comment = "Number of bytes returned"
      },
      // %{Content-Type}o
      {
        name    = "content_type",
        type    = "string",
        comment = "HTTP Content-Type header returned"
      },
      // %{User-Agent}i
      {
        name    = "user_agent",
        type    = "string",
        comment = "User agent that made the request"
      },
      // %{Fastly-Backend-Name}o
      {
        name    = "fastly_backend",
        type    = "string",
        comment = "Name of the backend that served this request"
      },
      // %{server.datacenter}V
      {
        name    = "fastly_data_centre",
        type    = "string",
        comment = "Name of the data centre that served this request"
      },
      // %{if(resp.http.X-Cache ~"HIT", "HIT", "MISS")}V
      {
        name    = "cache_hit",
        type    = "string",
        comment = "HIT or MISS as to whether this was served from Fastly cache"
      },
      // %{tls.client.protocol}V
      {
        name = "tls_client_protocol",
        type = "string"
      },
      // %{tls.client.cipher}V
      {
        name = "tls_client_cipher",
        type = "string"
      }
    ]
  }

  // these correspond to directory ordering of:
  // /year=YYYY/month=MM/date=DD/file.log.gz
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
    }
  ]

  parameters {
    classification  = "csv"
    compressionType = "gzip"
    delimiter       = "\t"
  }
}

# Outputs
# --------------------------------------------------------------

output "logs_writer_bucket_policy_arn" {
  value       = "${aws_iam_policy.logs_writer.arn}"
  description = "ARN of the logs writer bucket policy"
}
