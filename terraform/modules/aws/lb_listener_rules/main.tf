/**
* ## Modules: aws/lb_listener_rules
*
* This module creates Load Balancer listener rules and target groups for
* an existing listener resource.
*
* You can specify rules based on host header with the `rules_host` variable,
* path pattern with the `rules_path` variable, or both with the `rules_host_and_path`
* variable. Rules from the three variables are merged and prioritised in the order
* `rules_host_and_path`, `rules_host` and `rules_path`.
*
* The three variables are map types. The values of the maps define the target group
* port and protocol where requests are routed when they meet the rule condition, with
* the format TARGET_GROUP_PROTOCOL:TARGET_GROUP_PORT.
*
* The keys of `rules_host` are evaluated against the Host header of the request. The
* keys of `rules_path` are evaluated against the path of the request. If the 
* `rules_host_and_path` variable is provided, the key has the format FIELD:VALUE.
* FIELD must be one of 'path-pattern' for path based routing or 'host-header' for host
* based routing.
*
*```
* rules_host {
*   "www.example1.com" = "HTTP:8080"
*   "www.example2.com" = "HTTPS:9091"
*   "www.example3.*"   = "HTTP:8080"
* }
*
* rules_host_and_path {
*  "host-header:www.example1.com" = "HTTP:8080"
*  "host-header:www.example2.com" = "HTTPS:9091"
*  "path-pattern:/example3"       = "HTTPS:9091"
* }
*```
*
* Limitations:
*  - The target group deregistration_delay, health_check_interval and health_check_timeout
* values can be configured with variables, but will be the same for all the target groups
*  - With Terraform we can't provide a 'count' or list for listener_rule condition blocks,
* so at the moment only one condition can be specified per rule
*/

variable "listener_arn" {
  type        = "string"
  description = "ARN of the listener."
}

variable "rules_host" {
  type        = "map"
  description = "A map with the value of a host-header rule condition and the target group associated."
  default     = {}
}

variable "rules_path" {
  type        = "map"
  description = "A map with the value of a path-pattern rule condition and the target group associated"
  default     = {}
}

variable "rules_host_and_path" {
  type        = "map"
  description = "A map with the value of a rule with the format FIELD:VALUE and the target group associated. FIELD can be one of 'host-header' or 'path-pattern'"
  default     = {}
}

variable "name" {
  type        = "string"
  description = "Prefix of the target group names. The final name is name-PROTOCOL-PORT."
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

locals {
  hosts = "${zipmap(formatlist("%s:%s", "host-header", keys(var.rules_host)), values(var.rules_host))}"
  paths = "${zipmap(formatlist("%s:%s", "path-pattern", keys(var.rules_path)), values(var.rules_path))}"
  rules = "${merge(var.rules_host_and_path, local.hosts, local.paths)}"
}

locals {
  target_groups = "${distinct(values(local.rules))}"
}

resource "aws_lb_target_group" "tg" {
  count                = "${length(local.target_groups)}"
  name                 = "${var.name}-${replace(element(local.target_groups, count.index), ":", "-")}"
  port                 = "${element(split(":", element(local.target_groups, count.index)), 1)}"
  protocol             = "${element(split(":", element(local.target_groups, count.index)), 0)}"
  vpc_id               = "${var.vpc_id}"
  deregistration_delay = "${var.target_group_deregistration_delay}"

  health_check {
    interval            = "${var.target_group_health_check_interval}"
    path                = "/"
    matcher             = "200-499"
    port                = "traffic-port"
    protocol            = "${element(split(":", element(local.target_groups, count.index)), 0)}"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = "${var.target_group_health_check_timeout}"
  }
}

locals {
  target_groups_arns = "${zipmap(aws_lb_target_group.tg.*.name, aws_lb_target_group.tg.*.arn)}"
}

resource "aws_lb_listener_rule" "routing" {
  count        = "${length(keys(local.rules))}"
  listener_arn = "${var.listener_arn}"
  priority     = "${count.index + 1}"

  action {
    type             = "forward"
    target_group_arn = "${lookup(local.target_groups_arns, "${var.name}-${replace(element(values(local.rules), count.index), ":", "-")}")}"
  }

  condition {
    field  = "${element(split(":", element(keys(local.rules), count.index)), 0)}"
    values = ["${element(split(":", element(keys(local.rules), count.index)), 1)}"]
  }
}

# Outputs
#--------------------------------------------------------------

output "target_group_arns" {
  value       = ["${aws_lb_target_group.tg.*.arn}"]
  description = "List of the target group ARNs."
}
