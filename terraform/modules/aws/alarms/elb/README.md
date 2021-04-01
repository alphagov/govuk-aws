## Module: aws/alarms/elb

This module creates the following CloudWatch alarms in the
AWS/ELB namespace:

  - HTTPCode\_Backend\_4XX greater than or equal to threshold
  - HTTPCode\_Backend\_5XX greater than or equal to threshold
  - HTTPCode\_ELB\_4XX greater than or equal to threshold
  - HTTPCode\_ELB\_5XX greater than or equal to threshold
  - SurgeQueueLength greater than or equal to threshold
  - HealthyHostCount less than threshold

All metrics are measured during a period of 60 seconds and evaluated
during 5 consecutive periods.

HTTPCode\_* metrics are only reported for HTTP listeners. These metrics
should encapsulate errors caused by high SurgeQueueLength values and
lack of healthy backends.

For HTTP listeners we can disable SurgeQueueLength and HealthyHostCount
alarms. For TCP listeners, we should disable HTTPCode\_* alarms.

To disable HTTPCode\_* alarms, set the `httpcode_*_threshold` parameters to 0.
To disable the SurgeQueueLength alarm, set the `surgequeuelength_threshold`
parameter to 0.
To disable the HealthyHostCount alarm, set the `healthyhostcount_threshold`
parameter to 0.

AWS/ELB metrics reference:

http://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/elb-metricscollected.html

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
| [aws_cloudwatch_metric_alarm.elb_healthyhostcount](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.elb_httpcode_backend_4xx](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.elb_httpcode_backend_5xx](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.elb_httpcode_elb_4xx](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.elb_httpcode_elb_5xx](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.elb_surgequeuelength](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alarm_actions"></a> [alarm\_actions](#input\_alarm\_actions) | The list of actions to execute when this alarm transitions into an ALARM state. Each action is specified as an Amazon Resource Number (ARN). | `list` | n/a | yes |
| <a name="input_elb_name"></a> [elb\_name](#input\_elb\_name) | The name of the ELB that we want to monitor. | `string` | n/a | yes |
| <a name="input_healthyhostcount_threshold"></a> [healthyhostcount\_threshold](#input\_healthyhostcount\_threshold) | The value against which the HealthyHostCount metric is compared. | `string` | `"0"` | no |
| <a name="input_httpcode_backend_4xx_threshold"></a> [httpcode\_backend\_4xx\_threshold](#input\_httpcode\_backend\_4xx\_threshold) | The value against which the HTTPCode\_Backend\_4XX metric is compared. | `string` | `"80"` | no |
| <a name="input_httpcode_backend_5xx_threshold"></a> [httpcode\_backend\_5xx\_threshold](#input\_httpcode\_backend\_5xx\_threshold) | The value against which the HTTPCode\_Backend\_5XX metric is compared. | `string` | `"80"` | no |
| <a name="input_httpcode_elb_4xx_threshold"></a> [httpcode\_elb\_4xx\_threshold](#input\_httpcode\_elb\_4xx\_threshold) | The value against which the HTTPCode\_ELB\_4XX metric is compared. | `string` | `"80"` | no |
| <a name="input_httpcode_elb_5xx_threshold"></a> [httpcode\_elb\_5xx\_threshold](#input\_httpcode\_elb\_5xx\_threshold) | The value against which the HTTPCode\_ELB\_5XX metric is compared. | `string` | `"80"` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | The alarm name prefix. | `string` | n/a | yes |
| <a name="input_surgequeuelength_threshold"></a> [surgequeuelength\_threshold](#input\_surgequeuelength\_threshold) | The value against which the SurgeQueueLength metric is compared. The maximum size of the queue is 1,024. Additional requests are rejected when the queue is full. | `string` | `"0"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alarm_elb_healthyhostcount_id"></a> [alarm\_elb\_healthyhostcount\_id](#output\_alarm\_elb\_healthyhostcount\_id) | The ID of the ELB HealthyHostCount health check. |
| <a name="output_alarm_elb_httpcode_backend_4xx_id"></a> [alarm\_elb\_httpcode\_backend\_4xx\_id](#output\_alarm\_elb\_httpcode\_backend\_4xx\_id) | The ID of the ELB HTTPCode\_Backend\_4XX health check. |
| <a name="output_alarm_elb_httpcode_backend_5xx_id"></a> [alarm\_elb\_httpcode\_backend\_5xx\_id](#output\_alarm\_elb\_httpcode\_backend\_5xx\_id) | The ID of the ELB HTTPCode\_Backend\_5XX health check. |
| <a name="output_alarm_elb_httpcode_elb_4xx_id"></a> [alarm\_elb\_httpcode\_elb\_4xx\_id](#output\_alarm\_elb\_httpcode\_elb\_4xx\_id) | The ID of the ELB HTTPCode\_ELB\_4XX health check. |
| <a name="output_alarm_elb_httpcode_elb_5xx_id"></a> [alarm\_elb\_httpcode\_elb\_5xx\_id](#output\_alarm\_elb\_httpcode\_elb\_5xx\_id) | The ID of the ELB HTTPCode\_ELB\_5XX health check. |
| <a name="output_alarm_elb_surgequeuelength_id"></a> [alarm\_elb\_surgequeuelength\_id](#output\_alarm\_elb\_surgequeuelength\_id) | The ID of the ELB SurgeQueueLength health check. |
