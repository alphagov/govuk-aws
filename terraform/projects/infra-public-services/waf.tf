resource "aws_wafv2_web_acl" "wafv2" {
  name  = "CachePublicWebACLv2"
  scope = "REGIONAL"

  default_action {
    type = "ALLOW"
    allow {}
  }

  rule {
    name     = "XAlwaysBlock"
    priority = 1
    action {
      type = "BLOCK"
      block {}
    }
    statement {
      byte_match_statement {
        field_to_match {
          single_single_header {
            name = "x-always-block"
          }
        }

        positional_constraint = "EXACTLY"
        search_string         = "true"

        text_transformation {
          priority = 2
          type     = "NONE"
        }
      }
    }

    visibility_config {
      cloudwatchcloudwatch_metrics_enabled = true
      metric_name                          = "cache-waf-x-always-block"
      sampled_requests_enabled             = true
    }
  }
}

rule {
  name     = "RateLimit"
  priority = 2

  action {
    count {}
  }

  statement {
    rate_based_statement {
      limit              = 2000 # requests per IP in 5 minute window
      aggregate_key_type = "FORWARDED_IP"

      forwarded_ip_config {
        fallback_behavior = "MATCH"
        header_name       = "True-Client-IP" # Set in Fastly VCL
      }
    }
  }
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "cache-waf-rate-limit"
    sampled_requests_enabled   = true
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "cache-waf"
    sampled_requests_enabled   = true
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
  role = aws_iam_role.aws_waf_firehose.id

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
  filename         = data.archive_file.aws_waf_log_trimmer.output_path
  function_name    = "${var.aws_environment}-waf-log-trimmer"
  source_code_hash = data.archive_file.aws_waf_log_trimmer.output_base64sha256
  role             = aws_iam_role.aws_waf_log_trimmer.arn
  handler          = "lambda.handler"
  runtime          = "nodejs10.x"
  timeout          = 190
}

resource "aws_s3_bucket" "aws_waf_logs" {

  acl    = "private"
  bucket = "govuk-${var.aws_environment}-aws-waf-logs"
  region = var.aws_region

  lifecycle_rule {
    id      = "all"
    enabled = true

    expiration {
      days = 3
    }
  }
}

resource "aws_kinesis_firehose_delivery_stream" "splunk" {
  # NOTE: The Kinesis Firehose Delivery Stream name must begin with
  # aws-waf-logs-. See the AWS WAF Developer Guide for more information
  # about enabling WAF logging.
  name = "aws-waf-logs-${var.aws_environment}"

  destination = "splunk"

  s3_configuration {
    role_arn           = aws_iam_role.aws_waf_firehose.arn
    bucket_arn         = aws_s3_bucket.aws_waf_logs.arn
    buffer_size        = 10
    buffer_interval    = 400
    compression_format = "GZIP"
  }

  splunk_configuration {
    hec_endpoint               = var.waf_logs_hec_endpoint
    hec_token                  = var.waf_logs_hec_token
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
          parameter_value = aws_iam_role.aws_waf_firehose.arn
        }

        parameters {
          parameter_name  = "BufferIntervalInSeconds"
          parameter_value = "180"
        }
      }
    }
  }
}

output "default_waf_acl" {
  value       = aws_wafregional_web_acl.default.id
  description = "GOV.UK default regional WAF ACL"
}
