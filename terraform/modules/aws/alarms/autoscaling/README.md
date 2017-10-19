## Module: aws::alarms::autoscaling

This module creates the following CloudWatch alarms in the
AWS/Autoscaling namespace:

  - GroupInServiceInstances less than threshold, where
    `groupinserviceinstances_threshold` is a given parameter


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| alarm_actions | The list of actions to execute when this alarm transitions into an ALARM state from any other state. Each action is specified as an Amazon Resource Number (ARN). | list | - | yes |
| autoscaling_group_name | The name of the AutoScalingGroup that we want to monitor. | string | - | yes |
| groupinserviceinstances_threshold | The value against which the Autoscaling GroupInServiceInstaces metric is compared. Defaults to 1. | string | `1` | no |
| name_prefix | The alarm name prefix. | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| alarm_autoscaling_groupinserviceinstances_id | Outputs -------------------------------------------------------------- |

