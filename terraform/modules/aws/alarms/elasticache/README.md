## Module: aws::alarms::elasticache

This module creates the following CloudWatch alarms in the  
AWS/ElastiCache namespace:

  - CPUUtilization greater than or equal to threshold  
  - FreeableMemory less than threshold

All metrics are measured during a period of 60 seconds and evaluated  
during 2 consecutive periods.

AWS/ElastiCache metrics reference:  
http://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/elasticache-metricscollected.html

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| alarm\_actions | The list of actions to execute when this alarm transitions into an ALARM state. Each action is specified as an Amazon Resource Number (ARN). | `list` | n/a | yes |
| cache\_cluster\_id | The ID of the cache cluster that we want to monitor. | `string` | n/a | yes |
| cpuutilization\_threshold | The value against which the CPUUtilization metric is compared, in percent. | `string` | `"80"` | no |
| freeablememory\_threshold | The value against which the FreeableMemory metric is compared, in Bytes. | `string` | `"2147483648"` | no |
| name\_prefix | The alarm name prefix. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| alarm\_elasticache\_cpuutilization\_id | The ID of the ElastiCache CPUUtilization health check. |
| alarm\_elasticache\_freeablememory\_id | The ID of the ElastiCache FreeableMemory health check. |

