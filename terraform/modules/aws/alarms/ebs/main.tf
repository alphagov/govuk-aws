/**
* ## Module: aws::alarms::ebs
*
* This module creates the following CloudWatch alarms in the
* AWS/EBS namespace:
*
*   - VolumeQueueLength greater than or equal to threshold, where
*     `volumequeuelength_threshold` is a given parameter
*
* AWS/EBS metrics reference:
* http://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ebs-metricscollected.html
*/
variable "name_prefix" {
  type        = "string"
  description = "The alarm name prefix."
}

variable "volumequeuelength_threshold" {
  type        = "string"
  description = "The value against which the EBS VolumeQueueLength metric is compared. Defaults to 10."
  default     = "10"
}

variable "alarm_actions" {
  type        = "list"
  description = "The list of actions to execute when this alarm transitions into an ALARM state from any other state. Each action is specified as an Amazon Resource Number (ARN)."
}

variable "volume_id" {
  type        = "string"
  description = "The ID of the EBS volume that we want to monitor."
}

# Resources
#--------------------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "ebs_volumequeuelength" {
  alarm_name          = "${var.name_prefix}-ebs-volumequeuelength"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "VolumeQueueLength"
  namespace           = "AWS/EBS"
  period              = "120"
  statistic           = "Average"
  threshold           = "${var.volumequeuelength_threshold}"
  actions_enabled     = true
  alarm_actions       = ["${var.alarm_actions}"]
  alarm_description   = "This metric monitors the number of read and write operation requests waiting to be completed in an EBS volume"

  dimensions {
    VolumeId = "${var.volume_id}"
  }
}

# Outputs
#--------------------------------------------------------------
output "alarm_ebs_volumequeuelength_id" {
  value       = "${aws_cloudwatch_metric_alarm.ebs_volumequeuelength.id}"
  description = "The ID of the EBS VolumeQueueLength health check."
}
