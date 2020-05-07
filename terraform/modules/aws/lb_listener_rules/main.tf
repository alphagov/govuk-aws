/**
* ## Modules: aws/lb_listener_rules
*
* This module creates Load Balancer listener rules based on Host header and target groups for
* an existing listener resource.
*
* If the parameter `autoscaling_group_name` is non empty, the module also creates an attachment
* from each target group to the ASG with the specified name.
*
* Limitations:
*  - The target group deregistration_delay, health_check_interval and health_check_timeout
* values can be configured with variables, but will be the same for all the target groups
*  - With Terraform we can't provide a 'count' or list for listener_rule condition blocks,
* so at the moment only one condition can be specified per rule
*  - At the moment this module only implements Host Header based rules
*/

variable "default_tags" {
  type        = "map"
  description = "Additional resource tags"
  default     = {}
}

variable "listener_arn" {
  type        = "string"
  description = "ARN of the listener."
}

variable "rules_host" {
  type        = "list"
  description = "A list with the values to create Host-header based listener rules and target groups."
  default     = []
}

variable "rules_host_domain" {
  type        = "string"
  description = "Host header domain to append to the hosts in rules_host."
  default     = "*"
}

variable "name" {
  type        = "string"
  description = "Prefix of the target group names. The final name is name-rulename."
}

variable "priority_offset" {
  type        = "string"
  description = "first priority number assigned to the rules managed by the module."
  default     = 1
}

variable "vpc_id" {
  type        = "string"
  description = "The ID of the VPC in which the default target groups are created."
}

variable "autoscaling_group_name" {
  type        = "string"
  description = "Name of ASG to associate with the target group. An empty value does not create any attachment to the LB target group."
  default     = ""
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

variable "target_group_port" {
  type        = "string"
  description = "The port on which targets receive traffic."
  default     = 80
}

variable "target_group_protocol" {
  type        = "string"
  description = "The protocol to use for routing traffic to the targets."
  default     = "HTTP"
}

variable "target_group_health_check_path_prefix" {
  type        = "string"
  description = "The prefix destination for the health check request."
  default     = "/_healthcheck_"
}

variable "target_group_health_check_matcher" {
  type        = "string"
  description = "The HTTP codes to use when checking for a successful response from a target."
  default     = "200-399"
}

variable "rules_for_existing_target_groups" {
  type        = "map"
  description = "create an additional rule for a target group already created via rules_host"
  default     = {}
}

# Resources
#--------------------------------------------------------------

resource "aws_lb_target_group" "tg" {
  count                = "${length(var.rules_host)}"
  name                 = "${replace(format("%.10s-%.21s", var.name, var.rules_host[count.index]), "/-$/", "")}"
  port                 = "${var.target_group_port}"
  protocol             = "${var.target_group_protocol}"
  vpc_id               = "${var.vpc_id}"
  deregistration_delay = "${var.target_group_deregistration_delay}"

  health_check {
    interval            = "${var.target_group_health_check_interval}"
    path                = "${var.target_group_health_check_path_prefix}${var.rules_host[count.index]}"
    matcher             = "${var.target_group_health_check_matcher}"
    port                = "traffic-port"
    protocol            = "${var.target_group_protocol}"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = "${var.target_group_health_check_timeout}"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = "${var.default_tags}"
}

resource "aws_autoscaling_attachment" "tg" {
  count                  = "${var.autoscaling_group_name != "" ? length(var.rules_host) : 0}"
  autoscaling_group_name = "${var.autoscaling_group_name}"
  alb_target_group_arn   = "${aws_lb_target_group.tg.*.arn[count.index]}"
}

resource "aws_lb_listener_rule" "routing" {
  count        = "${length(var.rules_host)}"
  listener_arn = "${var.listener_arn}"
  priority     = "${count.index + var.priority_offset}"

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.tg.*.arn[count.index]}"
  }

  condition {
    field  = "host-header"
    values = ["${var.rules_host[count.index]}.${var.rules_host_domain}"]
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    "aws_lb_target_group.tg",
  ]
}

resource "aws_lb_listener_rule" "existing_target_groups" {
  count        = "${length(keys(var.rules_for_existing_target_groups))}"
  listener_arn = "${var.listener_arn}"
  priority     = "${count.index + var.priority_offset + length(var.rules_host)}"

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.tg.*.arn[index(var.rules_host,var.rules_for_existing_target_groups[element(keys(var.rules_for_existing_target_groups),count.index)])]}"
  }

  condition {
    field  = "host-header"
    values = ["${element(keys(var.rules_for_existing_target_groups),count.index)}.${var.rules_host_domain}"]
  }
}

# Outputs
#--------------------------------------------------------------

output "target_group_arns" {
  value       = ["${aws_lb_target_group.tg.*.arn}"]
  description = "List of the target group ARNs."
}
