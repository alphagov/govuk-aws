## Project: app-developer-docs

Creates S3 bucket for govuk-developer-docs

Migrated from:
https://github.com/alphagov/govuk-terraform-provisioning/tree/master/projects/developer_docs



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_environment | AWS Environment | string | - | yes |
| aws_region | AWS region | string | `eu-west-1` | no |
| aws_replica_region | AWS region | string | `eu-west-2` | no |
| bucket_name |  | string | `govuk-developer-documentation` | no |
| stackname | Stackname | string | - | yes |

