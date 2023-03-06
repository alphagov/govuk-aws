/**
* ## Module: aws/alarms/autoscaling
*
* This module creates the following CloudWatch alarms in the
* AWS/Autoscaling namespace:
*
*   - GroupInServiceInstances less than threshold
*
* All metrics are measured during a period of 60 seconds and evaluated
* during 2 consecutive periods.
*
* AWS/Autoscaling metrics reference:
*
* http://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/as-metricscollected.html
*
*/
variable "name_prefix" {
  type        = "string"
  description = "The alarm name prefix."
}

variable "groupinserviceinstances_threshold" {
  type        = "string"
  description = "The value against which the Autoscaling GroupInServiceInstaces metric is compared."
  default     = "1"
}

variable "alarm_actions" {
  type        = "list"
  description = "The list of actions to execute when this alarm transitions into an ALARM state. Each action is specified as an Amazon Resource Number (ARN)."
}

variable "autoscaling_group_name" {
  type        = "string"
  description = "The name of the AutoScalingGroup that we want to monitor."
}

# Resources
#--------------------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "autoscaling_groupinserviceinstances" {
  alarm_name          = "${var.name_prefix}-autoscaling-groupinserviceinstances"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "GroupInServiceInstances"
  namespace           = "AWS/AutoScaling"
  period              = "60"
  statistic           = "Average"
  threshold           = "${var.groupinserviceinstances_threshold}"
  actions_enabled     = true
  alarm_actions       = var.alarm_actions
  alarm_description   = "This metric monitors instances in service in an AutoScalingGroup"

  dimensions = {
    AutoScalingGroupName = "${var.autoscaling_group_name}"
  }
}

# Outputs
#--------------------------------------------------------------

// The ID of the autoscaling GroupInServiceInstances health check.
output "alarm_autoscaling_groupinserviceinstances_id" {
  value       = "${aws_cloudwatch_metric_alarm.autoscaling_groupinserviceinstances.id}"
  description = "The ID of the autoscaling GroupInServiceInstances health check."
}
