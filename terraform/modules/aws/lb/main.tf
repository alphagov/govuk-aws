/**
* ## Modules: aws/lb
*
* This module creates a Load Balancer resource, with associated
* listeners and target groups.
*
* Listeners and target groups are defined with map variables,
* where the key is the name of the resource, and the value is
* the port and protocol of the resource, specified as `PROTOCOL:PORT`.
*
* Listeners are associated to target groups with the `listener_target_groups`
* map, that uses the name of the resources.
*
* When using a listener on HTTPS, we can specify the certificate with
* the `listener_certificates` variable, where the value is the domain name
* of the certificate as registered on AWS. The value is used by an
* `aws_acm_certificate` data resource to find the certificate ARN.
*
*```
* listeners = {
*   "myapp-http-80"   = "HTTP:80"
*   "myapp-https-443" = "HTTPS:443"
* }
*
* target_groups = {
*   "http-80" = "HTTP:80"
* }
*
* listener_target_groups = {
*   "myapp-http-80"   = "http-80"
*   "myapp-https-443" = "http-80"
* }
*
* listener_certificates = {
*   "myapp-https-443" = "mydomain.com"
* }
*
*```
*/

variable "default_tags" {
  type        = "map"
  description = "Additional resource tags"
  default     = {}
}

variable "vpc_id" {
  type        = "string"
  description = "The ID of the VPC in which the target groups are created."
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

variable "listeners" {
  type        = "map"
  description = "A map of Load Balancer Listener resources."
}

variable "listener_certificates" {
  type        = "map"
  description = "A map of Load Balancer Listener certificate domain names."
}

variable "target_groups" {
  type        = "map"
  description = "A map of Load Balancer Target group resources."
}

variable "listener_target_groups" {
  type        = "map"
  description = "A map matching Load Balancer Listeners and Target groups"
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
  count    = "${length(keys(var.listener_certificates))}"
  domain   = "${element(values(var.listener_certificates), count.index)}"
  statuses = ["ISSUED"]
}

locals {
  listener_certificate_arns = "${zipmap(keys(var.listener_certificates), data.aws_acm_certificate.cert.*.arn)}"
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
    prefix  = "lb/${var.name}"
  }

  tags = "${merge(
    var.default_tags,
    map(
      "Name", var.name
    )
  )}"
}

resource "aws_lb_listener" "listener" {
  count             = "${length(keys(var.listeners))}"
  load_balancer_arn = "${aws_lb.lb.arn}"
  port              = "${element(split(":", lookup(var.listeners, element(keys(var.listeners), count.index))), 1)}"
  protocol          = "${element(split(":", lookup(var.listeners, element(keys(var.listeners), count.index))), 0)}"
  ssl_policy        = "ELBSecurityPolicy-2015-05"
  certificate_arn   = "${lookup(local.listener_certificate_arns, element(keys(var.listeners), count.index), "")}"

  default_action {
    target_group_arn = "${matchkeys(values(local.target_groups_arns), keys(local.target_groups_arns), lookup(var.listener_target_groups, element(keys(var.listeners), count.index)))}"
    type             = "forward"
  }
}

resource "aws_lb_target_group" "tg" {
  count                = "${length(keys(var.target_groups))}"
  name                 = "${element(keys(var.target_groups), count.index)}"
  port                 = "${element(split(":", lookup(var.target_groups, element(keys(var.target_groups), count.index))), 1)}"
  protocol             = "${element(split(":", lookup(var.target_groups, element(keys(var.target_groups), count.index))), 0)}"
  vpc_id               = "${var.vpc_id}"
  deregistration_delay = "${var.target_group_deregistration_delay}"

  health_check {
    interval            = "${var.target_group_health_check_interval}"
    port                = "traffic-port"
    protocol            = "${element(split(":", lookup(var.target_groups, element(keys(var.target_groups), count.index))), 0)}"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = "${var.target_group_health_check_timeout}"
  }
}

locals {
  target_groups_arns = "${zipmap(aws_lb_target_group.tg.*.name, aws_lb_target_group.tg.*.arn)}"
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
