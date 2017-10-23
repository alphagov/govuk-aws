## Module: aws/alarms/autoscaling

This module creates the following CloudWatch alarms in the
AWS/Autoscaling namespace:

  - GroupInServiceInstances less than threshold

All metrics are measured during a period of 60 seconds and evaluated
during 2 consecutive periods.

AWS/Autoscaling metrics reference:

http://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/as-metricscollected.html



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| alarm_actions | The list of actions to execute when this alarm transitions into an ALARM state. Each action is specified as an Amazon Resource Number (ARN). | list | - | yes |
| autoscaling_group_name | The name of the AutoScalingGroup that we want to monitor. | string | - | yes |
| groupinserviceinstances_threshold | The value against which the Autoscaling GroupInServiceInstaces metric is compared. | string | `1` | no |
| name_prefix | The alarm name prefix. | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| alarm_autoscaling_groupinserviceinstances_id | The ID of the autoscaling GroupInServiceInstances health check. |

