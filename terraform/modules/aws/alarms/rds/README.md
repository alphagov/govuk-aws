## Modules: aws/alarms/rds

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

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_cloudwatch_metric_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alarm\_actions | The list of actions to execute when this alarm transitions into an ALARM state. Each action is specified as an Amazon Resource Number (ARN). | `list` | n/a | yes |
| cpuutilization\_threshold | The value against which the CPUUtilization metric is compared, in percent. | `string` | `"80"` | no |
| db\_instance\_id | The ID of the database instance that we want to monitor. | `string` | n/a | yes |
| freeablememory\_threshold | The value against which the FreeableMemory metric is compared, in Bytes. | `string` | `"2147483648"` | no |
| freestoragespace\_threshold | The value against which the FreeStorageSpace metric is compared, in Bytes. | `string` | `"10737418240"` | no |
| name\_prefix | The alarm name prefix. | `string` | n/a | yes |
| replicalag\_threshold | The value against which the ReplicaLag metric is compared, in seconds. | `string` | `"0"` | no |

## Outputs

| Name | Description |
|------|-------------|
| alarm\_rds\_cpuutilization\_id | The ID of the RDS CPUUtilization health check. |
| alarm\_rds\_freeablememory\_id | The ID of the RDS FreeableMemory health check. |
| alarm\_rds\_freestoragespace\_id | The ID of the RDS FreeStorageSpace health check. |
| alarm\_rds\_replicalag\_id | The ID of the RDS ReplicaLag health check. |
