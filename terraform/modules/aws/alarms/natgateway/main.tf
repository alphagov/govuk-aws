/**
* ## Modules: aws/alarms/natgateway
*
* This module creates the following CloudWatch alarms in the
* AWS/NATGateway namespace:
*
*   - ErrorPortAllocation greater than or equal to threshold
*   - PacketsDropCount greater than or equal to threshold
*
* All metrics are measured during a period of 60 seconds and evaluated
* during 5 consecutive periods.
*
* AWS/NATGateway metrics reference:
*
* http://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/nat-gateway-metricscollected.html
*/
variable "name_prefix" {
  type        = "string"
  description = "The alarm name prefix."
}

variable "alarm_actions" {
  type        = "list"
  description = "The list of actions to execute when this alarm transitions into an ALARM state. Each action is specified as an Amazon Resource Number (ARN)."
}

variable "nat_gateway_ids" {
  type        = "list"
  description = "List of IDs of the NAT Gateways that we want to monitor."
}

variable "nat_gateway_ids_length" {
  type        = "string"
  description = "Length of the list of IDs of the NAT Gateways that we want to monitor."
}

variable "errorportallocation_threshold" {
  type        = "string"
  description = "The value against which the ErrorPortAllocation metric is compared."
  default     = "10"
}

variable "packetsdropcount_threshold" {
  type        = "string"
  description = "The value against which the PacketsDropCount metric is compared."
  default     = "100"
}

# Resources
#--------------------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "natgateway_errorportallocation" {
  count               = "${var.nat_gateway_ids_length}"
  alarm_name          = "${var.name_prefix}-natgateway-errorportallocation-${element(var.nat_gateway_ids, count.index)}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "5"
  metric_name         = "ErrorPortAllocation"
  namespace           = "AWS/NATGateway"
  period              = "60"
  statistic           = "Sum"
  threshold           = "${var.errorportallocation_threshold}"
  actions_enabled     = true
  alarm_actions       = var.alarm_actions
  alarm_description   = "This metric monitors the sum of the number of times the NAT gateway could not allocate a source port."

  dimensions = {
    NatGatewayId = "${element(var.nat_gateway_ids, count.index)}"
  }
}

resource "aws_cloudwatch_metric_alarm" "natgateway_packetsdropcount" {
  count               = "${var.nat_gateway_ids_length}"
  alarm_name          = "${var.name_prefix}-natgateway-packetsdropcount-${element(var.nat_gateway_ids, count.index)}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "5"
  metric_name         = "PacketsDropCount"
  namespace           = "AWS/NATGateway"
  period              = "60"
  statistic           = "Sum"
  threshold           = "${var.packetsdropcount_threshold}"
  actions_enabled     = true
  alarm_actions       = var.alarm_actions
  alarm_description   = "This metric monitors the number of packets dropped by the NAT gateway."

  dimensions = {
    NatGatewayId = "${element(var.nat_gateway_ids, count.index)}"
  }
}

# Outputs
#--------------------------------------------------------------

// The ID of the NAT Gateway ErrorPortAllocation health check.
output "alarm_natgateway_errorportallocation_id" {
  value       = "${aws_cloudwatch_metric_alarm.natgateway_errorportallocation.*.id}"
  description = "The ID of the NAT Gateway ErrorPortAllocation health check."
}

// The ID of the NAT Gateway PacketsDropCount health check.
output "alarm_natgateway_packetsdropcount_id" {
  value       = "${aws_cloudwatch_metric_alarm.natgateway_packetsdropcount.*.id}"
  description = "The ID of the NAT Gateway PacketsDropCount health check."
}
