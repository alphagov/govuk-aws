## Project: app-wal-e-backups-postgresql

Creates S3 bucket for postgresql wal-e-backups

Migrated from:
https://github.com/alphagov/govuk-terraform-provisioning/tree/master/old-projects/wal-e_backups_postgresql


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_environment | AWS Environment | string | - | yes |
| aws_region | AWS region | string | `eu-west-1` | no |
| bucket_name |  | string | `govuk-wal-e-backups-postgresql` | no |
| days_to_keep |  | string | `91` | no |
| lifecycle |  | string | `false` | no |
| lifecycle_with_transition |  | string | `false` | no |
| stackname | Stackname | string | - | yes |
| team |  | string | `Infrastructure` | no |
| username |  | string | `govuk-wal-e-backups-postgresql` | no |
| versioning |  | string | `false` | no |

