## Module: projects/infra-security

Infrastructure security settings:
 - Create admin role for trusted users from GDS proxy account


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_environment | AWS Environment | string | - | yes |
| aws_region | AWS region | string | `eu-west-1` | no |
| role_admin_policy_arns | List of ARNs of policies to attach to the role | list | `<list>` | no |
| role_admin_user_arns | List of ARNs of external users that can assume the role | list | - | yes |
| stackname | Stackname | string | `` | no |

