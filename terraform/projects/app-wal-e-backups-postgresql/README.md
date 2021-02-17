## Project: app-wal-e-backups-postgresql

Creates S3 bucket for postgresql wal-e-backups

Migrated from:  
https://github.com/alphagov/govuk-terraform-provisioning/tree/master/old-projects/wal-e_backups_postgresql

## Requirements

| Name | Version |
|------|---------|
| terraform | = 0.11.14 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) |
| [aws_iam_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) |
| [aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) |
| [aws_iam_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) |
| [aws_s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_environment | AWS Environment | `string` | n/a | yes |
| aws\_region | AWS region | `string` | `"eu-west-1"` | no |
| bucket\_name | n/a | `string` | `"govuk-wal-e-backups-postgresql"` | no |
| days\_to\_keep | n/a | `string` | `91` | no |
| lifecycle | n/a | `string` | `"false"` | no |
| lifecycle\_with\_transition | n/a | `string` | `false` | no |
| stackname | Stackname | `string` | n/a | yes |
| team | n/a | `string` | `"Infrastructure"` | no |
| username | n/a | `string` | `"govuk-wal-e-backups-postgresql"` | no |
| versioning | n/a | `string` | `"false"` | no |

## Outputs

No output.
