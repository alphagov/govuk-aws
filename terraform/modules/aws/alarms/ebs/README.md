## Module: aws::alarms::ebs

This module creates the following CloudWatch alarms in the
AWS/EBS namespace:

  - VolumeQueueLength greater than or equal to threshold, where
    `volumequeuelength_threshold` is a given parameter

AWS/EBS metrics reference:
http://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ebs-metricscollected.html


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| alarm_actions | The list of actions to execute when this alarm transitions into an ALARM state from any other state. Each action is specified as an Amazon Resource Number (ARN). | list | - | yes |
| name_prefix | The alarm name prefix. | string | - | yes |
| volume_id | The ID of the EBS volume that we want to monitor. | string | - | yes |
| volumequeuelength_threshold | The value against which the EBS VolumeQueueLength metric is compared. Defaults to 10. | string | `10` | no |

## Outputs

| Name | Description |
|------|-------------|
| alarm_ebs_volumequeuelength_id | Outputs -------------------------------------------------------------- |

