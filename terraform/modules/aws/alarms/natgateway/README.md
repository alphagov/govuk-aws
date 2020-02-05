## Modules: aws/alarms/natgateway

This module creates the following CloudWatch alarms in the  
AWS/NATGateway namespace:

  - ErrorPortAllocation greater than or equal to threshold
  - PacketsDropCount greater than or equal to threshold

All metrics are measured during a period of 60 seconds and evaluated  
during 5 consecutive periods.

AWS/NATGateway metrics reference:

http://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/nat-gateway-metricscollected.html

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| alarm\_actions | The list of actions to execute when this alarm transitions into an ALARM state. Each action is specified as an Amazon Resource Number (ARN). | `list` | n/a | yes |
| errorportallocation\_threshold | The value against which the ErrorPortAllocation metric is compared. | `string` | `"10"` | no |
| name\_prefix | The alarm name prefix. | `string` | n/a | yes |
| nat\_gateway\_ids | List of IDs of the NAT Gateways that we want to monitor. | `list` | n/a | yes |
| nat\_gateway\_ids\_length | Length of the list of IDs of the NAT Gateways that we want to monitor. | `string` | n/a | yes |
| packetsdropcount\_threshold | The value against which the PacketsDropCount metric is compared. | `string` | `"100"` | no |

## Outputs

| Name | Description |
|------|-------------|
| alarm\_natgateway\_errorportallocation\_id | The ID of the NAT Gateway ErrorPortAllocation health check. |
| alarm\_natgateway\_packetsdropcount\_id | The ID of the NAT Gateway PacketsDropCount health check. |

