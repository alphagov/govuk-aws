## Project: wal-e-warehouse-bucket

This creates an s3 bucket

wal-e-warehouse: The bucket that will hold database backups



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_backup_region | AWS region | string | `eu-west-2` | no |
| aws_environment | AWS Environment | string | - | yes |
| aws_region | AWS region | string | `eu-west-1` | no |
| remote_state_bucket | S3 bucket we store our terraform state in | string | - | yes |
| remote_state_infra_monitoring_key_stack | Override stackname path to infra_monitoring remote state | string | `` | no |
| stackname | Stackname | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| write_wal_e_warehouse_policy_arn | ARN of the write wal_e_warehouse-bucket policy |

