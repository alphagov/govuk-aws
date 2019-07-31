## Project: app-custom-formats-mapit-storage

Creates S3 bucket for custom-formats-mapit

Migrated from:
https://github.com/alphagov/govuk-terraform-provisioning/tree/master/projects/custom_formats_mapit_storage

NOTES: currently the policy does not have any attachment


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_environment | AWS Environment | string | - | yes |
| aws_region | AWS region | string | `eu-west-1` | no |
| aws_replica_region | AWS region | string | `eu-west-2` | no |
| bucket_name |  | string | `govuk-custom-formats-mapit-storage` | no |
| stackname | Stackname | string | - | yes |

