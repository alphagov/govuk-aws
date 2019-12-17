## Project: app-mysql-xtrabackups

Creates S3 bucket for mysql xtrabackups

Migrated from:
https://github.com/alphagov/govuk-terraform-provisioning/tree/master/old-projects/mysql_xtrabackups

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws\_environment | AWS Environment | string | n/a | yes |
| aws\_region | AWS region | string | `"eu-west-1"` | no |
| bucket\_name |  | string | `"govuk-mysql-xtrabackups"` | no |
| create\_env\_sync\_resources | Create users and policies used to sync data between environments. | string | `"false"` | no |
| days\_to\_keep |  | string | `"91"` | no |
| lifecycle |  | string | `"true"` | no |
| stackname | Stackname | string | n/a | yes |
| team |  | string | `"Infrastructure"` | no |
| username |  | string | `"govuk-mysql-xtrabackups"` | no |
| versioning |  | string | `"false"` | no |

