## Module: aws/alarms/autoscaling

This module creates the following CloudWatch alarms in the
AWS/Autoscaling namespace:

  - GroupInServiceInstances less than threshold

All metrics are measured during a period of 60 seconds and evaluated
during 2 consecutive periods.

AWS/Autoscaling metrics reference:

http://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/as-metricscollected.html

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
| [aws_cloudwatch_metric_alarm.autoscaling_groupinserviceinstances](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alarm_actions"></a> [alarm\_actions](#input\_alarm\_actions) | The list of actions to execute when this alarm transitions into an ALARM state. Each action is specified as an Amazon Resource Number (ARN). | `list(string)` | n/a | yes |
| <a name="input_autoscaling_group_name"></a> [autoscaling\_group\_name](#input\_autoscaling\_group\_name) | The name of the AutoScalingGroup that we want to monitor. | `string` | n/a | yes |
| <a name="input_groupinserviceinstances_threshold"></a> [groupinserviceinstances\_threshold](#input\_groupinserviceinstances\_threshold) | The value against which the Autoscaling GroupInServiceInstaces metric is compared. | `string` | `"1"` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | The alarm name prefix. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alarm_autoscaling_groupinserviceinstances_id"></a> [alarm\_autoscaling\_groupinserviceinstances\_id](#output\_alarm\_autoscaling\_groupinserviceinstances\_id) | The ID of the autoscaling GroupInServiceInstances health check. |
