## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |
| <a name="provider_aws.eu-west-2"></a> [aws.eu-west-2](#provider\_aws.eu-west-2) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.dbadmin_database_backups_writer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.integration_dbadmin_database_backups_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.integration_mongo_api_database_backups_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.integration_mongo_router_database_backups_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.integration_mongodb_database_backups_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.mongo_api_database_backups_writer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.mongo_router_database_backups_writer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.mongodb_database_backups_writer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.production_dbadmin_database_backups_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.production_mongo_api_database_backups_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.production_mongo_router_database_backups_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.production_mongodb_database_backups_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.staging_dbadmin_database_backups_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.staging_mongo_api_database_backups_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.staging_mongo_router_database_backups_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.staging_mongodb_database_backups_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_s3_bucket.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.replica](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_lifecycle_configuration.replica](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_logging.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_logging.replica](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_object_lock_configuration.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object_lock_configuration) | resource |
| [aws_s3_bucket_object_lock_configuration.replica](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object_lock_configuration) | resource |
| [aws_s3_bucket_policy.cross_account_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_public_access_block.replica](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_replication_configuration.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_replication_configuration) | resource |
| [aws_s3_bucket_versioning.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_versioning.replica](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_iam_policy_document.cross_account_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.dbadmin_database_backups_writer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.integration_dbadmin_database_backups_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.integration_mongo_api_database_backups_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.integration_mongo_router_database_backups_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.integration_mongodb_database_backups_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.mongo_api_database_backups_writer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.mongo_router_database_backups_writer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.mongodb_database_backups_writer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.production_dbadmin_database_backups_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.production_mongo_api_database_backups_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.production_mongo_router_database_backups_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.production_mongodb_database_backups_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_can_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.staging_dbadmin_database_backups_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.staging_mongo_api_database_backups_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.staging_mongo_router_database_backups_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.staging_mongodb_database_backups_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_environment"></a> [aws\_environment](#input\_aws\_environment) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dbadmin_write_database_backups_bucket_policy_arn"></a> [dbadmin\_write\_database\_backups\_bucket\_policy\_arn](#output\_dbadmin\_write\_database\_backups\_bucket\_policy\_arn) | n/a |
| <a name="output_integration_dbadmin_read_database_backups_bucket_policy_arn"></a> [integration\_dbadmin\_read\_database\_backups\_bucket\_policy\_arn](#output\_integration\_dbadmin\_read\_database\_backups\_bucket\_policy\_arn) | n/a |
| <a name="output_integration_mongo_api_read_database_backups_bucket_policy_arn"></a> [integration\_mongo\_api\_read\_database\_backups\_bucket\_policy\_arn](#output\_integration\_mongo\_api\_read\_database\_backups\_bucket\_policy\_arn) | n/a |
| <a name="output_integration_mongo_router_read_database_backups_bucket_policy_arn"></a> [integration\_mongo\_router\_read\_database\_backups\_bucket\_policy\_arn](#output\_integration\_mongo\_router\_read\_database\_backups\_bucket\_policy\_arn) | n/a |
| <a name="output_integration_mongodb_read_database_backups_bucket_policy_arn"></a> [integration\_mongodb\_read\_database\_backups\_bucket\_policy\_arn](#output\_integration\_mongodb\_read\_database\_backups\_bucket\_policy\_arn) | n/a |
| <a name="output_mongo_api_write_database_backups_bucket_policy_arn"></a> [mongo\_api\_write\_database\_backups\_bucket\_policy\_arn](#output\_mongo\_api\_write\_database\_backups\_bucket\_policy\_arn) | n/a |
| <a name="output_mongo_router_write_database_backups_bucket_policy_arn"></a> [mongo\_router\_write\_database\_backups\_bucket\_policy\_arn](#output\_mongo\_router\_write\_database\_backups\_bucket\_policy\_arn) | n/a |
| <a name="output_mongodb_write_database_backups_bucket_policy_arn"></a> [mongodb\_write\_database\_backups\_bucket\_policy\_arn](#output\_mongodb\_write\_database\_backups\_bucket\_policy\_arn) | n/a |
| <a name="output_production_dbadmin_read_database_backups_bucket_policy_arn"></a> [production\_dbadmin\_read\_database\_backups\_bucket\_policy\_arn](#output\_production\_dbadmin\_read\_database\_backups\_bucket\_policy\_arn) | n/a |
| <a name="output_production_mongo_api_read_database_backups_bucket_policy_arn"></a> [production\_mongo\_api\_read\_database\_backups\_bucket\_policy\_arn](#output\_production\_mongo\_api\_read\_database\_backups\_bucket\_policy\_arn) | n/a |
| <a name="output_production_mongo_router_read_database_backups_bucket_policy_arn"></a> [production\_mongo\_router\_read\_database\_backups\_bucket\_policy\_arn](#output\_production\_mongo\_router\_read\_database\_backups\_bucket\_policy\_arn) | n/a |
| <a name="output_production_mongodb_read_database_backups_bucket_policy_arn"></a> [production\_mongodb\_read\_database\_backups\_bucket\_policy\_arn](#output\_production\_mongodb\_read\_database\_backups\_bucket\_policy\_arn) | n/a |
| <a name="output_s3_database_backups_bucket_name"></a> [s3\_database\_backups\_bucket\_name](#output\_s3\_database\_backups\_bucket\_name) | Name of the database backups S3 bucket. |
| <a name="output_staging_dbadmin_read_database_backups_bucket_policy_arn"></a> [staging\_dbadmin\_read\_database\_backups\_bucket\_policy\_arn](#output\_staging\_dbadmin\_read\_database\_backups\_bucket\_policy\_arn) | n/a |
| <a name="output_staging_mongo_api_read_database_backups_bucket_policy_arn"></a> [staging\_mongo\_api\_read\_database\_backups\_bucket\_policy\_arn](#output\_staging\_mongo\_api\_read\_database\_backups\_bucket\_policy\_arn) | n/a |
| <a name="output_staging_mongo_router_read_database_backups_bucket_policy_arn"></a> [staging\_mongo\_router\_read\_database\_backups\_bucket\_policy\_arn](#output\_staging\_mongo\_router\_read\_database\_backups\_bucket\_policy\_arn) | n/a |
| <a name="output_staging_mongodb_read_database_backups_bucket_policy_arn"></a> [staging\_mongodb\_read\_database\_backups\_bucket\_policy\_arn](#output\_staging\_mongodb\_read\_database\_backups\_bucket\_policy\_arn) | n/a |
