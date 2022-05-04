## Module: govuk-repo-mirror

Configures:
1. an IAM role to allow the `mirror_github_repositories` Jenkins job
   in Production to mirror the GOV.UK GitHub repositories to AWS CodeCommit in
   Tools
2. an IAM user with SSH authorized keys from Jenkins in Integration, Staging and
   Production to access to AWS CodeCommit in Tools to deploy applications

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.govuk_codecommit_user_gitpush_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.govuk_codecommit_poweruser](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.govuk_codecommit_poweruser_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_user.govuk_codecommit_mirrorer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user.govuk_codecommit_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy_attachment.govuk_codecommit_mirrorer_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.govuk_codecommit_user_readonly_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.govuk_codecommit_user_tag_resources_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_ssh_key.govuk_codecommit_mirrorer_ssh_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_ssh_key) | resource |
| [aws_iam_user_ssh_key.govuk_codecommit_user_jenkins_ssh_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_ssh_key) | resource |
| [aws_iam_policy_document.allow_codecommit_gitpush_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_environment"></a> [aws\_environment](#input\_aws\_environment) | AWS Environment | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"eu-west-1"` | no |
| <a name="input_govuk_codecommit_mirrorer_ssh_key"></a> [govuk\_codecommit\_mirrorer\_ssh\_key](#input\_govuk\_codecommit\_mirrorer\_ssh\_key) | SSH key of the IAM user used by the GOV.UK repo mirroring script to access Tools AWS CodeCommit | `string` | n/a | yes |
| <a name="input_govuk_environments_ssh_key"></a> [govuk\_environments\_ssh\_key](#input\_govuk\_environments\_ssh\_key) | Map of govuk-environment:ssh\_key used to define a GOV.UK environment Jenkins access to AWS CodeCommit | `list(object({ environment = string, ssh_key = string }))` | n/a | yes |
| <a name="input_mirrorer_jenkins_role_arn"></a> [mirrorer\_jenkins\_role\_arn](#input\_mirrorer\_jenkins\_role\_arn) | ARN of the role that Mirrorer Jenkins uses to assume the govuk\_codecommit\_poweruser role | `string` | n/a | yes |
| <a name="input_stackname"></a> [stackname](#input\_stackname) | Stackname | `string` | n/a | yes |

## Outputs

No outputs.
