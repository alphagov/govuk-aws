## Project: database-backups-bucket

This creates an s3 bucket

database-backups: The bucket that will hold database backups



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_backup_region | AWS region | string | `eu-west-2` | no |
| aws_environment | AWS Environment | string | - | yes |
| aws_region | AWS region | string | `eu-west-1` | no |
| expiration_time | Expiration time in days of S3 Objects | string | `120` | no |
| expiration_time_whisper_mongo | Expiration time in days for Whisper/Mongo S3 database backups | string | `7` | no |
| glacier_storage_time | Storage time in days for Glacier Objects | string | `90` | no |
| integration_only | Only apply these policies to integration | string | `false` | no |
| remote_state_bucket | S3 bucket we store our terraform state in | string | - | yes |
| remote_state_infra_monitoring_key_stack | Override stackname path to infra_monitoring remote state | string | `` | no |
| stackname | Stackname | string | - | yes |
| standard_s3_storage_time | Storage time in days for Standard S3 Bucket Objects | string | `30` | no |
| training_only | Only apply these policies to training | string | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| content_data_api_dbadmin_write_database_backups_bucket_policy_arn | ARN of the Content Data API DBAdmin database_backups bucket writer policy |
| dbadmin_write_database_backups_bucket_policy_arn | ARN of the DBAdmin write database_backups-bucket policy |
| elasticsearch_write_database_backups_bucket_policy_arn | ARN of the elasticsearch write database_backups-bucket policy |
| email-alert-api_dbadmin_write_database_backups_bucket_policy_arn | ARN of the EmailAlertAPIDBAdmin write database_backups-bucket policy |
| graphite_write_database_backups_bucket_policy_arn | ARN of the Graphite write database_backups-bucket policy |
| integration_dbadmin_read_database_backups_bucket_policy_arn | ARN of the integration read DBAdmin database_backups-bucket policy |
| integration_elasticsearch_read_database_backups_bucket_policy_arn | ARN of the integration read elasticsearch database_backups-bucket policy |
| integration_email-alert-api_dbadmin_read_database_backups_bucket_policy_arn | ARN of the integration read EmailAlertAPUDBAdmin database_backups-bucket policy |
| integration_graphite_read_database_backups_bucket_policy_arn | ARN of the integration read Graphite database_backups-bucket policy |
| integration_mongo_api_read_database_backups_bucket_policy_arn | ARN of the integration read mongo-api database_backups-bucket policy |
| integration_mongo_router_read_database_backups_bucket_policy_arn | ARN of the integration read router_backend database_backups-bucket policy |
| integration_mongodb_read_database_backups_bucket_policy_arn | ARN of the integration read mongodb database_backups-bucket policy |
| integration_publishing-api_dbadmin_read_database_backups_bucket_policy_arn | ARN of the integration read publishing-apiDBAdmin database_backups-bucket policy |
| integration_transition_dbadmin_read_database_backups_bucket_policy_arn | ARN of the integration read TransitionDBAdmin database_backups-bucket policy |
| mongo_api_write_database_backups_bucket_policy_arn | ARN of the mongo-api write database_backups-bucket policy |
| mongo_router_write_database_backups_bucket_policy_arn | ARN of the router_backend write database_backups-bucket policy |
| mongodb_write_database_backups_bucket_policy_arn | ARN of the mongodb write database_backups-bucket policy |
| production_content_data_api_dbadmin_read_database_backups_bucket_policy_arn | ARN of the production database_backups bucket reader policy for the Content Data API |
| production_dbadmin_read_database_backups_bucket_policy_arn | ARN of the production read DBAdmin database_backups-bucket policy |
| production_elasticsearch_read_database_backups_bucket_policy_arn | ARN of the production read elasticsearch database_backups-bucket policy |
| production_email-alert-api_dbadmin_read_database_backups_bucket_policy_arn | ARN of the production read EmailAlertAPUDBAdmin database_backups-bucket policy |
| production_graphite_read_database_backups_bucket_policy_arn | ARN of the production read Graphite database_backups-bucket policy |
| production_mongo_api_read_database_backups_bucket_policy_arn | ARN of the production read mongo-api database_backups-bucket policy |
| production_mongo_router_read_database_backups_bucket_policy_arn | ARN of the production read router_backend database_backups-bucket policy |
| production_mongodb_read_database_backups_bucket_policy_arn | ARN of the production read mongodb database_backups-bucket policy |
| production_publishing-api_dbadmin_read_database_backups_bucket_policy_arn | ARN of the production read publishing-apiDBAdmin database_backups-bucket policy |
| production_transition_dbadmin_read_database_backups_bucket_policy_arn | ARN of the production read TransitionDBAdmin database_backups-bucket policy |
| publishing-api_dbadmin_write_database_backups_bucket_policy_arn | ARN of the publishing-apiDBAdmin write database_backups-bucket policy |
| s3_database_backups_bucket_name | The name of the database backups bucket |
| staging_dbadmin_read_database_backups_bucket_policy_arn | ARN of the staging read DBAdmin database_backups-bucket policy |
| staging_elasticsearch_read_database_backups_bucket_policy_arn | ARN of the staging read elasticsearch database_backups-bucket policy |
| staging_email-alert-api_dbadmin_read_database_backups_bucket_policy_arn | ARN of the staging read EmailAlertAPUDBAdmin database_backups-bucket policy |
| staging_graphite_read_database_backups_bucket_policy_arn | ARN of the staging read Graphite database_backups-bucket policy |
| staging_mongo_api_read_database_backups_bucket_policy_arn | ARN of the staging read mongo-api database_backups-bucket policy |
| staging_mongo_router_read_database_backups_bucket_policy_arn | ARN of the staging read router_backend database_backups-bucket policy |
| staging_mongodb_read_database_backups_bucket_policy_arn | ARN of the staging read mongodb database_backups-bucket policy |
| staging_publishing-api_dbadmin_read_database_backups_bucket_policy_arn | ARN of the staging read publishing-apiDBAdmin database_backups-bucket policy |
| staging_transition_dbadmin_read_database_backups_bucket_policy_arn | ARN of the staging read TransitionDBAdmin database_backups-bucket policy |
| transition_dbadmin_write_database_backups_bucket_policy_arn | ARN of the TransitionDBAdmin write database_backups-bucket policy |

