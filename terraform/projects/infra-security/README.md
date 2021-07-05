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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | = 0.13.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.25.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.25.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gds_role_admin"></a> [gds\_role\_admin](#module\_gds\_role\_admin) | ../../modules/aws/iam/gds_user_role | n/a |
| <a name="module_gds_role_poweruser"></a> [gds\_role\_poweruser](#module\_gds\_role\_poweruser) | ../../modules/aws/iam/gds_user_role | n/a |
| <a name="module_gds_role_user"></a> [gds\_role\_user](#module\_gds\_role\_user) | ../../modules/aws/iam/gds_user_role | n/a |
| <a name="module_role_admin"></a> [role\_admin](#module\_role\_admin) | ../../modules/aws/iam/role_user | n/a |
| <a name="module_role_datascienceuser"></a> [role\_datascienceuser](#module\_role\_datascienceuser) | ../../modules/aws/iam/role_user | n/a |
| <a name="module_role_internal_admin"></a> [role\_internal\_admin](#module\_role\_internal\_admin) | ../../modules/aws/iam/role_user | n/a |
| <a name="module_role_platformhealth_poweruser"></a> [role\_platformhealth\_poweruser](#module\_role\_platformhealth\_poweruser) | ../../modules/aws/iam/role_user | n/a |
| <a name="module_role_poweruser"></a> [role\_poweruser](#module\_role\_poweruser) | ../../modules/aws/iam/role_user | n/a |
| <a name="module_role_step_function"></a> [role\_step\_function](#module\_role\_step\_function) | ../../modules/aws/iam/role_user | n/a |
| <a name="module_role_user"></a> [role\_user](#module\_role\_user) | ../../modules/aws/iam/role_user | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_account_password_policy.tighten_passwords](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_account_password_policy) | resource |
| [aws_iam_policy.allow-iam-key-rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.data-science-access-glue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.data-science-access-sagemaker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.deny-eip-release](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_key_pair.govuk-infra-key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_kms_alias.sops](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.licensify_documentdb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.shared_documentdb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.sops](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.allow-iam-key-rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.data-science-access-glue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.data-science-access-sagemaker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.deny-eip-release](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kms_sops_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_environment"></a> [aws\_environment](#input\_aws\_environment) | AWS Environment | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"eu-west-1"` | no |
| <a name="input_office_ips"></a> [office\_ips](#input\_office\_ips) | An array of CIDR blocks that will be allowed offsite access. | `list` | n/a | yes |
| <a name="input_role_admin_policy_arns"></a> [role\_admin\_policy\_arns](#input\_role\_admin\_policy\_arns) | List of ARNs of policies to attach to the role | `list` | `[]` | no |
| <a name="input_role_admin_user_arns"></a> [role\_admin\_user\_arns](#input\_role\_admin\_user\_arns) | List of ARNs of external users that can assume the role | `list` | `[]` | no |
| <a name="input_role_datascienceuser_policy_arns"></a> [role\_datascienceuser\_policy\_arns](#input\_role\_datascienceuser\_policy\_arns) | List of ARNs of policies to attach to the role | `list` | `[]` | no |
| <a name="input_role_datascienceuser_user_arns"></a> [role\_datascienceuser\_user\_arns](#input\_role\_datascienceuser\_user\_arns) | List of ARNs of external users that can assume the role | `list` | `[]` | no |
| <a name="input_role_internal_admin_policy_arns"></a> [role\_internal\_admin\_policy\_arns](#input\_role\_internal\_admin\_policy\_arns) | List of ARNs of policies to attach to the role | `list` | `[]` | no |
| <a name="input_role_internal_admin_user_arns"></a> [role\_internal\_admin\_user\_arns](#input\_role\_internal\_admin\_user\_arns) | List of ARNs of external users that can assume the role | `list` | `[]` | no |
| <a name="input_role_platformhealth_poweruser_policy_arns"></a> [role\_platformhealth\_poweruser\_policy\_arns](#input\_role\_platformhealth\_poweruser\_policy\_arns) | List of ARNs of policies to attach to the role | `list` | `[]` | no |
| <a name="input_role_platformhealth_poweruser_user_arns"></a> [role\_platformhealth\_poweruser\_user\_arns](#input\_role\_platformhealth\_poweruser\_user\_arns) | List of ARNs of external users that can assume the role | `list` | `[]` | no |
| <a name="input_role_poweruser_policy_arns"></a> [role\_poweruser\_policy\_arns](#input\_role\_poweruser\_policy\_arns) | List of ARNs of policies to attach to the role | `list` | `[]` | no |
| <a name="input_role_poweruser_user_arns"></a> [role\_poweruser\_user\_arns](#input\_role\_poweruser\_user\_arns) | List of ARNs of external users that can assume the role | `list` | `[]` | no |
| <a name="input_role_step_function_role_policy_arns"></a> [role\_step\_function\_role\_policy\_arns](#input\_role\_step\_function\_role\_policy\_arns) | List of ARNs of policies to attach to the role | `list` | `[]` | no |
| <a name="input_role_step_function_role_user_arns"></a> [role\_step\_function\_role\_user\_arns](#input\_role\_step\_function\_role\_user\_arns) | List of ARNs of users to attach to the role | `list` | `[]` | no |
| <a name="input_role_user_policy_arns"></a> [role\_user\_policy\_arns](#input\_role\_user\_policy\_arns) | List of ARNs of policies to attach to the role | `list` | `[]` | no |
| <a name="input_role_user_user_arns"></a> [role\_user\_user\_arns](#input\_role\_user\_user\_arns) | List of ARNs of external users that can assume the role | `list` | `[]` | no |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | The public part of an SSH keypair | `string` | `null` | no |
| <a name="input_stackname"></a> [stackname](#input\_stackname) | Stackname | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_licensify_documentdb_kms_key_arn"></a> [licensify\_documentdb\_kms\_key\_arn](#output\_licensify\_documentdb\_kms\_key\_arn) | The ARN of the Licensify DocumentDB KMS key |
| <a name="output_shared_documentdb_kms_key_arn"></a> [shared\_documentdb\_kms\_key\_arn](#output\_shared\_documentdb\_kms\_key\_arn) | The ARN of the Shared DocumentDB KMS key |
| <a name="output_sops_kms_key_arn"></a> [sops\_kms\_key\_arn](#output\_sops\_kms\_key\_arn) | The ARN of the Sops KMS key |
