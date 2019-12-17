## Project: app-wal-e-backups-postgresql

Creates S3 bucket for postgresql wal-e-backups

Migrated from:
https://github.com/alphagov/govuk-terraform-provisioning/tree/master/old-projects/wal-e_backups_postgresql

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws\_environment | AWS Environment | string | n/a | yes |
| aws\_region | AWS region | string | `"eu-west-1"` | no |
| bucket\_name |  | string | `"govuk-wal-e-backups-postgresql"` | no |
| days\_to\_keep |  | string | `"91"` | no |
| lifecycle |  | string | `"false"` | no |
| lifecycle\_with\_transition |  | string | `"false"` | no |
| stackname | Stackname | string | n/a | yes |
| team |  | string | `"Infrastructure"` | no |
| username |  | string | `"govuk-wal-e-backups-postgresql"` | no |
| versioning |  | string | `"false"` | no |

