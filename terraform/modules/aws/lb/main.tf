/**
* ## Modules: aws/lb
*
* This module creates a Load Balancer resource, with associated
* listeners and default target groups, and CloudWatch alarms
*
* The listeners and default actions are configured in the `listener_action`
* map. The keys are the listeners PROTOCOL:PORT parameters, and the values
* are the PROTOCOL:PORT parameters of the default target group of that listener.
*
*```
* listener_action = {
*   "HTTP:80"   = "HTTP:8080"
*   "HTTPS:443" = "HTTP:8080"
* }
*```
*
* This module creates the following CloudWatch alarms in the
* AWS/ApplicationELB namespace:
*
*   - HTTPCode_Target_4XX_Count greater than or equal to threshold
*   - HTTPCode_Target_5XX_Count greater than or equal to threshold
*   - HTTPCode_ELB_4XX_Count greater than or equal to threshold
*   - HTTPCode_ELB_5XX_Count greater than or equal to threshold
*
* All metrics are measured during a period of 60 seconds and evaluated
* during 5 consecutive periods.
*
* To disable any alarm, set the threshold parameter to 0.
*
* AWS/ApplicationELB metrics reference:
*
* http://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/elb-metricscollected.html#load-balancer-metric-dimensions-alb
*/

variable "default_tags" {
  type        = "map"
  description = "Additional resource tags"
  default     = {}
}

variable "load_balancer_type" {
  type        = "string"
  description = "The type of load balancer to create. Possible values are application or network. The default value is application."
  default     = "application"
}

variable "access_logs_bucket_name" {
  type        = "string"
  description = "The S3 bucket name to store the logs in."
}

variable "access_logs_bucket_prefix" {
  type        = "string"
  description = "The S3 prefix name to store the logs in."
  default     = ""
}

variable "listener_action" {
  type        = "map"
  description = "A map of Load Balancer Listener and default target group action, both specified as PROTOCOL:PORT."
}

variable "listener_certificate_domain_name" {
  type        = "string"
  description = "HTTPS Listener certificate domain name."
  default     = ""
}

variable "listener_secondary_certificate_domain_name" {
  type        = "string"
  description = "HTTPS Listener secondary certificate domain name."
  default     = ""
}

variable "listener_ssl_policy" {
  type        = "string"
  description = "The name of the SSL Policy for HTTPS listeners."
  default     = "ELBSecurityPolicy-2016-08"
}

variable "internal" {
  type        = "string"
  description = "If true, the LB will be internal."
  default     = true
}

variable "name" {
  type        = "string"
  description = "The name of the LB. This name must be unique within your AWS account, can have a maximum of 32 characters."
}

variable "subnets" {
  type        = "list"
  description = "A list of subnet IDs to attach to the LB."
}

variable "security_groups" {
  type        = "list"
  description = "A list of security group IDs to assign to the LB. Only valid for Load Balancers of type application."
  default     = []
}

variable "vpc_id" {
  type        = "string"
  description = "The ID of the VPC in which the default target groups are created."
}

variable "target_group_health_check_path" {
  type        = "string"
  description = "The health check path."
  default     = "/_healthcheck"
}

variable "target_group_health_check_matcher" {
  type        = "string"
  description = "The health check match response code."
  default     = "200"
}

variable "target_group_deregistration_delay" {
  type        = "string"
  description = "The amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused."
  default     = 300
}

variable "target_group_health_check_interval" {
  type        = "string"
  description = "The approximate amount of time, in seconds, between health checks of an individual target. Minimum value 5 seconds, Maximum value 300 seconds."
  default     = 30
}

variable "target_group_health_check_timeout" {
  type        = "string"
  description = "The amount of time, in seconds, during which no response means a failed health check."
  default     = 5
}

variable "alarm_actions" {
  type        = "list"
  description = "The list of actions to execute when this alarm transitions into an ALARM state. Each action is specified as an Amazon Resource Number (ARN)."
  default     = []
}

variable "httpcode_target_4xx_count_threshold" {
  type        = "string"
  description = "The value against which the HTTPCode_Target_4XX_Count metric is compared."
  default     = "0"
}

variable "httpcode_target_5xx_count_threshold" {
  type        = "string"
  description = "The value against which the HTTPCode_Target_5XX_Count metric is compared."
  default     = "80"
}

variable "httpcode_elb_4xx_count_threshold" {
  type        = "string"
  description = "The value against which the HTTPCode_ELB_4XX_Count metric is compared."
  default     = "0"
}

variable "httpcode_elb_5xx_count_threshold" {
  type        = "string"
  description = "The value against which the HTTPCode_ELB_5XX_Count metric is compared."
  default     = "80"
}

