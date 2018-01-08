/**
* ## Module: aws/alarms/cloudtrail
*
* This module creates CloudWatch alarms in a CloudTrailMetrics
* namespace by filtering patterns in the log group configured
* for CloudTrail.
*/
variable "cloudtrail_log_group_name" {
  type        = "string"
  description = "The name of the log group to associate the metric filter with."
}

variable "metric_filter_pattern" {
  type        = "string"
  description = "A valid CloudWatch Logs filter pattern for extracting metric data out of ingested log events."
}

variable "metric_name" {
  type        = "string"
  description = "The name of the CloudWatch metric to which the monitored log information should be published."
}

variable "alarm_name" {
  type        = "string"
  description = "The descriptive name for the alarm. This name must be unique within the user's AWS account."
}

variable "alarm_description" {
  type        = "string"
  description = "The description for the alarm."
  default     = ""
}

variable "alarm_actions" {
  type        = "list"
  description = "The list of actions to execute when this alarm transitions into an ALARM state. Each action is specified as an Amazon Resource Number (ARN)."
}

# Resources
#--------------------------------------------------------------

resource "aws_cloudwatch_log_metric_filter" "filter" {
  name           = "${var.metric_name}"
  pattern        = "${var.metric_filter_pattern}"
  log_group_name = "${var.cloudtrail_log_group_name}"

  metric_transformation {
    name      = "${var.metric_name}"
    namespace = "CloudTrailMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "cloudtrail" {
  alarm_name                = "${var.alarm_name}"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "${var.metric_name}"
  namespace                 = "CloudTrailMetrics"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "${var.alarm_description}"
  insufficient_data_actions = []
  alarm_actions             = ["${var.alarm_actions}"]
}
