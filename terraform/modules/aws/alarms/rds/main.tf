/**
* ## Modules: aws/alarms/rds
*
* This module creates the following CloudWatch alarms in the
* AWS/RDS namespace:
*
*   - CPUUtilization greater than or equal to threshold
*   - FreeableMemory less than threshold
*   - FreeStorageSpace less than threshold
*   - ReplicaLag greater than or equal to threshold
*
* All metrics are measured during a period of 60 seconds and evaluated
* during 2 consecutive periods.
*
* For master instances, we should leave the ReplicaLag alarm disabled. To
* disable the ReplicaLag alarm, set the `replicalag_threshold`
* parameter to 0.
*
* AWS/RDS metrics reference:
*
* http://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/rds-metricscollected.html
*/
variable "name_prefix" {
  type        = "string"
  description = "The alarm name prefix."
}

variable "alarm_actions" {
  type        = "list"
  description = "The list of actions to execute when this alarm transitions into an ALARM state. Each action is specified as an Amazon Resource Number (ARN)."
}

variable "db_instance_id" {
  type        = "string"
  description = "The ID of the database instance that we want to monitor."
}

variable "cpuutilization_threshold" {
  type        = "string"
  description = "The value against which the CPUUtilization metric is compared, in percent."
  default     = "80"
}

variable "freeablememory_threshold" {
  type        = "string"
  description = "The value against which the FreeableMemory metric is compared, in Bytes."
  default     = "2147483648"
}

variable "freestoragespace_threshold" {
  type        = "string"
  description = "The value against which the FreeStorageSpace metric is compared, in Bytes."
  default     = "10737418240"
}

variable "replicalag_threshold" {
  type        = "string"
  description = "The value against which the ReplicaLag metric is compared, in seconds."
  default     = "0"
}

# Resources
#--------------------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "rds_cpuutilization" {
  alarm_name          = "${var.name_prefix}-rds-cpuutilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = "${var.cpuutilization_threshold}"
  actions_enabled     = true
  alarm_actions       = ["${var.alarm_actions}"]
  alarm_description   = "This metric monitors the percentage of CPU utilization."

  dimensions {
    DBInstanceIdentifier = "${var.db_instance_id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "rds_freeablememory" {
  alarm_name          = "${var.name_prefix}-rds-freeablememory"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = "${var.freeablememory_threshold}"
  actions_enabled     = true
  alarm_actions       = ["${var.alarm_actions}"]
  alarm_description   = "This metric monitors the amount of available random access memory."

  dimensions {
    DBInstanceIdentifier = "${var.db_instance_id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "rds_freestoragespace" {
  alarm_name          = "${var.name_prefix}-rds-freestoragespace"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = "${var.freestoragespace_threshold}"
  actions_enabled     = true
  alarm_actions       = ["${var.alarm_actions}"]
  alarm_description   = "This metric monitors the amount of available storage space."

  dimensions {
    DBInstanceIdentifier = "${var.db_instance_id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "rds_replicalag" {
  count               = "${var.replicalag_threshold > 0 ? 1 : 0}"
  alarm_name          = "${var.name_prefix}-rds-replicalag"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "ReplicaLag"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "${var.replicalag_threshold}"
  actions_enabled     = true
  alarm_actions       = ["${var.alarm_actions}"]
  alarm_description   = "This metric monitors the amount of time a Read Replica DB instance lags behind the source DB instance."

  dimensions {
    DBInstanceIdentifier = "${var.db_instance_id}"
  }
}

# Outputs
#--------------------------------------------------------------

// The ID of the RDS CPUUtilization health check.
output "alarm_rds_cpuutilization_id" {
  value       = "${aws_cloudwatch_metric_alarm.rds_cpuutilization.id}"
  description = "The ID of the RDS CPUUtilization health check."
}

// The ID of the RDS FreeableMemory health check.
output "alarm_rds_freeablememory_id" {
  value       = "${aws_cloudwatch_metric_alarm.rds_freeablememory.id}"
  description = "The ID of the RDS FreeableMemory health check."
}

// The ID of the RDS FreeStorageSpace health check.
output "alarm_rds_freestoragespace_id" {
  value       = "${aws_cloudwatch_metric_alarm.rds_freestoragespace.id}"
  description = "The ID of the RDS FreeStorageSpace health check."
}

// The ID of the RDS ReplicaLag health check.
output "alarm_rds_replicalag_id" {
  value       = "${join("", aws_cloudwatch_metric_alarm.rds_replicalag.*.id)}"
  description = "The ID of the RDS ReplicaLag health check."
}
