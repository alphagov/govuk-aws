/**
* ## Module: aws/alarms/ec2
*
* This module creates the following CloudWatch alarms in the
* AWS/EC2 namespace:
*
*   - CPUUtilization greater than or equal to threshold threshold
*   - StatusCheckFailed_Instance greater than or equal to 1 (instance status
*     check failed)
*
* Alarms are created for all the instances that belong to a given
* autoscaling group name. All metrics are measured during a period of 60 seconds
* and evaluated during 2 consecutive periods.
*
* AWS/EC2 metrics reference:
*
* http://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ec2-metricscollected.html
*/
variable "name_prefix" {
  type        = string
  description = "The alarm name prefix."
}

variable "cpuutilization_threshold" {
  type        = string
  description = "The value against which the CPUUtilization metric is compared, in percent."
  default     = "80"
}

variable "alarm_actions" {
  type        = list(string)
  description = "The list of actions to execute when this alarm transitions into an ALARM state. Each action is specified as an Amazon Resource Number (ARN)."
}

variable "autoscaling_group_name" {
  type        = string
  description = "The name of the AutoScalingGroup that we want to monitor."
}

# Resources
#--------------------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "ec2_cpuutilization" {
  alarm_name          = "${var.name_prefix}-ec2-cpuutilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = var.cpuutilization_threshold
  actions_enabled     = true
  alarm_actions       = var.alarm_actions
  alarm_description   = "This metric monitors CPU utilization in an instance"

  dimensions = {
    AutoScalingGroupName = "${var.autoscaling_group_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "ec2_statuscheckfailed_instance" {
  alarm_name          = "${var.name_prefix}-ec2-statuscheckfailed_instance"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "StatusCheckFailed_Instance"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "1"
  actions_enabled     = true
  alarm_actions       = var.alarm_actions
  alarm_description   = "This metric monitors the status of the instance status check"

  dimensions = {
    AutoScalingGroupName = "${var.autoscaling_group_name}"
  }
}

# Outputs
#--------------------------------------------------------------

// The ID of the instance CPUUtilization health check.
output "alarm_ec2_cpuutilization_id" {
  value       = aws_cloudwatch_metric_alarm.ec2_cpuutilization.id
  description = "The ID of the instance CPUUtilization health check."
}

// The ID of the instance StatusCheckFailed_Instance health check.
output "alarm_ec2_statuscheckfailed_instance_id" {
  value       = aws_cloudwatch_metric_alarm.ec2_statuscheckfailed_instance.id
  description = "The ID of the instance StatusCheckFailed_Instance health check."
}
