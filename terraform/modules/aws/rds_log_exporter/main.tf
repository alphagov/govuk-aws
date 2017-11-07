/**
* ## Module: aws/rds_log_exporter
*
* This module exports a RDS instance logs to S3 via Lambda function
* and scheduled event.
*
* The Lambda function filename needs to be provided. The module creates
* a scheduled Cloudwatch event to trigger the Lambda function.
*/
variable "rds_instance_id" {
  type        = "string"
  description = "The RDS instance ID"
}

variable "s3_logging_bucket_name" {
  type        = "string"
  description = "The name of the S3 bucket where we store the logs"
}

variable "s3_logging_bucket_prefix" {
  type        = "string"
  description = "The extra prefix to be added in front of the instance name in the S3 logging bucket. RDS logs will be store in s3_bucket/prefix/instance_name/log_name"
  default     = "rds"
}

variable "rds_log_name_prefix" {
  type        = "string"
  description = "Download RDS logs that match this prefix"
  default     = "error/"
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

variable "lambda_event_schedule_expression" {
  type        = "string"
  description = "Cloudwatch event schedule expression that triggers the Lambda function"
  default     = "rate(5 minutes)"
}

# Resources
#--------------------------------------------------------------

resource "aws_cloudwatch_log_group" "lambda_rds_logs_to_s3_log_group" {
  name              = "/aws/lambda/RDSLogsToS3-${var.rds_instance_id}"
  retention_in_days = "${var.lambda_log_retention_in_days}"
}

resource "aws_lambda_function" "lambda_rds_logs_to_s3" {
  filename      = "${var.lambda_filename}"
  function_name = "RDSLogsToS3-${var.rds_instance_id}"
  role          = "${var.lambda_role_arn}"
  handler       = "main.lambda_handler"
  runtime       = "python2.7"
  timeout       = "60"

  environment {
    variables = {
      RDS_INSTANCE_NAME  = "${var.rds_instance_id}"
      S3_BUCKET_NAME     = "${var.s3_logging_bucket_name}"
      S3_BUCKET_PREFIX   = "${var.s3_logging_bucket_prefix}/${var.rds_instance_id}/"
      LAST_RECEIVED_FILE = "last_received.log"
      LOG_NAME_PREFIX    = "${var.rds_log_name_prefix}"
    }
  }
}

resource "aws_cloudwatch_event_target" "rds_log_scheduled" {
  target_id = "${var.rds_instance_id}-lambda-log-exporter"
  rule      = "${aws_cloudwatch_event_rule.rds_log_scheduled.name}"
  arn       = "${aws_lambda_function.lambda_rds_logs_to_s3.arn}"
}

resource "aws_cloudwatch_event_rule" "rds_log_scheduled" {
  name                = "${var.rds_instance_id}-lambda-log-exporter"
  description         = "Scheduled event to export RDS logs to S3"
  schedule_expression = "${var.lambda_event_schedule_expression}"
}

resource "aws_lambda_permission" "allow_cloudwatch_event" {
  statement_id  = "AllowExecutionFromCloudWatchEvent-${var.rds_instance_id}"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda_rds_logs_to_s3.arn}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.rds_log_scheduled.arn}"
}
