## Module: aws/iam/gds\_user\_role

This module creates a set of IAM roles based on a list of user ARNs.
Each newly-created IAM role is then associated with a set of of IAM policies.
These new IAM role and policy associations form a category of users with the
same privileges.

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
| [aws_iam_role.gds_user_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.gds_user_role_policy_attachments](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_office_ips"></a> [office\_ips](#input\_office\_ips) | DEPRECATED: list of trusted CIDR netblocks | `list(string)` | `[]` | no |
| <a name="input_restrict_to_gds_ips"></a> [restrict\_to\_gds\_ips](#input\_restrict\_to\_gds\_ips) | n/a | `bool` | `false` | no |
| <a name="input_role_policy_arns"></a> [role\_policy\_arns](#input\_role\_policy\_arns) | List of ARNs of policies to attach to the role | `list` | `[]` | no |
| <a name="input_role_suffix"></a> [role\_suffix](#input\_role\_suffix) | Suffix of the role name | `string` | n/a | yes |
| <a name="input_role_user_arns"></a> [role\_user\_arns](#input\_role\_user\_arns) | List of ARNs of external users that can assume the role | `list` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_roles_and_arns"></a> [roles\_and\_arns](#output\_roles\_and\_arns) | Map of '$username-$role' to role ARN. e.g. {'joe.bloggs-admin': 'arn:aws:iam::123467890123:role/joe.bloggs-admin'} |
