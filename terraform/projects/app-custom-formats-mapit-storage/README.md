## Project: app-custom-formats-mapit-storage

Creates S3 bucket for custom-formats-mapit

Migrated from:
https://github.com/alphagov/govuk-terraform-provisioning/tree/master/projects/custom_formats_mapit_storage

NOTES: currently the policy does not have any attachment

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | = 0.11.15 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 2.46.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 2.46.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 2.46.0 2.46.0 |
| <a name="provider_aws.aws_replica"></a> [aws.aws\_replica](#provider\_aws.aws\_replica) | 2.46.0 2.46.0 |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.developer_readwrite](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.govuk_custom_formats_mapit_storage_replication_policy](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy_attachment.govuk_custom_formats_mapit_storage_replication_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_policy_attachment.publishing_api_event_log_developer_readwrite_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_role.govuk_custom_formats_mapit_storage_replication_role](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role) | resource |
| [aws_s3_bucket.custom_formats_mapit](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.custom_formats_mapit_replica](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/s3_bucket) | resource |
| [aws_iam_policy_document.developer_readwrite](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/iam_policy_document) | data source |
| [template_file.s3_govuk_custom_formats_mapit_storage_replication_policy_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.s3_govuk_custom_formats_mapit_storage_replication_role_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_environment"></a> [aws\_environment](#input\_aws\_environment) | AWS Environment | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"eu-west-1"` | no |
| <a name="input_aws_replica_region"></a> [aws\_replica\_region](#input\_aws\_replica\_region) | AWS region | `string` | `"eu-west-2"` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | n/a | `string` | `"govuk-custom-formats-mapit-storage"` | no |
| <a name="input_stackname"></a> [stackname](#input\_stackname) | Stackname | `string` | n/a | yes |

## Outputs

No outputs.
