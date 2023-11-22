output "s3_database_backups_bucket_name" {
  value       = aws_s3_bucket.main.id
  description = "Name of the database backups S3 bucket."
}

output "integration_mongo_api_read_database_backups_bucket_policy_arn" {
  value = aws_iam_policy.integration_mongo_api_database_backups_reader.arn
}

output "integration_mongo_router_read_database_backups_bucket_policy_arn" {
  value = aws_iam_policy.integration_mongo_router_database_backups_reader.arn
}

output "integration_mongodb_read_database_backups_bucket_policy_arn" {
  value = aws_iam_policy.integration_mongodb_database_backups_reader.arn
}

output "integration_dbadmin_read_database_backups_bucket_policy_arn" {
  value = aws_iam_policy.integration_dbadmin_database_backups_reader.arn
}

output "staging_mongo_api_read_database_backups_bucket_policy_arn" {
  value = aws_iam_policy.staging_mongo_api_database_backups_reader.arn
}

output "staging_mongo_router_read_database_backups_bucket_policy_arn" {
  value = aws_iam_policy.staging_mongo_router_database_backups_reader.arn
}

output "staging_mongodb_read_database_backups_bucket_policy_arn" {
  value = aws_iam_policy.staging_mongodb_database_backups_reader.arn
}

output "staging_dbadmin_read_database_backups_bucket_policy_arn" {
  value = aws_iam_policy.staging_dbadmin_database_backups_reader.arn
}

output "production_mongo_api_read_database_backups_bucket_policy_arn" {
  value = aws_iam_policy.production_mongo_api_database_backups_reader.arn
}

output "production_mongo_router_read_database_backups_bucket_policy_arn" {
  value = aws_iam_policy.production_mongo_router_database_backups_reader.arn
}

output "production_mongodb_read_database_backups_bucket_policy_arn" {
  value = aws_iam_policy.production_mongodb_database_backups_reader.arn
}

output "production_dbadmin_read_database_backups_bucket_policy_arn" {
  value = aws_iam_policy.production_dbadmin_database_backups_reader.arn
}

output "mongo_api_write_database_backups_bucket_policy_arn" {
  value = aws_iam_policy.mongo_api_database_backups_writer.arn
}

output "mongo_router_write_database_backups_bucket_policy_arn" {
  value = aws_iam_policy.mongo_router_database_backups_writer.arn
}

output "mongodb_write_database_backups_bucket_policy_arn" {
  value = aws_iam_policy.mongodb_database_backups_writer.arn
}

output "dbadmin_write_database_backups_bucket_policy_arn" {
  value = aws_iam_policy.dbadmin_database_backups_writer.arn
}
