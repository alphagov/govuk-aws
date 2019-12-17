## Module: aws/iam/role_user

This module creates a role with a trust relationship with IAM users from
a trusted account. We need to specify the list of trusted users and
policies to attach to the role.

For instance, the following parameters allow the users 'user1' and 'user2'
from the account ID 123456789000 to use the AWS Security Token Service
AssumeRole API action to gain AdministratorAccess permissions on our account:

```
"role_name" = "myadmins"

"role_policy_arns" = [
  "arn:aws:iam::aws:policy/AdministratorAccess"
]

"role_user_arns" = [
  "arn:aws:iam::123456789000:user/user1",
  "arn:aws:iam::123456789000:user/user2",
]
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| role\_name | The name of the Role | string | n/a | yes |
| role\_policy\_arns | List of ARNs of policies to attach to the role | list | `<list>` | no |
| role\_user\_arns | List of ARNs of external users that can assume the role | list | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| role\_arn | The ARN specifying the role. |

