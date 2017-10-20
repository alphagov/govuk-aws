## Modules: aws::alarms::rds

This module creates the following CloudWatch alarms in the
AWS/RDS namespace:

  - CPUUtilization greater than or equal to threshold
  - FreeableMemory less than threshold
  - FreeStorageSpace less than threshold
  - ReplicaLag greater than or equal to threshold

All metrics are measured during a period of 60 seconds and evaluated
during 2 consecutive periods.

For master instances, we should leave the ReplicaLag alarm disabled. To
disable the ReplicaLag alarm, set the `replicalag_threshold`
parameter to 0.

AWS/RDS metrics reference:
http://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/rds-metricscollected.html



## Inputs

| Name | Description | Default | Required |
|------|-------------|:-----:|:-----:|
| alarm_actions | The list of actions to execute when this alarm transitions into an ALARM state from any other state. Each action is specified as an Amazon Resource Number (ARN). | - | yes |
| cpuutilization_threshold | The value against which the CPUUtilization metric is compared. Defaults to 80. | `80` | no |
| db_instance_id | The ID of the database instance that we want to monitor. | - | yes |
| freeablememory_threshold | The value against which the FreeableMemory metric is compared. Defaults to 2147483648 Bytes (2 Gb). | `2147483648` | no |
| freestoragespace_threshold | The value against which the FreeStorageSpace metric is compared. Defaults to 10737418240 Bytes (10 Gb). | `10737418240` | no |
| name_prefix | The alarm name prefix. | - | yes |
| replicalag_threshold | The value against which the ReplicaLag metric is compared. Defaults to 0 (disabled) | `0` | no |

## Outputs

| Name | Description |
|------|-------------|
| alarm_rds_cpuutilization_id | The ID of the RDS CPUUtilization health check. |
| alarm_rds_freeablememory_id | The ID of the RDS FreeableMemory health check. |
| alarm_rds_freestoragespace_id | The ID of the RDS FreeStorageSpace health check. |
| alarm_rds_replicalag_id | The ID of the RDS ReplicaLag health check. |

