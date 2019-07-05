## Project: app-mysql-xtrabackups

Creates S3 bucket for mysql xtrabackups

Migrated from:
https://github.com/alphagov/govuk-terraform-provisioning/tree/master/old-projects/mysql_xtrabackups


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_environment | AWS Environment | string | - | yes |
| aws_region | AWS region | string | `eu-west-1` | no |
| bucket_name |  | string | `govuk-mysql-xtrabackups` | no |
| create_env_sync_resources | Create users and policies used to sync data between environments. | string | `false` | no |
| days_to_keep |  | string | `91` | no |
| lifecycle |  | string | `true` | no |
| stackname | Stackname | string | - | yes |
| team |  | string | `Infrastructure` | no |
| username |  | string | `govuk-mysql-xtrabackups` | no |
| versioning |  | string | `false` | no |

