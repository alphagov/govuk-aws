resource "aws_wafregional_web_acl" "default" {
  name        = "CachePublicWebACL"
  metric_name = "CachePublicWebACL"

  default_action {
    type = "ALLOW"
  }

  rule {
    action {
      type = "BLOCK"
    }

    priority = 2
    rule_id  = "${aws_wafregional_rule.x_always_block.id}"
  }

  rule {
    action {
      type = "ALLOW" # FIXME: Change this to BLOCK after 25th July 2019
    }

    priority = 3
    rule_id  = "${aws_wafregional_rule.sqli.id}"
  }

  rule {
    action {
      type = "ALLOW" # FIXME: Change this to BLOCK after 25th July 2019
    }

    priority = 4
    rule_id  = "${aws_wafregional_rule.xss.id}"
  }

  logging_configuration {
    log_destination = "${aws_kinesis_firehose_delivery_stream.splunk.arn}"

    redacted_fields {
      field_to_match {
        type = "URI"
      }

      field_to_match {
        data = "referer"
        type = "HEADER"
      }
    }
  }

  depends_on = [
    "aws_wafregional_rule.x_always_block",
    "aws_wafregional_rule.sqli",
    "aws_wafregional_rule.xss",
  ]
}

resource "aws_s3_bucket" "aws_waf_logs" {
  bucket = "aws-waf-logs-splunk"
  acl    = "private"
  bucket = "govuk-${var.aws_environment}-aws-waf-logs"
  region = "${var.aws_region}"

  lifecycle_rule {
    id      = "all"
    enabled = true

    expiration {
      days = 3
    }
  }
}

resource "aws_iam_role" "aws_waf_firehose" {
  name = "${var.aws_environment}-aws-waf-firehose"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "aws_waf_firehose" {
  name = "${var.aws_environment}-aws-waf-firehose"
  role = "${aws_iam_role.aws_waf_firehose.id}"

  policy = <<EOF
{
    "Statement": [
      {
          "Effect": "Allow",
          "Action": [
              "s3:AbortMultipartUpload",
              "s3:GetBucketLocation",
              "s3:GetObject",
              "s3:ListBucket",
              "s3:ListBucketMultipartUploads",
              "s3:PutObject",
              "lambda:InvokeFunction",
              "lambda:GetFunctionConfiguration"
          ],
          "Resource": [
              "arn:aws:s3:::${aws_s3_bucket.aws_waf_logs.bucket}",
              "arn:aws:s3:::${aws_s3_bucket.aws_waf_logs.bucket}/*",
              "${aws_lambda_function.aws_waf_log_trimmer.arn}",
              "${aws_lambda_function.aws_waf_log_trimmer.arn}:*"
          ]
      }
    ]
}
EOF
}

resource "aws_iam_role" "aws_waf_log_trimmer" {
  name = "${var.aws_environment}-aws-waf-log-trimmer"

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

data "archive_file" "aws_waf_log_trimmer" {
  type        = "zip"
  source_file = "${path.module}/../../lambda/WAFLogTrimmer/lambda.js"
  output_path = "${path.module}/../../lambda/WAFLogTrimmer/lambda.zip"
}

resource "aws_lambda_function" "aws_waf_log_trimmer" {
  filename         = "${data.archive_file.aws_waf_log_trimmer.output_path}"
  function_name    = "${var.aws_environment}-waf-log-trimmer"
  source_code_hash = "${data.archive_file.aws_waf_log_trimmer.output_base64sha256}"
  role             = "${aws_iam_role.aws_waf_log_trimmer.arn}"
  handler          = "lambda.handler"
  runtime          = "nodejs8.10"
  timeout          = 190
}

resource "aws_kinesis_firehose_delivery_stream" "splunk" {
  # NOTE: The Kinesis Firehose Delivery Stream name must begin with
  # aws-waf-logs-. See the AWS WAF Developer Guide for more information
  # about enabling WAF logging.
  name = "aws-waf-logs-${var.aws_environment}"

  destination = "splunk"

  s3_configuration {
    role_arn           = "${aws_iam_role.aws_waf_firehose.arn}"
    bucket_arn         = "${aws_s3_bucket.aws_waf_logs.arn}"
    buffer_size        = 10
    buffer_interval    = 400
    compression_format = "GZIP"
  }

  splunk_configuration {
    hec_endpoint               = "${var.waf_logs_hec_endpoint}"
    hec_token                  = "${var.waf_logs_hec_token}"
    hec_acknowledgment_timeout = 180
    hec_endpoint_type          = "Raw"
    s3_backup_mode             = "AllEvents"

    processing_configuration {
      enabled = "true"

      processors {
        type = "Lambda"

        parameters {
          parameter_name  = "LambdaArn"
          parameter_value = "${aws_lambda_function.aws_waf_log_trimmer.arn}:$LATEST"
        }

        parameters {
          parameter_name  = "RoleArn"
          parameter_value = "${aws_iam_role.aws_waf_firehose.arn}"
        }

        parameters {
          parameter_name  = "BufferIntervalInSeconds"
          parameter_value = "180"
        }
      }
    }
  }
}
