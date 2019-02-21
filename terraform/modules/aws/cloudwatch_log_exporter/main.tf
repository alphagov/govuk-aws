/**
* ## Module: aws/cloudwatch_log_exporter
*
* This module exports a CloudWatch log group to S3 via Lambda
* function and Kinesis Firehose.
*
* The lambda function filename needs to be provided and the
* module will create a permission to listen to Log events and
* a subscription to the specified log group. This function
* should:
*   - decompress the Cloudwatch log
*   - format the data, if needed, so the log entry can later be
* parsed by a Logstash filter
*   - send the log event to a Kinesis Firehose stream, that will
* be configured to store the events in a S3 bucket
*/
variable "log_group_name" {
  type        = "string"
  description = "The name of the Cloudwatch log group to process"
}

variable "firehose_role_arn" {
  type        = "string"
  description = "The ARN of the Kinesis Firehose stream AWS credentials"
}

variable "firehose_bucket_arn" {
  type        = "string"
  description = "The ARN of the Kinesis Firehose stream S3 bucket"
}

variable "firehose_bucket_prefix" {
  type        = "string"
  description = "The extra prefix to be added in front of the default time format prefix to the Kinesis Firehose stream S3 bucket"
}

variable "lambda_filename" {
  type        = "string"
  description = "The path to the Lambda function's deployment package within the local filesystem"
}

variable "lambda_role_arn" {
  type        = "string"
  description = "The ARN of the IAM role attached to the Lambda Function"
}

variable "lambda_log_retention_in_days" {
  type        = "string"
  description = "Specifies the number of days you want to retain log events in the Lambda function log group"
  default     = "1"
}

# Resources
#--------------------------------------------------------------

data "aws_region" "current" {
  current = true
}

data "aws_caller_identity" "current" {}

resource "aws_kinesis_firehose_delivery_stream" "logs_s3" {
  name        = "${var.log_group_name}"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = "${var.firehose_role_arn}"
    bucket_arn = "${var.firehose_bucket_arn}"
    prefix     = "${var.firehose_bucket_prefix}/"

    processing_configuration = [
      {
        enabled = "false"
      },
    ]
  }
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id   = "${format("AllowExecutionFromCloudWatchLog-%s", replace(var.log_group_name, "/", "-"))}"
  action         = "lambda:InvokeFunction"
  function_name  = "${aws_lambda_function.lambda_logs_to_firehose.arn}"
  principal      = "logs.${data.aws_region.current.name}.amazonaws.com"
  source_account = "${data.aws_caller_identity.current.account_id}"
  source_arn     = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${var.log_group_name}:*"
}

resource "aws_cloudwatch_log_group" "lambda_logs_to_firehose_log_group" {
  name              = "/aws/lambda/CloudWatchLogsToFirehose-${var.log_group_name}"
  retention_in_days = "${var.lambda_log_retention_in_days}"
}

resource "aws_lambda_function" "lambda_logs_to_firehose" {
  filename      = "${var.lambda_filename}"
  function_name = "CloudWatchLogsToFirehose-${var.log_group_name}"
  role          = "${var.lambda_role_arn}"
  handler       = "main.lambda_handler"
  runtime       = "python2.7"

  environment {
    variables = {
      DELIVERY_STREAM_NAME = "${aws_kinesis_firehose_delivery_stream.logs_s3.name}"
    }
  }
}

resource "aws_cloudwatch_log_subscription_filter" "log" {
  depends_on      = ["aws_lambda_permission.allow_cloudwatch"]
  name            = "${var.log_group_name}-exporter"
  log_group_name  = "${var.log_group_name}"
  filter_pattern  = "[]"
  destination_arn = "${aws_lambda_function.lambda_logs_to_firehose.arn}"
}
