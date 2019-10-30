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
  required_version = "= 0.11.14"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "2.33.0"
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

  lifecycle_rule {
    enabled = true

    expiration {
      days = 30
    }
  }
}

resource "aws_s3_bucket" "transition_fastly_logs" {
  bucket = "govuk-${var.aws_environment}-transition-fastly-logs"

  tags {
    Name            = "govuk-${var.aws_environment}-transition-fastly-logs"
    aws_environment = "${var.aws_environment}"
  }

  logging {
    target_bucket = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    target_prefix = "s3/govuk-${var.aws_environment}-transition-fastly-logs/"
  }

  lifecycle_rule {
    enabled = true

    expiration {
      days = 30
    }
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

# We require a user for transition to read from S3 buckets
resource "aws_iam_user" "transition_downloader" {
  name = "govuk-${var.aws_environment}-transition-downloader"
}

resource "aws_iam_policy" "transition_downloader" {
  name   = "fastly-logs-${var.aws_environment}-transition-downloader-policy"
  policy = "${data.template_file.transition_downloader_policy_template.rendered}"
}

resource "aws_iam_policy_attachment" "transition_downloader" {
  name       = "transition-downloader-policy-attachment"
  users      = ["${aws_iam_user.transition_downloader.name}"]
  policy_arn = "${aws_iam_policy.transition_downloader.arn}"
}

data "template_file" "transition_downloader_policy_template" {
  template = "${file("${path.module}/../../policies/transition_downloader_policy.tpl")}"

  vars {
    bucket_arn = "${aws_s3_bucket.transition_fastly_logs.arn}"
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
  name = "AWSGlueServiceRole-fastly-logs"

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
        paths                 = "client_ip,request_received,request_received_offset,method,url,status,request_time,time_to_generate_response,bytes,content_type,user_agent,fastly_backend,data_centre,cache_hit,tls_client_protocol,tls_client_cipher"
        ignore.malformed.json = "true"
      }

      serialization_library = "org.openx.data.jsonserde.JsonSerDe"
    }

    // These columns correlate with the log format set up in Fastly as below
    //
    // {
    // "client_ip":"%{json.escape(client.ip)}V",
    // "request_received":"%{begin:%Y-%m-%d %H:%M:%S.}t%{time.start.msec_frac}V",
    // "request_received_offset":"%{begin:%z}t",
    // "method":"%{json.escape(req.method)}V",
    // "url":"%{json.escape(req.url)}V",
    // "status":%>s,
    // "request_time":%{time.elapsed.sec}V.%{time.elapsed.msec_frac}V,
    // "time_to_generate_response":%{time.to_first_byte}V,
    // "bytes":%B,
    // "content_type":"%{json.escape(resp.http.Content-Type)}V",
    // "user_agent":"%{json.escape(req.http.User-Agent)}V",
    // "fastly_backend":"%{json.escape(resp.http.Fastly-Backend-Name)}V",
    // "data_centre":"%{json.escape(server.datacenter)}V",
    // "cache_hit":%{if(fastly_info.state ~"^(HIT|MISS)(?:-|$)", "true", "false")}V,
    // "tls_client_protocol":"%{json.escape(tls.client.protocol)}V",
    // "tls_client_cipher":"%{json.escape(tls.client.cipher)}V"
    // }
    columns = [
      {
        name    = "client_ip"
        type    = "string"
        comment = "IP address of the client that made the request"
      },
      {
        name    = "request_received"
        type    = "timestamp"
        comment = "Time we received the request"
      },
      {
        // This field is separate from the timestamp above as the Presto version
        // on AWS Athena doesn't support timestamps - expectation is that this is
        // always +0000 though
        name = "request_received_offset"

        type    = "string"
        comment = "Time offset of the request, expected to be +0000 always"
      },
      {
        name    = "method"
        type    = "string"
        comment = "HTTP method for this request"
      },
      {
        name    = "url"
        type    = "string"
        comment = "URL requested with query string"
      },
      {
        name    = "status"
        type    = "int"
        comment = "HTTP status code returned"
      },
      {
        name    = "request_time"
        type    = "double"
        comment = "Time until user received full response in seconds"
      },
      {
        name    = "time_to_generate_response"
        type    = "double"
        comment = "Time spent generating a response for varnish, in seconds"
      },
      {
        name    = "bytes"
        type    = "bigint"
        comment = "Number of bytes returned"
      },
      {
        name    = "content_type"
        type    = "string"
        comment = "HTTP Content-Type header returned"
      },
      {
        name    = "user_agent"
        type    = "string"
        comment = "User agent that made the request"
      },
      {
        name    = "fastly_backend"
        type    = "string"
        comment = "Name of the backend that served this request"
      },
      {
        name    = "data_centre"
        type    = "string"
        comment = "Name of the data centre that served this request"
      },
      {
        name    = "cache_hit"
        type    = "boolean"
        comment = "Whether this was served from cache or not"
      },
      {
        name = "tls_client_protocol"
        type = "string"
      },
      {
        name = "tls_client_cipher"
        type = "string"
      },
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
    },
  ]

  parameters {
    classification  = "json"
    compressionType = "gzip"
    typeOfDate      = "file"
  }
}

