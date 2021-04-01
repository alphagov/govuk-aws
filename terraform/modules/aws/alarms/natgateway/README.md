## Modules: aws/alarms/natgateway

This module creates the following CloudWatch alarms in the
AWS/NATGateway namespace:

  - ErrorPortAllocation greater than or equal to threshold
  - PacketsDropCount greater than or equal to threshold

All metrics are measured during a period of 60 seconds and evaluated
during 5 consecutive periods.

AWS/NATGateway metrics reference:

http://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/nat-gateway-metricscollected.html

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
| [aws_cloudwatch_metric_alarm.natgateway_errorportallocation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.natgateway_packetsdropcount](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alarm_actions"></a> [alarm\_actions](#input\_alarm\_actions) | The list of actions to execute when this alarm transitions into an ALARM state. Each action is specified as an Amazon Resource Number (ARN). | `list` | n/a | yes |
| <a name="input_errorportallocation_threshold"></a> [errorportallocation\_threshold](#input\_errorportallocation\_threshold) | The value against which the ErrorPortAllocation metric is compared. | `string` | `"10"` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | The alarm name prefix. | `string` | n/a | yes |
| <a name="input_nat_gateway_ids"></a> [nat\_gateway\_ids](#input\_nat\_gateway\_ids) | List of IDs of the NAT Gateways that we want to monitor. | `list` | n/a | yes |
| <a name="input_nat_gateway_ids_length"></a> [nat\_gateway\_ids\_length](#input\_nat\_gateway\_ids\_length) | Length of the list of IDs of the NAT Gateways that we want to monitor. | `string` | n/a | yes |
| <a name="input_packetsdropcount_threshold"></a> [packetsdropcount\_threshold](#input\_packetsdropcount\_threshold) | The value against which the PacketsDropCount metric is compared. | `string` | `"100"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alarm_natgateway_errorportallocation_id"></a> [alarm\_natgateway\_errorportallocation\_id](#output\_alarm\_natgateway\_errorportallocation\_id) | The ID of the NAT Gateway ErrorPortAllocation health check. |
| <a name="output_alarm_natgateway_packetsdropcount_id"></a> [alarm\_natgateway\_packetsdropcount\_id](#output\_alarm\_natgateway\_packetsdropcount\_id) | The ID of the NAT Gateway PacketsDropCount health check. |
