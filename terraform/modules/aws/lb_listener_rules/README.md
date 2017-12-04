## Modules: aws/lb_listener_rules

This module creates Load Balancer listener rules and target groups for
an existing listener resource.

You can specify rules based on host header with the `rules_host` variable,
path pattern with the `rules_path` variable, or both with the `rules_host_and_path`
variable. Rules from the three variables are merged and prioritised in the order
`rules_host_and_path`, `rules_host` and `rules_path`.

The three variables are map types. The values of the maps define the target group
port and protocol where requests are routed when they meet the rule condition, with
the format TARGET_GROUP_PROTOCOL:TARGET_GROUP_PORT.

The keys of `rules_host` are evaluated against the Host header of the request. The
keys of `rules_path` are evaluated against the path of the request. If the
`rules_host_and_path` variable is provided, the key has the format FIELD:VALUE.
FIELD must be one of 'path-pattern' for path based routing or 'host-header' for host
based routing.

```
rules_host {
  "www.example1.com" = "HTTP:8080"
  "www.example2.com" = "HTTPS:9091"
  "www.example3.*"   = "HTTP:8080"
}

rules_host_and_path {
 "host-header:www.example1.com" = "HTTP:8080"
 "host-header:www.example2.com" = "HTTPS:9091"
 "path-pattern:/example3"       = "HTTPS:9091"
}
```

Limitations:
 - The target group deregistration_delay, health_check_interval and health_check_timeout
values can be configured with variables, but will be the same for all the target groups
 - With Terraform we can't provide a 'count' or list for listener_rule condition blocks,
so at the moment only one condition can be specified per rule


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| listener_arn | ARN of the listener. | string | - | yes |
| name | Prefix of the target group names. The final name is name-PROTOCOL-PORT. | string | - | yes |
| rules_host | A map with the value of a host-header rule condition and the target group associated. | map | `<map>` | no |
| rules_host_and_path | A map with the value of a rule with the format FIELD:VALUE and the target group associated. FIELD can be one of 'host-header' or 'path-pattern' | map | `<map>` | no |
| rules_path | A map with the value of a path-pattern rule condition and the target group associated | map | `<map>` | no |
| target_group_deregistration_delay | The amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused. | string | `300` | no |
| target_group_health_check_interval | The approximate amount of time, in seconds, between health checks of an individual target. Minimum value 5 seconds, Maximum value 300 seconds. | string | `30` | no |
| target_group_health_check_timeout | The amount of time, in seconds, during which no response means a failed health check. | string | `5` | no |
| vpc_id | The ID of the VPC in which the default target groups are created. | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| target_group_arns | List of the target group ARNs. |

