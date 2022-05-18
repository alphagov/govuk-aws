/**
* ## Module: aws::alarms::elasticache
*
* This module creates the following CloudWatch alarms in the
* AWS/ElastiCache namespace:
*
*   - CPUUtilization greater than or equal to threshold
*   - FreeableMemory less than threshold
*
* All metrics are measured during a period of 60 seconds and evaluated
* during 2 consecutive periods.
*
* AWS/ElastiCache metrics reference:
* http://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/elasticache-metricscollected.html
*
*/
variable "name_prefix" {
  type        = string
  description = "The alarm name prefix."
}

variable "alarm_actions" {
  type        = list(any)
  description = "The list of actions to execute when this alarm transitions into an ALARM state. Each action is specified as an Amazon Resource Number (ARN)."
}

variable "cache_cluster_id" {
  type        = string
  description = "The ID of the cache cluster that we want to monitor."
}

variable "cpuutilization_threshold" {
  type        = string
  description = "The value against which the CPUUtilization metric is compared, in percent."
  default     = "80"
}

variable "freeablememory_threshold" {
  type        = string
  description = "The value against which the FreeableMemory metric is compared, in Bytes."
  default     = "2147483648"
}

# Resources
#--------------------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "elasticache_cpuutilization" {
  alarm_name          = "${var.name_prefix}-elasticache-cpuutilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = "60"
  statistic           = "Average"
  threshold           = var.cpuutilization_threshold
  actions_enabled     = true
  alarm_actions       = var.alarm_actions
  alarm_description   = "This metric monitors the percentage of CPU utilization."

  dimensions = {
    CacheClusterId = var.cache_cluster_id
  }
}

resource "aws_cloudwatch_metric_alarm" "elasticache_freeablememory" {
  alarm_name          = "${var.name_prefix}-elasticache-freeablememory"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/ElastiCache"
  period              = "60"
  statistic           = "Average"
  threshold           = var.freeablememory_threshold
  actions_enabled     = true
  alarm_actions       = var.alarm_actions
  alarm_description   = "This metric monitors the amount of free memory available on the host."

  dimensions = {
    CacheClusterId = "${var.cache_cluster_id}"
  }
}

# Outputs
#--------------------------------------------------------------

// The ID of the ElastiCache CPUUtilization health check.
output "alarm_elasticache_cpuutilization_id" {
  value       = aws_cloudwatch_metric_alarm.elasticache_cpuutilization.id
  description = "The ID of the ElastiCache CPUUtilization health check."
}

// The ID of the ElastiCache FreeableMemory health check.
output "alarm_elasticache_freeablememory_id" {
  value       = aws_cloudwatch_metric_alarm.elasticache_freeablememory.id
  description = "The ID of the ElastiCache FreeableMemory health check."
}
