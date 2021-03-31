## Project: infra-content-publisher

Stores ActiveStorage blobs uploaded via Content Publisher.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | = 0.11.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 2.46.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 2.46.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 2.46.0 2.46.0 |
| <a name="provider_aws.aws_replica"></a> [aws.aws\_replica](#provider\_aws.aws\_replica) | 2.46.0 2.46.0 |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.govuk_content_publisher_activestorage_replication_policy](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.integration_content_publisher_active_storage_reader_writer](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.production_content_publisher_active_storage_reader](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.s3_writer](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.staging_content_publisher_active_storage_reader](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.staging_content_publisher_active_storage_reader_writer](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy_attachment.govuk_content_publisher_activestorage_replication_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_policy_attachment.s3_writer](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_role.govuk_content_publisher_activestorage_replication_role](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role) | resource |
| [aws_iam_user.app_user](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_user) | resource |
| [aws_s3_bucket.activestorage](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.activestorage_replica](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.integration_cross_account_access_to_staging](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_policy.staging_cross_account_access_to_production](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_policy.test_cross_account_access_to_integration](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/s3_bucket_policy) | resource |
| [aws_iam_policy_document.integration_content_publisher_active_storage_reader_writer](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.integration_cross_account_access_to_staging](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.production_content_publisher_active_storage_reader](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.staging_content_publisher_active_storage_reader](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.staging_content_publisher_active_storage_reader_writer](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.staging_cross_account_access_to_production](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.test_cross_account_access_to_integration](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/iam_policy_document) | data source |
| [template_file.s3_govuk_content_publisher_activestorage_policy_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.s3_govuk_content_publisher_activestorage_replication_role_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.s3_writer_policy](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
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
| <a name="input_aws_integration_account_root_arn"></a> [aws\_integration\_account\_root\_arn](#input\_aws\_integration\_account\_root\_arn) | root arn of the aws integration account of govuk | `string` | `""` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"eu-west-1"` | no |
| <a name="input_aws_replica_region"></a> [aws\_replica\_region](#input\_aws\_replica\_region) | AWS region | `string` | `"eu-west-2"` | no |
| <a name="input_aws_staging_account_root_arn"></a> [aws\_staging\_account\_root\_arn](#input\_aws\_staging\_account\_root\_arn) | root arn of the aws staging account of govuk | `string` | `""` | no |
| <a name="input_aws_test_account_root_arn"></a> [aws\_test\_account\_root\_arn](#input\_aws\_test\_account\_root\_arn) | root arn of the aws test account of govuk | `string` | `""` | no |
| <a name="input_remote_state_bucket"></a> [remote\_state\_bucket](#input\_remote\_state\_bucket) | S3 bucket we store our terraform state in | `string` | n/a | yes |
| <a name="input_remote_state_infra_monitoring_key_stack"></a> [remote\_state\_infra\_monitoring\_key\_stack](#input\_remote\_state\_infra\_monitoring\_key\_stack) | Override stackname path to infra\_monitoring remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_networking_key_stack"></a> [remote\_state\_infra\_networking\_key\_stack](#input\_remote\_state\_infra\_networking\_key\_stack) | Override infra\_networking remote state path | `string` | `""` | no |
| <a name="input_remote_state_infra_root_dns_zones_key_stack"></a> [remote\_state\_infra\_root\_dns\_zones\_key\_stack](#input\_remote\_state\_infra\_root\_dns\_zones\_key\_stack) | Override stackname path to infra\_root\_dns\_zones remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_security_groups_key_stack"></a> [remote\_state\_infra\_security\_groups\_key\_stack](#input\_remote\_state\_infra\_security\_groups\_key\_stack) | Override infra\_security\_groups stackname path to infra\_vpc remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_stack_dns_zones_key_stack"></a> [remote\_state\_infra\_stack\_dns\_zones\_key\_stack](#input\_remote\_state\_infra\_stack\_dns\_zones\_key\_stack) | Override stackname path to infra\_stack\_dns\_zones remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_vpc_key_stack"></a> [remote\_state\_infra\_vpc\_key\_stack](#input\_remote\_state\_infra\_vpc\_key\_stack) | Override infra\_vpc remote state path | `string` | `""` | no |
| <a name="input_replication_setting"></a> [replication\_setting](#input\_replication\_setting) | Whether replication is Enabled or Disabled | `string` | `"Enabled"` | no |
| <a name="input_stackname"></a> [stackname](#input\_stackname) | Stackname | `string` | n/a | yes |
| <a name="input_whole_bucket_lifecycle_rule_integration_enabled"></a> [whole\_bucket\_lifecycle\_rule\_integration\_enabled](#input\_whole\_bucket\_lifecycle\_rule\_integration\_enabled) | Set to true in Integration data to only apply these rules for Integration | `string` | `"false"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_integration_content_publisher_active_storage_bucket_reader_writer_policy_arn"></a> [integration\_content\_publisher\_active\_storage\_bucket\_reader\_writer\_policy\_arn](#output\_integration\_content\_publisher\_active\_storage\_bucket\_reader\_writer\_policy\_arn) | ARN of the staging content publisher storage bucket reader writer policy |
| <a name="output_production_content_publisher_active_storage_bucket_reader_policy_arn"></a> [production\_content\_publisher\_active\_storage\_bucket\_reader\_policy\_arn](#output\_production\_content\_publisher\_active\_storage\_bucket\_reader\_policy\_arn) | ARN of the production content publisher storage bucket reader policy |
| <a name="output_staging_content_publisher_active_storage_bucket_reader_policy_arn"></a> [staging\_content\_publisher\_active\_storage\_bucket\_reader\_policy\_arn](#output\_staging\_content\_publisher\_active\_storage\_bucket\_reader\_policy\_arn) | ARN of the staging content publisher storage bucket reader policy |
| <a name="output_staging_content_publisher_active_storage_bucket_reader_writer_policy_arn"></a> [staging\_content\_publisher\_active\_storage\_bucket\_reader\_writer\_policy\_arn](#output\_staging\_content\_publisher\_active\_storage\_bucket\_reader\_writer\_policy\_arn) | ARN of the staging content publisher storage bucket reader writer policy |
