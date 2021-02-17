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
| name\_prefix | The alarm name prefix. | `string` | n/a | yes |
| volume\_id | The ID of the EBS volume that we want to monitor. | `string` | n/a | yes |
| volumequeuelength\_threshold | The value against which the EBS VolumeQueueLength metric is compared. | `string` | `"10"` | no |

## Outputs

| Name | Description |
|------|-------------|
| alarm\_ebs\_volumequeuelength\_id | The ID of the EBS VolumeQueueLength health check. |
