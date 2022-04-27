## Module: govuk-repo-mirror

Configures:
1. an IAM role to allow the `mirror_github_repositories` Jenkins job
   in Integration to mirror the GOV.UK GitHub repositories to AWS CodeCommit in
   Tools
2. an IAM user with SSH authorized keys from Jenkins in Integration, Staging and
   Production to access to AWS CodeCommit in Tools to deploy applications

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | = 0.11.15 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 2.46.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 2.46.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.govuk_codecommit_poweruser](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.govuk_codecommit_poweruser_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_user.govuk_codecommit_user](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_user) | resource |
| [aws_iam_user.govuk_concourse_codecommit_user](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_user) | resource |
| [aws_iam_user_policy_attachment.govuk_codecommit_user_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.govuk_concourse_codecommit_user_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_ssh_key.govuk_codecommit_user_jenkins_production_ssh_key](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_user_ssh_key) | resource |
| [aws_iam_user_ssh_key.govuk_codecommit_user_jenkins_staging_ssh_key](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_user_ssh_key) | resource |
| [aws_iam_user_ssh_key.govuk_concourse_codecommit_production_user_ssh_key](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_user_ssh_key) | resource |
| [aws_iam_user_ssh_key.govuk_concourse_codecommit_staging_user_ssh_key](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_user_ssh_key) | resource |
| [terraform_remote_state.infra_monitoring](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_networking](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_root_dns_zones](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_security_groups](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_stack_dns_zones](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_vpc](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_environment"></a> [aws\_environment](#input\_aws\_environment) | AWS Environment | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"eu-west-1"` | no |
| <a name="input_integration_jenkins_role_arn"></a> [integration\_jenkins\_role\_arn](#input\_integration\_jenkins\_role\_arn) | ARN of the role that Jenkins uses to assume the govuk\_codecommit\_poweruser role | `string` | n/a | yes |
| <a name="input_jenkins_carrenza_production_ssh_public_key"></a> [jenkins\_carrenza\_production\_ssh\_public\_key](#input\_jenkins\_carrenza\_production\_ssh\_public\_key) | The SSH public key of the Jenkins instance in the Carrenza production environment | `string` | n/a | yes |
| <a name="input_jenkins_carrenza_staging_ssh_public_key"></a> [jenkins\_carrenza\_staging\_ssh\_public\_key](#input\_jenkins\_carrenza\_staging\_ssh\_public\_key) | The SSH public key of the Jenkins instance in the Carrenza staging environment | `string` | n/a | yes |
| <a name="input_remote_state_bucket"></a> [remote\_state\_bucket](#input\_remote\_state\_bucket) | S3 bucket we store our terraform state in | `string` | n/a | yes |
| <a name="input_remote_state_infra_monitoring_key_stack"></a> [remote\_state\_infra\_monitoring\_key\_stack](#input\_remote\_state\_infra\_monitoring\_key\_stack) | Override stackname path to infra\_monitoring remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_networking_key_stack"></a> [remote\_state\_infra\_networking\_key\_stack](#input\_remote\_state\_infra\_networking\_key\_stack) | Override infra\_networking remote state path | `string` | `""` | no |
| <a name="input_remote_state_infra_root_dns_zones_key_stack"></a> [remote\_state\_infra\_root\_dns\_zones\_key\_stack](#input\_remote\_state\_infra\_root\_dns\_zones\_key\_stack) | Override stackname path to infra\_root\_dns\_zones remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_security_groups_key_stack"></a> [remote\_state\_infra\_security\_groups\_key\_stack](#input\_remote\_state\_infra\_security\_groups\_key\_stack) | Override infra\_security\_groups stackname path to infra\_vpc remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_stack_dns_zones_key_stack"></a> [remote\_state\_infra\_stack\_dns\_zones\_key\_stack](#input\_remote\_state\_infra\_stack\_dns\_zones\_key\_stack) | Override stackname path to infra\_stack\_dns\_zones remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_vpc_key_stack"></a> [remote\_state\_infra\_vpc\_key\_stack](#input\_remote\_state\_infra\_vpc\_key\_stack) | Override infra\_vpc remote state path | `string` | `""` | no |
| <a name="input_stackname"></a> [stackname](#input\_stackname) | Stackname | `string` | n/a | yes |

## Outputs

No outputs.
