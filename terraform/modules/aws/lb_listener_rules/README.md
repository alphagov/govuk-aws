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
| aws | n/a |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_autoscaling_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_attachment) |
| [aws_lb_listener_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) |
| [aws_lb_target_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| autoscaling\_group\_name | Name of ASG to associate with the target group. An empty value does not create any attachment to the LB target group. | `string` | `""` | no |
| default\_tags | Additional resource tags | `map` | `{}` | no |
| listener\_arn | ARN of the listener. | `string` | n/a | yes |
| name | Prefix of the target group names. The final name is name-rulename. | `string` | n/a | yes |
| priority\_offset | first priority number assigned to the rules managed by the module. | `string` | `1` | no |
| rules\_for\_existing\_target\_groups | create an additional rule for a target group already created via rules\_host | `map` | `{}` | no |
| rules\_host | A list with the values to create Host-header based listener rules and target groups. | `list` | `[]` | no |
| rules\_host\_domain | Host header domain to append to the hosts in rules\_host. | `string` | `"*"` | no |
| target\_group\_deregistration\_delay | The amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused. | `string` | `300` | no |
| target\_group\_health\_check\_interval | The approximate amount of time, in seconds, between health checks of an individual target. Minimum value 5 seconds, Maximum value 300 seconds. | `string` | `30` | no |
| target\_group\_health\_check\_matcher | The HTTP codes to use when checking for a successful response from a target. | `string` | `"200-399"` | no |
| target\_group\_health\_check\_path\_prefix | The prefix destination for the health check request. | `string` | `"/_healthcheck_"` | no |
| target\_group\_health\_check\_timeout | The amount of time, in seconds, during which no response means a failed health check. | `string` | `5` | no |
| target\_group\_port | The port on which targets receive traffic. | `string` | `80` | no |
| target\_group\_protocol | The protocol to use for routing traffic to the targets. | `string` | `"HTTP"` | no |
| vpc\_id | The ID of the VPC in which the default target groups are created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| target\_group\_arns | List of the target group ARNs. |
