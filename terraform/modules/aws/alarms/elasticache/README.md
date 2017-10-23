## Module: aws::alarms::elasticache

This module creates the following CloudWatch alarms in the
AWS/ElastiCache namespace:

  - CPUUtilization greater than or equal to threshold
  - FreeableMemory less than threshold

All metrics are measured during a period of 60 seconds and evaluated
during 2 consecutive periods.

AWS/ElastiCache metrics reference:
http://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/elasticache-metricscollected.html



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| alarm_actions | The list of actions to execute when this alarm transitions into an ALARM state. Each action is specified as an Amazon Resource Number (ARN). | list | - | yes |
| cache_cluster_id | The ID of the cache cluster that we want to monitor. | string | - | yes |
| cpuutilization_threshold | The value against which the CPUUtilization metric is compared, in percent. | string | `80` | no |
| freeablememory_threshold | The value against which the FreeableMemory metric is compared, in Bytes. | string | `2147483648` | no |
| name_prefix | The alarm name prefix. | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| alarm_elasticache_cpuutilization_id | The ID of the ElastiCache CPUUtilization health check. |
| alarm_elasticache_freeablememory_id | The ID of the ElastiCache FreeableMemory health check. |

