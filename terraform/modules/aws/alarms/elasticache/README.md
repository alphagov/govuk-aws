## Module: aws::alarms::elasticache

This module creates the following CloudWatch alarms in the
AWS/ElastiCache namespace:

  - CPUUtilization greater than or equal to threshold
  - FreeableMemory less than threshold

All metrics are measured during a period of 60 seconds and evaluated
during 2 consecutive periods.

AWS/ElastiCache metrics reference:
http://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/elasticache-metricscollected.html

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
| [aws_cloudwatch_metric_alarm.elasticache_cpuutilization](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.elasticache_freeablememory](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alarm_actions"></a> [alarm\_actions](#input\_alarm\_actions) | The list of actions to execute when this alarm transitions into an ALARM state. Each action is specified as an Amazon Resource Number (ARN). | `list` | n/a | yes |
| <a name="input_cache_cluster_id"></a> [cache\_cluster\_id](#input\_cache\_cluster\_id) | The ID of the cache cluster that we want to monitor. | `string` | n/a | yes |
| <a name="input_cpuutilization_threshold"></a> [cpuutilization\_threshold](#input\_cpuutilization\_threshold) | The value against which the CPUUtilization metric is compared, in percent. | `string` | `"80"` | no |
| <a name="input_freeablememory_threshold"></a> [freeablememory\_threshold](#input\_freeablememory\_threshold) | The value against which the FreeableMemory metric is compared, in Bytes. | `string` | `"2147483648"` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | The alarm name prefix. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alarm_elasticache_cpuutilization_id"></a> [alarm\_elasticache\_cpuutilization\_id](#output\_alarm\_elasticache\_cpuutilization\_id) | The ID of the ElastiCache CPUUtilization health check. |
| <a name="output_alarm_elasticache_freeablememory_id"></a> [alarm\_elasticache\_freeablememory\_id](#output\_alarm\_elasticache\_freeablememory\_id) | The ID of the ElastiCache FreeableMemory health check. |
