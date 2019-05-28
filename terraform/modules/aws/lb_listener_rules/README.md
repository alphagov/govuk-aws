## Modules: aws/lb_listener_rules

This module creates Load Balancer listener rules and target groups for
an existing listener resource.

Limitations:
 - The target group deregistration_delay, health_check_interval and health_check_timeout
values can be configured with variables, but will be the same for all the target groups
 - With Terraform we can't provide a 'count' or list for listener_rule condition blocks,
so at the moment only one condition can be specified per rule
 - At the moment this module only implements Host Header based rules


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| autoscaling_group_name | Name of ASG to associate with the target group. | string | - | yes |
| default_tags | Additional resource tags | map | `<map>` | no |
| listener_arn | ARN of the listener. | string | - | yes |
| name | Prefix of the target group names. The final name is name-rulename. | string | - | yes |
| priority_offset | first priority number assigned to the rules managed by the module. | string | `1` | no |
| rules_host | A list with the values to create Host-header based listener rules and target groups. | list | `<list>` | no |
| rules_host_domain | Host header domain to append to the hosts in rules_host. | string | `*` | no |
| target_group_deregistration_delay | The amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused. | string | `300` | no |
| target_group_health_check_interval | The approximate amount of time, in seconds, between health checks of an individual target. Minimum value 5 seconds, Maximum value 300 seconds. | string | `30` | no |
| target_group_health_check_matcher | The HTTP codes to use when checking for a successful response from a target. | string | `200-399` | no |
| target_group_health_check_path_prefix | The prefix destination for the health check request. | string | `/_healthcheck_` | no |
| target_group_health_check_timeout | The amount of time, in seconds, during which no response means a failed health check. | string | `5` | no |
| target_group_port | The port on which targets receive traffic. | string | `80` | no |
| target_group_protocol | The protocol to use for routing traffic to the targets. | string | `HTTP` | no |
| vpc_id | The ID of the VPC in which the default target groups are created. | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| target_group_arns | List of the target group ARNs. |

