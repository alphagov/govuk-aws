## Project: app-govuk-attachments

Creates S3 bucket for asset master attachments storage

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | = 0.11.15 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.readwrite_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy_attachment.iam_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_user.iam_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_s3_bucket.bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.bucket_without_lifecycle](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_iam_policy_document.readwrite_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_policy_attachment_roles"></a> [additional\_policy\_attachment\_roles](#input\_additional\_policy\_attachment\_roles) | Additional roles to attach to the readwrite policy, for legacy compatibility. | `list` | `[]` | no |
| <a name="input_aws_environment"></a> [aws\_environment](#input\_aws\_environment) | AWS Environment | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"eu-west-1"` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | n/a | `string` | `"govuk-attachments"` | no |
| <a name="input_days_to_keep"></a> [days\_to\_keep](#input\_days\_to\_keep) | n/a | `string` | `30` | no |
| <a name="input_lifecycle"></a> [lifecycle](#input\_lifecycle) | n/a | `string` | `false` | no |
| <a name="input_stackname"></a> [stackname](#input\_stackname) | Stackname | `string` | n/a | yes |
| <a name="input_team"></a> [team](#input\_team) | n/a | `string` | `"Infrastructure"` | no |
| <a name="input_username"></a> [username](#input\_username) | n/a | `string` | `"govuk-attachments"` | no |
| <a name="input_versioning"></a> [versioning](#input\_versioning) | n/a | `string` | `"true"` | no |

## Outputs

No outputs.
