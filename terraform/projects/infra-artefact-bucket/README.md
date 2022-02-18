## Project: artefact-bucket

This creates 3 S3 buckets:

artefact: The bucket that will hold the artefacts
artefact\_access\_logs: Bucket for logs to go to
artefact\_replication\_destination: Bucket in another region to replicate to

It creates two IAM roles:
artefact\_writer: used by CI to write new artefacts, and deploy instances
to write to "deployed-to-environment" branches

artefact\_reader: used by instances to fetch artefacts

This module creates the following.
     - AWS SNS topic
     - AWS S3 Bucket event
     - AWS S3 Bucket policy.
     - AWS Lambda function.
     - AWS SNS subscription
     - AWS IAM roles and polisis for SNS and Lambda.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | = 0.11.15 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 2.46.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 2.46.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 2.46.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | ~> 1.3 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 2.46.0 2.46.0 2.46.0 |
| <a name="provider_aws.secondary"></a> [aws.secondary](#provider\_aws.secondary) | 2.46.0 2.46.0 2.46.0 |
| <a name="provider_aws.subscription"></a> [aws.subscription](#provider\_aws.subscription) | 2.46.0 2.46.0 2.46.0 |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.artefact_reader](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.artefact_replication](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.artefact_writer](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.govuk_artefact_policy](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy_attachment.artefact_replication](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_policy_attachment.artefact_writer](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_policy_attachment.govuk_artefact_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_role.artefact_replication](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role) | resource |
| [aws_iam_role.govuk_artefact_lambda_role](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role) | resource |
| [aws_iam_user.artefact_writer](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_user) | resource |
| [aws_lambda_function.artefact_lambda_function](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.govuk_artefact_lambda_sns](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/lambda_permission) | resource |
| [aws_s3_bucket.artefact](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.artefact_replication_destination](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_notification.artefact_bucket_notification](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/s3_bucket_notification) | resource |
| [aws_s3_bucket_policy.govuk-artefact-bucket-policy](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/s3_bucket_policy) | resource |
| [aws_sns_topic.artefact_topic](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/sns_topic) | resource |
| [aws_sns_topic_policy.artefact_topic_policy](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/sns_topic_policy) | resource |
| [aws_sns_topic_subscription.artefact_topic_subscription](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/sns_topic_subscription) | resource |
| [archive_file.artefact_lambda](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.artefact_replication](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.artefact_sns_topic_policy](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.govuk-artefact-bucket](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/iam_policy_document) | data source |
| [template_file.artefact_reader_policy_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.artefact_writer_policy_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.govuk_artefact_policy_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [terraform_remote_state.infra_monitoring](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_artefact_source"></a> [artefact\_source](#input\_artefact\_source) | Identifies the source artefact environment | `string` | n/a | yes |
| <a name="input_aws_environment"></a> [aws\_environment](#input\_aws\_environment) | AWS Environment | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"eu-west-1"` | no |
| <a name="input_aws_s3_access_account"></a> [aws\_s3\_access\_account](#input\_aws\_s3\_access\_account) | Here we define the account that will have access to the Artefact S3 bucket. | `list` | n/a | yes |
| <a name="input_aws_secondary_region"></a> [aws\_secondary\_region](#input\_aws\_secondary\_region) | Secondary region for cross-replication | `string` | `"eu-west-2"` | no |
| <a name="input_aws_subscription_account_id"></a> [aws\_subscription\_account\_id](#input\_aws\_subscription\_account\_id) | The AWS Account ID that will appear on the subscription | `string` | n/a | yes |
| <a name="input_aws_subscription_account_region"></a> [aws\_subscription\_account\_region](#input\_aws\_subscription\_account\_region) | AWS region of the SNS topic | `string` | `"eu-west-1"` | no |
| <a name="input_create_sns_subscription"></a> [create\_sns\_subscription](#input\_create\_sns\_subscription) | Indicates whether to create an SNS subscription | `string` | `false` | no |
| <a name="input_create_sns_topic"></a> [create\_sns\_topic](#input\_create\_sns\_topic) | Indicates whether to create an SNS Topic | `string` | `false` | no |
| <a name="input_remote_state_bucket"></a> [remote\_state\_bucket](#input\_remote\_state\_bucket) | S3 bucket we store our terraform state in | `string` | n/a | yes |
| <a name="input_remote_state_infra_monitoring_key_stack"></a> [remote\_state\_infra\_monitoring\_key\_stack](#input\_remote\_state\_infra\_monitoring\_key\_stack) | Override stackname path to infra\_monitoring remote state | `string` | `""` | no |
| <a name="input_replication_setting"></a> [replication\_setting](#input\_replication\_setting) | Whether replication is Enabled or Disabled | `string` | `"Enabled"` | no |
| <a name="input_stackname"></a> [stackname](#input\_stackname) | Stackname | `string` | n/a | yes |
| <a name="input_whole_bucket_lifecycle_rule_integration_enabled"></a> [whole\_bucket\_lifecycle\_rule\_integration\_enabled](#input\_whole\_bucket\_lifecycle\_rule\_integration\_enabled) | Set to true in Integration data to only apply these rules for Integration | `string` | `"false"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_read_artefact_bucket_policy_arn"></a> [read\_artefact\_bucket\_policy\_arn](#output\_read\_artefact\_bucket\_policy\_arn) | ARN of the read artefact-bucket policy |
| <a name="output_write_artefact_bucket_policy_arn"></a> [write\_artefact\_bucket\_policy\_arn](#output\_write\_artefact\_bucket\_policy\_arn) | ARN of the write artefact-bucket policy |
