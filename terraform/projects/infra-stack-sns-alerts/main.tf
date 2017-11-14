/** 
* ## Module: projects/infra-stack-sns-alerts
*
* This module creates a SNS topic for alert notifications. It creates
* and subscribes a SQS queue for further integration.
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

# Resources
# --------------------------------------------------------------

terraform {
  backend          "s3"             {}
  required_version = "= 0.10.8"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "1.0.0"
}

resource "aws_sns_topic" "alerts" {
  name = "${var.stackname}-alerts"
}

resource "aws_sqs_queue" "alerts_queue" {
  name = "${var.stackname}-alerts"
}

resource "aws_sns_topic_subscription" "alerts_sqs_target" {
  topic_arn = "${aws_sns_topic.alerts.arn}"
  protocol  = "sqs"
  endpoint  = "${aws_sqs_queue.alerts_queue.arn}"
}

# Outputs
# --------------------------------------------------------------

output "sns_topic_alerts_arn" {
  value       = "${aws_sns_topic.alerts.arn}"
  description = "The ARN of the SNS topic"
}
