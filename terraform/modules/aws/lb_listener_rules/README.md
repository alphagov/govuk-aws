## Modules: aws/lb\_listener\_rules

This module creates Load Balancer listener rules based on Host header and target groups for
an existing listener resource.

If the parameter `autoscaling_group_name` is non empty, the module also creates an attachment
from each target group to the ASG with the specified name.

Limitations:
 - The target group deregistration\_delay, health\_check\_interval and health\_check\_timeout
values can be configured with variables, but will be the same for all the target groups
 - With Terraform we can't provide a 'count' or list for listener\_rule condition blocks,
so at the moment only one condition can be specified per rule
 - At the moment this module only implements Host Header based rules

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_attachment.tg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_attachment) | resource |
| [aws_lb_listener_rule.existing_target_groups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_listener_rule.routing](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_target_group.tg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_autoscaling_group_name"></a> [autoscaling\_group\_name](#input\_autoscaling\_group\_name) | Name of ASG to associate with the target group. An empty value does not create any attachment to the LB target group. | `string` | `""` | no |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | Additional resource tags | `map` | `{}` | no |
| <a name="input_listener_arn"></a> [listener\_arn](#input\_listener\_arn) | ARN of the listener. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Prefix of the target group names. The final name is name-rulename. | `string` | n/a | yes |
| <a name="input_priority_offset"></a> [priority\_offset](#input\_priority\_offset) | first priority number assigned to the rules managed by the module. | `string` | `1` | no |
| <a name="input_rules_for_existing_target_groups"></a> [rules\_for\_existing\_target\_groups](#input\_rules\_for\_existing\_target\_groups) | create an additional rule for a target group already created via rules\_host | `map` | `{}` | no |
| <a name="input_rules_host"></a> [rules\_host](#input\_rules\_host) | A list with the values to create Host-header based listener rules and target groups. | `list` | `[]` | no |
| <a name="input_rules_host_domain"></a> [rules\_host\_domain](#input\_rules\_host\_domain) | Host header domain to append to the hosts in rules\_host. | `string` | `"*"` | no |
| <a name="input_target_group_deregistration_delay"></a> [target\_group\_deregistration\_delay](#input\_target\_group\_deregistration\_delay) | The amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused. | `string` | `300` | no |
| <a name="input_target_group_health_check_interval"></a> [target\_group\_health\_check\_interval](#input\_target\_group\_health\_check\_interval) | The approximate amount of time, in seconds, between health checks of an individual target. Minimum value 5 seconds, Maximum value 300 seconds. | `string` | `30` | no |
| <a name="input_target_group_health_check_matcher"></a> [target\_group\_health\_check\_matcher](#input\_target\_group\_health\_check\_matcher) | The HTTP codes to use when checking for a successful response from a target. | `string` | `"200-399"` | no |
| <a name="input_target_group_health_check_path_prefix"></a> [target\_group\_health\_check\_path\_prefix](#input\_target\_group\_health\_check\_path\_prefix) | The prefix destination for the health check request. | `string` | `"/_healthcheck_"` | no |
| <a name="input_target_group_health_check_timeout"></a> [target\_group\_health\_check\_timeout](#input\_target\_group\_health\_check\_timeout) | The amount of time, in seconds, during which no response means a failed health check. | `string` | `5` | no |
| <a name="input_target_group_port"></a> [target\_group\_port](#input\_target\_group\_port) | The port on which targets receive traffic. | `string` | `80` | no |
| <a name="input_target_group_protocol"></a> [target\_group\_protocol](#input\_target\_group\_protocol) | The protocol to use for routing traffic to the targets. | `string` | `"HTTP"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC in which the default target groups are created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_target_group_arns"></a> [target\_group\_arns](#output\_target\_group\_arns) | List of the target group ARNs. |
