## Project: database-backups-bucket

This creates an s3 bucket

database-backups: The bucket that will hold database backups



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_backup_region | AWS region | string | `eu-west-2` | no |
| aws_environment | AWS Environment | string | - | yes |
| aws_region | AWS region | string | `eu-west-1` | no |
| backup_source_bucket | This variable is used to pass the backup bucket that is used to get the data (from production). | string | `` | no |
| remote_state_bucket | S3 bucket we store our terraform state in | string | - | yes |
| remote_state_infra_monitoring_key_stack | Override stackname path to infra_monitoring remote state | string | `` | no |
| stackname | Stackname | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| dbadmin_read_database_backups_bucket_policy_arn | ARN of the read DBAdmin database_backups-bucket policy |
| dbadmin_write_database_backups_bucket_policy_arn | ARN of the DBAdmin write database_backups-bucket policy |
| elasticsearch_read_database_backups_bucket_policy_arn | ARN of the read elasticsearch database_backups-bucket policy |
| elasticsearch_write_database_backups_bucket_policy_arn | ARN of the elasticsearch write database_backups-bucket policy |
| graphite_read_database_backups_bucket_policy_arn | ARN of the read Graphite database_backups-bucket policy |
| graphite_write_database_backups_bucket_policy_arn | ARN of the Graphite write database_backups-bucket policy |
| mongo_api_read_database_backups_bucket_policy_arn | ARN of the read mongo-api database_backups-bucket policy |
| mongo_api_write_database_backups_bucket_policy_arn | ARN of the mongo-api write database_backups-bucket policy |
| mongo_router_read_database_backups_bucket_policy_arn | ARN of the read router_backend database_backups-bucket policy |
| mongo_router_write_database_backups_bucket_policy_arn | ARN of the router_backend write database_backups-bucket policy |
| mongodb_read_database_backups_bucket_policy_arn | ARN of the read mongodb database_backups-bucket policy |
| mongodb_write_database_backups_bucket_policy_arn | ARN of the mongodb write database_backups-bucket policy |
| transition_dbadmin_read_database_backups_bucket_policy_arn | ARN of the read TransitionDBAdmin database_backups-bucket policy |
| transition_dbadmin_write_database_backups_bucket_policy_arn | ARN of the TransitionDBAdmin write database_backups-bucket policy |
| warehouse_dbadmin_read_database_backups_bucket_policy_arn | ARN of the read WarehouseDBAdmin database_backups-bucket policy |
| warehouse_dbadmin_write_database_backups_bucket_policy_arn | ARN of the WarehouseDBAdmin write database_backups-bucket policy |