# Resources
#--------------------------------------------------------------

data "aws_acm_certificate" "cert" {
  count    = "${var.listener_certificate_domain_name == "" ? 0 : 1}"
  domain   = "${var.listener_certificate_domain_name}"
  statuses = ["ISSUED"]
}

data "aws_acm_certificate" "secondary_cert" {
  count    = "${var.listener_secondary_certificate_domain_name == "" ? 0 : 1}"
  domain   = "${var.listener_secondary_certificate_domain_name}"
  statuses = ["ISSUED"]
}

resource "aws_lb" "lb" {
  name               = "${var.name}"
  internal           = "${var.internal}"
  security_groups    = ["${var.security_groups}"]
  subnets            = ["${var.subnets}"]
  load_balancer_type = "${var.load_balancer_type}"

  access_logs {
    enabled = true
    bucket  = "${var.access_logs_bucket_name}"
    prefix  = "${var.access_logs_bucket_prefix != "" ? var.access_logs_bucket_prefix : "lb/${var.name}"}"
  }

  tags = "${merge(
    var.default_tags,
    map(
      "Name", var.name
    )
  )}"
}

data "null_data_source" "values" {
  count = "${length(keys(var.listener_action))}"

  inputs = {
    ssl_arn_index = "${element(split(":", element(keys(var.listener_action), count.index)), 0) == "HTTPS" ? format("%d",count.index) : ""}"
    arn_index     = "${element(split(":", element(keys(var.listener_action), count.index)), 0) == "HTTP" ? format("%d",count.index) : ""}"
  }
}

resource "aws_lb_listener" "listener_non_ssl" {
  count             = "${length(compact(data.null_data_source.values.*.inputs.arn_index))}"
  load_balancer_arn = "${aws_lb.lb.arn}"
  port              = "${element(split(":", element(keys(var.listener_action), element(compact(data.null_data_source.values.*.inputs.arn_index),count.index))), 1)}"
  protocol          = "${element(split(":", element(keys(var.listener_action), element(compact(data.null_data_source.values.*.inputs.arn_index),count.index))), 0)}"

  default_action {
    target_group_arn = "${lookup(local.target_groups_arns, "${element(values(var.listener_action), element(compact(data.null_data_source.values.*.inputs.arn_index),count.index))}")}"
    type             = "forward"
  }
}

resource "aws_lb_listener" "listener" {
  count             = "${length(compact(data.null_data_source.values.*.inputs.ssl_arn_index))}"
  load_balancer_arn = "${aws_lb.lb.arn}"
  port              = "${element(split(":", element(keys(var.listener_action), element(compact(data.null_data_source.values.*.inputs.ssl_arn_index),count.index))), 1)}"
  protocol          = "${element(split(":", element(keys(var.listener_action), element(compact(data.null_data_source.values.*.inputs.ssl_arn_index),count.index))), 0)}"
  ssl_policy        = "${element(split(":", element(keys(var.listener_action), element(compact(data.null_data_source.values.*.inputs.ssl_arn_index),count.index))), 0) == "HTTPS" ? var.listener_ssl_policy : ""}"
  certificate_arn   = "${element(split(":", element(keys(var.listener_action), element(compact(data.null_data_source.values.*.inputs.ssl_arn_index),count.index))), 0) == "HTTPS" ? data.aws_acm_certificate.cert.0.arn : ""}"

  default_action {
    target_group_arn = "${lookup(local.target_groups_arns, "${element(values(var.listener_action), element(compact(data.null_data_source.values.*.inputs.ssl_arn_index),count.index))}")}"
    type             = "forward"
  }
}

resource "aws_lb_listener_certificate" "secondary" {
  count           = "${var.listener_secondary_certificate_domain_name == ""? 0 : length(compact(data.null_data_source.values.*.inputs.ssl_arn_index))}"
  listener_arn    = "${element(aws_lb_listener.listener.*.arn, count.index)}"
  certificate_arn = "${data.aws_acm_certificate.secondary_cert.0.arn}"
}

locals {
  target_groups = "${distinct(values(var.listener_action))}"
}

resource "aws_lb_target_group" "tg_default" {
  count                = "${length(local.target_groups)}"
  port                 = "${element(split(":", element(local.target_groups, count.index)), 1)}"
  protocol             = "${element(split(":", element(local.target_groups, count.index)), 0)}"
  vpc_id               = "${var.vpc_id}"
  deregistration_delay = "${var.target_group_deregistration_delay}"

  health_check {
    interval            = "${var.target_group_health_check_interval}"
    path                = "${var.target_group_health_check_path}"
    matcher             = "${var.target_group_health_check_matcher}"
    port                = "${element(split(":", element(local.target_groups, count.index)), 1)}"
    protocol            = "${element(split(":", element(local.target_groups, count.index)), 0)}"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = "${var.target_group_health_check_timeout}"
  }

  tags = "${merge(
    var.default_tags,
    map(
      "Name", "${var.name}-${replace(element(local.target_groups, count.index), ":", "-")}"
    )
  )}"
}

