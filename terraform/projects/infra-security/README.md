## Module: projects/infra-security

Infrastructure security settings:
 - Create admin role for trusted users from GDS proxy account
 - Create users role for trusted users from GDS proxy account
 - Default IAM password policy
 - Default SSH key
 - SOPS KMS key

## Requirements

| Name | Version |
|------|---------|
| terraform | = 0.13.6 |
| aws | ~> 3.25.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 3.25.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| gds_role_admin | ../../modules/aws/iam/gds_user_role |  |
| gds_role_poweruser | ../../modules/aws/iam/gds_user_role |  |
| gds_role_user | ../../modules/aws/iam/gds_user_role |  |
| role_admin | ../../modules/aws/iam/role_user |  |
| role_datascienceuser | ../../modules/aws/iam/role_user |  |
| role_internal_admin | ../../modules/aws/iam/role_user |  |
| role_platformhealth_poweruser | ../../modules/aws/iam/role_user |  |
| role_poweruser | ../../modules/aws/iam/role_user |  |
| role_user | ../../modules/aws/iam/role_user |  |

## Resources

| Name |
|------|
| [aws_caller_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) |
| [aws_iam_account_password_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_account_password_policy) |
| [aws_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) |
| [aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) |
| [aws_key_pair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) |
| [aws_kms_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) |
| [aws_kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_environment | AWS Environment | `string` | n/a | yes |
| aws\_region | AWS region | `string` | `"eu-west-1"` | no |
| office\_ips | An array of CIDR blocks that will be allowed offsite access. | `list` | n/a | yes |
| role\_admin\_policy\_arns | List of ARNs of policies to attach to the role | `list` | `[]` | no |
| role\_admin\_user\_arns | List of ARNs of external users that can assume the role | `list` | `[]` | no |
| role\_datascienceuser\_policy\_arns | List of ARNs of policies to attach to the role | `list` | `[]` | no |
| role\_datascienceuser\_user\_arns | List of ARNs of external users that can assume the role | `list` | `[]` | no |
| role\_internal\_admin\_policy\_arns | List of ARNs of policies to attach to the role | `list` | `[]` | no |
| role\_internal\_admin\_user\_arns | List of ARNs of external users that can assume the role | `list` | `[]` | no |
| role\_platformhealth\_poweruser\_policy\_arns | List of ARNs of policies to attach to the role | `list` | `[]` | no |
| role\_platformhealth\_poweruser\_user\_arns | List of ARNs of external users that can assume the role | `list` | `[]` | no |
| role\_poweruser\_policy\_arns | List of ARNs of policies to attach to the role | `list` | `[]` | no |
| role\_poweruser\_user\_arns | List of ARNs of external users that can assume the role | `list` | `[]` | no |
| role\_user\_policy\_arns | List of ARNs of policies to attach to the role | `list` | `[]` | no |
| role\_user\_user\_arns | List of ARNs of external users that can assume the role | `list` | `[]` | no |
| ssh\_public\_key | The public part of an SSH keypair | `string` | n/a | yes |
| stackname | Stackname | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| licensify\_documentdb\_kms\_key\_arn | The ARN of the Licensify DocumentDB KMS key |
| shared\_documentdb\_kms\_key\_arn | The ARN of the Shared DocumentDB KMS key |
| sops\_kms\_key\_arn | The ARN of the Sops KMS key |
