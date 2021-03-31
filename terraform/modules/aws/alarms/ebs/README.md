## Module: aws/alarms/ebs

This module creates the following CloudWatch alarms in the
AWS/EBS namespace:

  - VolumeQueueLength greater than or equal to threshold

All metrics are measured during a period of 120 seconds and evaluated
during 2 consecutive periods.

AWS/EBS metrics reference:

http://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ebs-metricscollected.html

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
| [aws_cloudwatch_metric_alarm.ebs_volumequeuelength](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alarm_actions"></a> [alarm\_actions](#input\_alarm\_actions) | The list of actions to execute when this alarm transitions into an ALARM state. Each action is specified as an Amazon Resource Number (ARN). | `list` | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | The alarm name prefix. | `string` | n/a | yes |
| <a name="input_volume_id"></a> [volume\_id](#input\_volume\_id) | The ID of the EBS volume that we want to monitor. | `string` | n/a | yes |
| <a name="input_volumequeuelength_threshold"></a> [volumequeuelength\_threshold](#input\_volumequeuelength\_threshold) | The value against which the EBS VolumeQueueLength metric is compared. | `string` | `"10"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alarm_ebs_volumequeuelength_id"></a> [alarm\_ebs\_volumequeuelength\_id](#output\_alarm\_ebs\_volumequeuelength\_id) | The ID of the EBS VolumeQueueLength health check. |
