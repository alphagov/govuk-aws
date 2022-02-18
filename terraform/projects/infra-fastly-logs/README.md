## Project: infra-fastly-logs

Manages the Fastly logging data which is sent from Fastly to S3.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | = 0.11.15 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 2.46.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | ~> 1.3 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 2.46.0 |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_athena_named_query.transition_logs](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/athena_named_query) | resource |
| [aws_cloudwatch_event_rule.transition_executor_daily](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.transition_executor_daily](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/cloudwatch_event_target) | resource |
| [aws_glue_catalog_database.fastly_logs](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/glue_catalog_database) | resource |
| [aws_glue_catalog_table.bouncer](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/glue_catalog_table) | resource |
| [aws_glue_catalog_table.govuk_assets](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/glue_catalog_table) | resource |
| [aws_glue_catalog_table.govuk_www](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/glue_catalog_table) | resource |
| [aws_glue_crawler.bouncer](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/glue_crawler) | resource |
| [aws_glue_crawler.govuk_assets](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/glue_crawler) | resource |
| [aws_glue_crawler.govuk_www](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/glue_crawler) | resource |
| [aws_iam_policy.athena_monitoring](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.logs_writer](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.transition_downloader](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.transition_executor](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy_attachment.athena_monitoring](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_policy_attachment.logs_writer](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_policy_attachment.transition_downloader](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_role.glue](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role) | resource |
| [aws_iam_role.transition_executor](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.fastly_logs_policy](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.aws-glue-service-role-service-attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.transition_executor](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_user.athena_monitoring](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_user) | resource |
| [aws_iam_user.logs_writer](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_user) | resource |
| [aws_iam_user.transition_downloader](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_user) | resource |
| [aws_lambda_function.transition_executor](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.cloudwatch_transition_executor_daily_permission](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/lambda_permission) | resource |
| [aws_s3_bucket.fastly_logs](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.fastly_logs_monitoring](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.transition_fastly_logs](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/s3_bucket) | resource |
| [archive_file.transition_executor](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [template_file.athena_monitoring_policy_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.logs_writer_policy_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.transition_downloader_policy_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.transition_executor_policy_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
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
| <a name="input_remote_state_bucket"></a> [remote\_state\_bucket](#input\_remote\_state\_bucket) | S3 bucket we store our terraform state in | `string` | n/a | yes |
| <a name="input_remote_state_infra_monitoring_key_stack"></a> [remote\_state\_infra\_monitoring\_key\_stack](#input\_remote\_state\_infra\_monitoring\_key\_stack) | Override stackname path to infra\_monitoring remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_networking_key_stack"></a> [remote\_state\_infra\_networking\_key\_stack](#input\_remote\_state\_infra\_networking\_key\_stack) | Override infra\_networking remote state path | `string` | `""` | no |
| <a name="input_remote_state_infra_root_dns_zones_key_stack"></a> [remote\_state\_infra\_root\_dns\_zones\_key\_stack](#input\_remote\_state\_infra\_root\_dns\_zones\_key\_stack) | Override stackname path to infra\_root\_dns\_zones remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_security_groups_key_stack"></a> [remote\_state\_infra\_security\_groups\_key\_stack](#input\_remote\_state\_infra\_security\_groups\_key\_stack) | Override infra\_security\_groups stackname path to infra\_vpc remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_stack_dns_zones_key_stack"></a> [remote\_state\_infra\_stack\_dns\_zones\_key\_stack](#input\_remote\_state\_infra\_stack\_dns\_zones\_key\_stack) | Override stackname path to infra\_stack\_dns\_zones remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_vpc_key_stack"></a> [remote\_state\_infra\_vpc\_key\_stack](#input\_remote\_state\_infra\_vpc\_key\_stack) | Override infra\_vpc remote state path | `string` | `""` | no |
| <a name="input_stackname"></a> [stackname](#input\_stackname) | Stackname | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_logs_writer_bucket_policy_arn"></a> [logs\_writer\_bucket\_policy\_arn](#output\_logs\_writer\_bucket\_policy\_arn) | ARN of the logs writer bucket policy |
