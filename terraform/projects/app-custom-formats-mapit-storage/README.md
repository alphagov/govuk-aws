## Project: app-custom-formats-mapit-storage

Creates S3 bucket for custom-formats-mapit

Migrated from:  
https://github.com/alphagov/govuk-terraform-provisioning/tree/master/projects/custom_formats_mapit_storage

NOTES: currently the policy does not have any attachment

## Requirements

| Name | Version |
|------|---------|
| terraform | = 0.11.14 |
| aws | 2.46.0 |
| aws | 2.46.0 |

## Providers

| Name | Version |
|------|---------|
| aws | 2.46.0 2.46.0 |
| aws.aws\_replica | 2.46.0 2.46.0 |
| template | n/a |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy) |
| [aws_iam_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy_attachment) |
| [aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/iam_policy_document) |
| [aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role) |
| [aws_s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/s3_bucket) |
| [template_file](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_environment | AWS Environment | `string` | n/a | yes |
| aws\_region | AWS region | `string` | `"eu-west-1"` | no |
| aws\_replica\_region | AWS region | `string` | `"eu-west-2"` | no |
| bucket\_name | n/a | `string` | `"govuk-custom-formats-mapit-storage"` | no |
| stackname | Stackname | `string` | n/a | yes |

## Outputs

No output.
