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
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_metric_alarm.rds_cpuutilization](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.rds_freeablememory](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.rds_freestoragespace](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.rds_replicalag](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alarm_actions"></a> [alarm\_actions](#input\_alarm\_actions) | The list of actions to execute when this alarm transitions into an ALARM state. Each action is specified as an Amazon Resource Number (ARN). | `list(string)` | n/a | yes |
| <a name="input_cpuutilization_threshold"></a> [cpuutilization\_threshold](#input\_cpuutilization\_threshold) | The value against which the CPUUtilization metric is compared, in percent. | `string` | `"80"` | no |
| <a name="input_db_instance_id"></a> [db\_instance\_id](#input\_db\_instance\_id) | The ID of the database instance that we want to monitor. | `string` | n/a | yes |
| <a name="input_freeablememory_threshold"></a> [freeablememory\_threshold](#input\_freeablememory\_threshold) | The value against which the FreeableMemory metric is compared, in Bytes. | `string` | `"2147483648"` | no |
| <a name="input_freestoragespace_threshold"></a> [freestoragespace\_threshold](#input\_freestoragespace\_threshold) | The value against which the FreeStorageSpace metric is compared, in Bytes. | `string` | `"10737418240"` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | The alarm name prefix. | `string` | n/a | yes |
| <a name="input_replicalag_threshold"></a> [replicalag\_threshold](#input\_replicalag\_threshold) | The value against which the ReplicaLag metric is compared, in seconds. | `string` | `"0"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alarm_rds_cpuutilization_id"></a> [alarm\_rds\_cpuutilization\_id](#output\_alarm\_rds\_cpuutilization\_id) | The ID of the RDS CPUUtilization health check. |
| <a name="output_alarm_rds_freeablememory_id"></a> [alarm\_rds\_freeablememory\_id](#output\_alarm\_rds\_freeablememory\_id) | The ID of the RDS FreeableMemory health check. |
| <a name="output_alarm_rds_freestoragespace_id"></a> [alarm\_rds\_freestoragespace\_id](#output\_alarm\_rds\_freestoragespace\_id) | The ID of the RDS FreeStorageSpace health check. |
| <a name="output_alarm_rds_replicalag_id"></a> [alarm\_rds\_replicalag\_id](#output\_alarm\_rds\_replicalag\_id) | The ID of the RDS ReplicaLag health check. |
