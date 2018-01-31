## Module: projects/infra-security

Infrastructure security settings:
 - Create admin role for trusted users from GDS proxy account
 - Create users role for trusted users from GDS proxy account
 - Default IAM password policy
 - Default SSH key
 - CloudTrail settings and alarms


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_environment | AWS Environment | string | - | yes |
| aws_region | AWS region | string | `eu-west-1` | no |
| role_admin_policy_arns | List of ARNs of policies to attach to the role | list | `<list>` | no |
| role_admin_user_arns | List of ARNs of external users that can assume the role | list | - | yes |
| role_poweruser_policy_arns | List of ARNs of policies to attach to the role | list | `<list>` | no |
| role_poweruser_user_arns | List of ARNs of external users that can assume the role | list | - | yes |
| role_user_policy_arns | List of ARNs of policies to attach to the role | list | `<list>` | no |
| role_user_user_arns | List of ARNs of external users that can assume the role | list | - | yes |
| ssh_public_key | The public part of an SSH keypair | string | - | yes |
| stackname | Stackname | string | `` | no |

