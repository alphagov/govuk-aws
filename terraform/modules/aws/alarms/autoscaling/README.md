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
| autoscaling\_group\_name | The name of the AutoScalingGroup that we want to monitor. | `string` | n/a | yes |
| groupinserviceinstances\_threshold | The value against which the Autoscaling GroupInServiceInstaces metric is compared. | `string` | `"1"` | no |
| name\_prefix | The alarm name prefix. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| alarm\_autoscaling\_groupinserviceinstances\_id | The ID of the autoscaling GroupInServiceInstances health check. |
