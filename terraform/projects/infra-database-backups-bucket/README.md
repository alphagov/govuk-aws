## Project: database-backups-bucket

This creates an s3 bucket

database-backups: The bucket that will hold database backups



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_environment | AWS Environment | string | - | yes |
| aws_region | AWS region | string | `eu-west-1` | no |

## Outputs

| Name | Description |
|------|-------------|
| write_database_backups_bucket_policy_arn | ARN of the write database_backups-bucket policy |

