/**
* ## Modules: aws/lb
*
* This module creates a Load Balancer resource, with associated
* listeners and default target groups.
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

variable "listener_ssl_policy" {
  type        = "string"
  description = "The name of the SSL Policy for HTTPS listeners."
  default     = "ELBSecurityPolicy-2015-05"
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

# Resources
#--------------------------------------------------------------

data "aws_acm_certificate" "cert" {
  domain   = "${var.listener_certificate_domain_name}"
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

resource "aws_lb_listener" "listener" {
  count             = "${length(keys(var.listener_action))}"
  load_balancer_arn = "${aws_lb.lb.arn}"
  port              = "${element(split(":", element(keys(var.listener_action), count.index)), 1)}"
  protocol          = "${element(split(":", element(keys(var.listener_action), count.index)), 0)}"
  ssl_policy        = "${var.listener_ssl_policy}"
  certificate_arn   = "${length(var.listener_certificate_domain_name) > 0 ? data.aws_acm_certificate.cert.arn : ""}"

  default_action {
    target_group_arn = "${lookup(local.target_groups_arns, "${var.name}-${replace(element(values(var.listener_action), count.index), ":", "-")}")}"
    type             = "forward"
  }
}

locals {
  target_groups = "${distinct(values(var.listener_action))}"
}

resource "aws_lb_target_group" "tg_default" {
  count                = "${length(local.target_groups)}"
  name                 = "${var.name}-${replace(element(local.target_groups, count.index), ":", "-")}"
  port                 = "${element(split(":", element(local.target_groups, count.index)), 1)}"
  protocol             = "${element(split(":", element(local.target_groups, count.index)), 0)}"
  vpc_id               = "${var.vpc_id}"
  deregistration_delay = "${var.target_group_deregistration_delay}"

  health_check {
    interval            = "${var.target_group_health_check_interval}"
    port                = "traffic-port"
    protocol            = "${element(split(":", element(local.target_groups, count.index)), 0)}"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = "${var.target_group_health_check_timeout}"
  }
}

locals {
  target_groups_arns = "${zipmap(aws_lb_target_group.tg_default.*.name, aws_lb_target_group.tg_default.*.arn)}"
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
