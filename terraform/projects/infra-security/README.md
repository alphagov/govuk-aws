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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.25 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.25 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gds_role_admin"></a> [gds\_role\_admin](#module\_gds\_role\_admin) | ../../modules/aws/iam/gds_user_role | n/a |
| <a name="module_gds_role_poweruser"></a> [gds\_role\_poweruser](#module\_gds\_role\_poweruser) | ../../modules/aws/iam/gds_user_role | n/a |
| <a name="module_gds_role_user"></a> [gds\_role\_user](#module\_gds\_role\_user) | ../../modules/aws/iam/gds_user_role | n/a |
| <a name="module_role_dataengineeruser"></a> [role\_dataengineeruser](#module\_role\_dataengineeruser) | ../../modules/aws/iam/role_user | n/a |
| <a name="module_role_datascienceuser"></a> [role\_datascienceuser](#module\_role\_datascienceuser) | ../../modules/aws/iam/role_user | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_account_password_policy.tighten_passwords](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_account_password_policy) | resource |
| [aws_iam_policy.allow-iam-key-rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.data-science-access-glue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.data-science-access-sagemaker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.deny-eip-release](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.event_bridge](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.google-s3-mirror](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.pass_step_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.shield-response-team-access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.event_bridge](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.google-s3-mirror](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.role_step_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.shield-response-team-access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.event_bridge](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.google-s3-mirror-access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.role_step_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.shield-response-team-access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
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
| [aws_iam_policy_document.google_s3_mirror](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kms_docdb_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kms_sops_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.pass_step_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.shield-response-team-access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_environment"></a> [aws\_environment](#input\_aws\_environment) | AWS Environment | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"eu-west-1"` | no |
| <a name="input_role_admin_policy_arns"></a> [role\_admin\_policy\_arns](#input\_role\_admin\_policy\_arns) | List of ARNs of policies to attach to the role | `list(any)` | `[]` | no |
| <a name="input_role_admin_user_arns"></a> [role\_admin\_user\_arns](#input\_role\_admin\_user\_arns) | List of ARNs of external users that can assume the role | `list(any)` | `[]` | no |
| <a name="input_role_dataengineeruser_policy_arns"></a> [role\_dataengineeruser\_policy\_arns](#input\_role\_dataengineeruser\_policy\_arns) | List of ARNs of policies to attach to the role | `list(any)` | `[]` | no |
| <a name="input_role_dataengineeruser_user_arns"></a> [role\_dataengineeruser\_user\_arns](#input\_role\_dataengineeruser\_user\_arns) | List of ARNs of external users that can assume the role | `list(any)` | `[]` | no |
| <a name="input_role_datascienceuser_policy_arns"></a> [role\_datascienceuser\_policy\_arns](#input\_role\_datascienceuser\_policy\_arns) | List of ARNs of policies to attach to the role | `list(any)` | `[]` | no |
| <a name="input_role_datascienceuser_user_arns"></a> [role\_datascienceuser\_user\_arns](#input\_role\_datascienceuser\_user\_arns) | List of ARNs of external users that can assume the role | `list(any)` | `[]` | no |
| <a name="input_role_poweruser_policy_arns"></a> [role\_poweruser\_policy\_arns](#input\_role\_poweruser\_policy\_arns) | List of ARNs of policies to attach to the role | `list(any)` | `[]` | no |
| <a name="input_role_step_function_role_policy_arns"></a> [role\_step\_function\_role\_policy\_arns](#input\_role\_step\_function\_role\_policy\_arns) | List of ARNs of policies to attach to the role | `list(any)` | `[]` | no |
| <a name="input_role_user_policy_arns"></a> [role\_user\_policy\_arns](#input\_role\_user\_policy\_arns) | List of ARNs of policies to attach to the role | `list(any)` | `[]` | no |
| <a name="input_role_user_user_arns"></a> [role\_user\_user\_arns](#input\_role\_user\_user\_arns) | List of ARNs of external users that can assume the role | `list(any)` | `[]` | no |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | The public part of an SSH keypair | `string` | `null` | no |
| <a name="input_stackname"></a> [stackname](#input\_stackname) | Stackname | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_admin_roles_and_arns"></a> [admin\_roles\_and\_arns](#output\_admin\_roles\_and\_arns) | Map of '$username-admin' to role ARN, for the *-admin roles. e.g. {'joe.bloggs-admin': 'arn:aws:iam::123467890123:role/joe.bloggs-admin'} |
| <a name="output_licensify_documentdb_kms_key_arn"></a> [licensify\_documentdb\_kms\_key\_arn](#output\_licensify\_documentdb\_kms\_key\_arn) | The ARN of the Licensify DocumentDB KMS key |
| <a name="output_poweruser_roles_and_arns"></a> [poweruser\_roles\_and\_arns](#output\_poweruser\_roles\_and\_arns) | Map of '$username-poweruser' to role ARN, for the *-poweruser roles. e.g. {'joe.bloggs-poweruser': 'arn:aws:iam::123467890123:role/joe.bloggs-poweruser'} |
| <a name="output_shared_documentdb_kms_key_arn"></a> [shared\_documentdb\_kms\_key\_arn](#output\_shared\_documentdb\_kms\_key\_arn) | The ARN of the Shared DocumentDB KMS key |
| <a name="output_sops_kms_key_arn"></a> [sops\_kms\_key\_arn](#output\_sops\_kms\_key\_arn) | The ARN of the Sops KMS key |
| <a name="output_user_roles_and_arns"></a> [user\_roles\_and\_arns](#output\_user\_roles\_and\_arns) | Map of '$username-user' to role ARN, for the *-user roles. e.g. {'joe.bloggs-user': 'arn:aws:iam::123467890123:role/joe.bloggs-user'} |
