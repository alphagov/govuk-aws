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
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| office\_ips | An array of CIDR blocks that will be allowed offsite access. | `list` | n/a | yes |
| restrict\_to\_gds\_ips | n/a | `bool` | `false` | no |
| role\_policy\_arns | List of ARNs of policies to attach to the role | `list` | `[]` | no |
| role\_suffix | Suffix of the role name | `string` | n/a | yes |
| role\_user\_arns | List of ARNs of external users that can assume the role | `list` | n/a | yes |

## Outputs

No output.