locals {
  target_groups_arns = "${zipmap(formatlist("%v:%v", aws_lb_target_group.tg_default.*.protocol, aws_lb_target_group.tg_default.*.port), aws_lb_target_group.tg_default.*.arn)}"
}

locals {
  alarm_dimensions_loadbalancer = "app/${aws_lb.lb.name}/${element(split("/", aws_lb.lb.arn), 3)}"
}

resource "aws_cloudwatch_metric_alarm" "elb_httpcode_elb_4xx_count" {
  count               = "${var.httpcode_elb_4xx_count_threshold > 0 ? 1 : 0}"
  alarm_name          = "${var.name}-elb-httpcode_elb_4xx_count"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "5"
  metric_name         = "HTTPCode_ELB_4XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Sum"
  threshold           = "${var.httpcode_elb_4xx_count_threshold}"
  actions_enabled     = true
  alarm_actions       = ["${var.alarm_actions}"]
  alarm_description   = "This metric monitors the sum of HTTP 4XX response codes generated by the Application LB."
  treat_missing_data  = "notBreaching"

  dimensions {
    LoadBalancer = "${local.alarm_dimensions_loadbalancer}"
  }
}

resource "aws_cloudwatch_metric_alarm" "elb_httpcode_elb_5xx_count" {
  count               = "${var.httpcode_elb_5xx_count_threshold > 0 ? 1 : 0}"
  alarm_name          = "${var.name}-elb-httpcode_elb_5xx_count"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "5"
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Sum"
  threshold           = "${var.httpcode_elb_5xx_count_threshold}"
  actions_enabled     = true
  alarm_actions       = ["${var.alarm_actions}"]
  alarm_description   = "This metric monitors the sum of HTTP 5XX response codes generated by the Application LB."
  treat_missing_data  = "notBreaching"

  dimensions {
    LoadBalancer = "${local.alarm_dimensions_loadbalancer}"
  }
}

resource "aws_cloudwatch_metric_alarm" "elb_httpcode_target_4xx_count" {
  count               = "${var.httpcode_target_4xx_count_threshold > 0 ? 1 : 0}"
  alarm_name          = "${var.name}-elb-httpcode_target_4xx_count"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "5"
  metric_name         = "HTTPCode_Target_4XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Sum"
  threshold           = "${var.httpcode_target_4xx_count_threshold}"
  actions_enabled     = true
  alarm_actions       = ["${var.alarm_actions}"]
  alarm_description   = "This metric monitors the sum of HTTP 4XX response codes generated by the Target Groups."
  treat_missing_data  = "notBreaching"

  dimensions {
    LoadBalancer = "${local.alarm_dimensions_loadbalancer}"
  }
}

resource "aws_cloudwatch_metric_alarm" "elb_httpcode_target_5xx_count" {
  count               = "${var.httpcode_target_5xx_count_threshold > 0 ? 1 : 0}"
  alarm_name          = "${var.name}-elb-httpcode_target_5xx_count"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "5"
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Sum"
  threshold           = "${var.httpcode_target_5xx_count_threshold}"
  actions_enabled     = true
  alarm_actions       = ["${var.alarm_actions}"]
  alarm_description   = "This metric monitors the sum of HTTP 5XX response codes generated by the Target Groups."
  treat_missing_data  = "notBreaching"

  dimensions {
    LoadBalancer = "${local.alarm_dimensions_loadbalancer}"
  }
}

# Outputs
#--------------------------------------------------------------

output "lb_id" {
  value       = "${aws_lb.lb.id}"
  description = "The ARN of the load balancer (matches arn)."
}

output "lb_arn_suffix" {
  value       = "${aws_lb.lb.arn_suffix}"
  description = "The ARN suffix for use with CloudWatch Metrics."
}

output "lb_dns_name" {
  value       = "${aws_lb.lb.dns_name}"
  description = "The DNS name of the load balancer."
}

output "lb_zone_id" {
  value       = "${aws_lb.lb.zone_id}"
  description = "The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record)."
}

output "target_group_arns" {
  value       = ["${aws_lb_target_group.tg_default.*.arn}"]
  description = "List of the default target group ARNs."
}

output "load_balancer_ssl_listeners" {
  value       = ["${aws_lb_listener.listener.*.arn}"]
  description = "List of https listeners on the Load Balancer."
}