resource "aws_glue_crawler" "govuk_assets" {
  name          = "Assets fastly logs"
  description   = "Crawls the assets logs from fastly for allowing Athena querying"
  database_name = "${aws_glue_catalog_database.fastly_logs.name}"
  role          = "${aws_iam_role.glue.name}"
  schedule      = "cron(30 */4 * * ? *)"

  s3_target {
    path = "s3://${aws_s3_bucket.fastly_logs.bucket}/govuk_assets"
  }

  schema_change_policy {
    delete_behavior = "DELETE_FROM_DATABASE"
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

resource "aws_glue_catalog_table" "govuk_assets" {
  name          = "govuk_assets"
  description   = "Maps the tab-seperated value log file to columns"
  database_name = "${aws_glue_catalog_database.fastly_logs.name}"
  table_type    = "EXTERNAL_TABLE"

  storage_descriptor {
    compressed    = true
    location      = "s3://${aws_s3_bucket.fastly_logs.bucket}/govuk_assets/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      name = "ser_de_name"

      parameters {
        paths                 = "client_ip,request_received,request_received_offset,method,url,status,request_time,time_to_generate_response,bytes,content_type,user_agent,fastly_backend,data_centre,cache_hit,tls_client_protocol,tls_client_cipher"
        ignore.malformed.json = "true"
      }

      serialization_library = "org.openx.data.jsonserde.JsonSerDe"
    }

    // These columns correlate with the log format set up in Fastly as below
    //
    // {
    // "client_ip":"%{json.escape(client.ip)}V",
    // "request_received":"%{begin:%Y-%m-%d %H:%M:%S.}t%{time.start.msec_frac}V",
    // "request_received_offset":"%{begin:%z}t",
    // "method":"%{json.escape(req.method)}V",
    // "url":"%{json.escape(req.url)}V",
    // "status":%>s,
    // "request_time":%{time.elapsed.sec}V.%{time.elapsed.msec_frac}V,
    // "time_to_generate_response":%{time.to_first_byte}V,
    // "bytes":%B,
    // "content_type":"%{json.escape(resp.http.Content-Type)}V",
    // "user_agent":"%{json.escape(req.http.User-Agent)}V",
    // "fastly_backend":"%{json.escape(resp.http.Fastly-Backend-Name)}V",
    // "data_centre":"%{json.escape(server.datacenter)}V",
    // "cache_hit":%{if(fastly_info.state ~"^(HIT|MISS)(?:-|$)", "true", "false")}V,
    // "tls_client_protocol":"%{json.escape(tls.client.protocol)}V",
    // "tls_client_cipher":"%{json.escape(tls.client.cipher)}V"
    // }
    columns = [
      {
        name    = "client_ip"
        type    = "string"
        comment = "IP address of the client that made the request"
      },
      {
        name    = "request_received"
        type    = "timestamp"
        comment = "Time we received the request"
      },
      {
        // This field is separate from the timestamp above as the Presto version
        // on AWS Athena doesn't support timestamps - expectation is that this is
        // always +0000 though
        name = "request_received_offset"

        type    = "string"
        comment = "Time offset of the request, expected to be +0000 always"
      },
      {
        name    = "method"
        type    = "string"
        comment = "HTTP method for this request"
      },
      {
        name    = "url"
        type    = "string"
        comment = "URL requested with query string"
      },
      {
        name    = "status"
        type    = "int"
        comment = "HTTP status code returned"
      },
      {
        name    = "request_time"
        type    = "double"
        comment = "Time until user received full response in seconds"
      },
      {
        name    = "time_to_generate_response"
        type    = "double"
        comment = "Time spent generating a response for varnish, in seconds"
      },
      {
        name    = "bytes"
        type    = "bigint"
        comment = "Number of bytes returned"
      },
      {
        name    = "content_type"
        type    = "string"
        comment = "HTTP Content-Type header returned"
      },
      {
        name    = "user_agent"
        type    = "string"
        comment = "User agent that made the request"
      },
      {
        name    = "fastly_backend"
        type    = "string"
        comment = "Name of the backend that served this request"
      },
      {
        name    = "data_centre"
        type    = "string"
        comment = "Name of the data centre that served this request"
      },
      {
        name    = "cache_hit"
        type    = "boolean"
        comment = "Whether this was served from cache or not"
      },
      {
        name = "tls_client_protocol"
        type = "string"
      },
      {
        name = "tls_client_cipher"
        type = "string"
      },
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
    },
  ]

  parameters {
    classification  = "json"
    compressionType = "gzip"
    typeOfDate      = "file"
  }
}

resource "aws_glue_crawler" "bouncer" {
  name          = "Bouncer fastly logs"
  description   = "Crawls the bouncer logs from fastly for allowing Athena querying"
  database_name = "${aws_glue_catalog_database.fastly_logs.name}"
  role          = "${aws_iam_role.glue.name}"
  schedule      = "cron(30 */4 * * ? *)"

  s3_target {
    path = "s3://${aws_s3_bucket.fastly_logs.bucket}/bouncer"
  }

  schema_change_policy {
    delete_behavior = "DELETE_FROM_DATABASE"
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

resource "aws_glue_catalog_table" "bouncer" {
  name          = "bouncer"
  description   = "Maps the tab-seperated value log file to columns"
  database_name = "${aws_glue_catalog_database.fastly_logs.name}"
  table_type    = "EXTERNAL_TABLE"

  storage_descriptor {
    compressed    = true
    location      = "s3://${aws_s3_bucket.fastly_logs.bucket}/bouncer/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      name = "ser_de_name"

      parameters {
        paths                 = "client_ip,request_received,request_received_offset,method,url,status,request_time,time_to_generate_response,content_type,user_agent,data_centre,cache_hit"
        ignore.malformed.json = "true"
      }

      serialization_library = "org.openx.data.jsonserde.JsonSerDe"
    }

    // These columns correlate with the log format set up in Fastly as below
    //
    // {
    // "client_ip":"%{json.escape(client.ip)}V",
    // "request_received":"%{begin:%Y-%m-%d %H:%M:%S.}t%{time.start.msec_frac}V",
    // "request_received_offset":"%{begin:%z}t",
    // "method":"%{json.escape(req.method)}V",
    // "host":"%{json.escape(req.http.host)}V",
    // "url":"%{json.escape(req.url)}V",
    // "status":%>s,
    // "request_time":%{time.elapsed.sec}V.%{time.elapsed.msec_frac}V,
    // "time_to_generate_response":%{time.to_first_byte}V,
    // "location":"%{json.escape(resp.http.Location)}V",
    // "user_agent":"%{json.escape(req.http.User-Agent)}V",
    // "data_centre":"%{json.escape(server.datacenter)}V",
    // "cache_hit":%{if(fastly_info.state ~"^(HIT|MISS)(?:-|$)", "true", "false")}V
    // }
    columns = [
      {
        name    = "client_ip"
        type    = "string"
        comment = "IP address of the client that made the request"
      },
      {
        name    = "request_received"
        type    = "timestamp"
        comment = "Time we received the request"
      },
      {
        // This field is separate from the timestamp above as the Presto version
        // on AWS Athena doesn't support timestamps - expectation is that this is
        // always +0000 though
        name = "request_received_offset"

        type    = "string"
        comment = "Time offset of the request, expected to be +0000 always"
      },
      {
        name    = "method"
        type    = "string"
        comment = "HTTP method for this request"
      },
      {
        name    = "host"
        type    = "string"
        comment = "Host that was requested"
      },
      {
        name    = "url"
        type    = "string"
        comment = "URL requested with query string"
      },
      {
        name    = "status"
        type    = "int"
        comment = "HTTP status code returned"
      },
      {
        name    = "request_time"
        type    = "double"
        comment = "Time until user received full response in seconds"
      },
      {
        name    = "time_to_generate_response"
        type    = "double"
        comment = "Time spent generating a response for varnish, in seconds"
      },
      {
        name    = "location"
        type    = "string"
        comment = "HTTP Location header returned"
      },
      {
        name    = "user_agent"
        type    = "string"
        comment = "User agent that made the request"
      },
      {
        name    = "data_centre"
        type    = "string"
        comment = "Name of the data centre that served this request"
      },
      {
        name    = "cache_hit"
        type    = "boolean"
        comment = "Whether this was served from cache or not"
      },
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
    },
  ]

  parameters {
    classification  = "json"
    compressionType = "gzip"
    typeOfDate      = "file"
  }
}

resource "aws_athena_named_query" "transition_logs" {
  name     = "transition-logs-query"
  database = "${aws_glue_catalog_database.fastly_logs.name}"
  query    = "${file("${path.module}/../../queries/transition_logs_query.sql")}"
}

resource "aws_lambda_function" "transition_executor" {
  filename      = "../../lambda/TransitionLogs/TransitionLogs.zip"
  function_name = "govuk-${var.aws_environment}-transition"
  role          = "${aws_iam_role.transition_executor.arn}"
  handler       = "main.lambda_handler"
  runtime       = "python3.6"

  environment {
    variables = {
      NAMED_QUERY_ID = "${aws_athena_named_query.transition_logs.id}"
      DATABASE_NAME  = "${aws_athena_named_query.transition_logs.database}"
      BUCKET_NAME    = "${aws_s3_bucket.transition_fastly_logs.bucket}"
    }
  }
}

resource "aws_iam_role" "transition_executor" {
  name = "AWSLambdaRole-transition-executor"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "transition_executor" {
  name   = "fastly-logs-${var.aws_environment}-transition-executor-policy"
  policy = "${data.template_file.transition_executor_policy_template.rendered}"
}

resource "aws_iam_role_policy_attachment" "transition_executor" {
  role       = "${aws_iam_role.transition_executor.name}"
  policy_arn = "${aws_iam_policy.transition_executor.arn}"
}

data "template_file" "transition_executor_policy_template" {
  template = "${file("${path.module}/../../policies/transition_executor_policy.tpl")}"

  vars {
    out_bucket_arn = "${aws_s3_bucket.transition_fastly_logs.arn}"
    in_bucket_arn  = "${aws_s3_bucket.fastly_logs.arn}"
  }
}

resource "aws_cloudwatch_event_rule" "transition_executor_daily" {
  name                = "transition_executor_daily"
  schedule_expression = "cron(30 0 * * ? *)"
}

resource "aws_cloudwatch_event_target" "transition_executor_daily" {
  rule = "${aws_cloudwatch_event_rule.transition_executor_daily.name}"
  arn  = "${aws_lambda_function.transition_executor.arn}"
}

resource "aws_lambda_permission" "cloudwatch_transition_executor_daily_permission" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.transition_executor.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.transition_executor_daily.arn}"
}

# Outputs
# --------------------------------------------------------------

output "logs_writer_bucket_policy_arn" {
  value       = "${aws_iam_policy.logs_writer.arn}"
  description = "ARN of the logs writer bucket policy"
}
