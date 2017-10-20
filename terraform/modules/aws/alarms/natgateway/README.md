## Modules: aws::alarms::natgateway

This module creates the following CloudWatch alarms in the
AWS/NATGateway namespace:

  - ErrorPortAllocation greater than or equal to threshold
  - PacketsDropCount greater than or equal to threshold

All metrics are measured during a period of 60 seconds and evaluated
during 5 consecutive periods.

AWS/NATGateway metrics reference:
http://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/nat-gateway-metricscollected.html



## Inputs

| Name | Description | Default | Required |
|------|-------------|:-----:|:-----:|
| alarm_actions | The list of actions to execute when this alarm transitions into an ALARM state from any other state. Each action is specified as an Amazon Resource Number (ARN). | - | yes |
| errorportallocation_threshold | The value against which the ErrorPortAllocation metric is compared. Defaults to 10. | `10` | no |
| name_prefix | The alarm name prefix. | - | yes |
| nat_gateway_id | The ID of the NAT Gateway that we want to monitor. | - | yes |
| packetsdropcount_threshold | The value against which the PacketsDropCount metric is compared. Defaults to 100. | `100` | no |

## Outputs

| Name | Description |
|------|-------------|
| alarm_natgateway_errorportallocation_id | The ID of the NAT Gateway ErrorPortAllocation health check. |
| alarm_natgateway_packetsdropcount_id | The ID of the NAT Gateway PacketsDropCount health check. |

