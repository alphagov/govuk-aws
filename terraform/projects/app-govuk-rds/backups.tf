# All environments should be able to write to the backups bucket for
# their respective environment.
resource "aws_iam_role_policy_attachment" "write_db-admin_database_backups_iam_role_policy_attachment" {
  role       = aws_iam_role.node_iam_role.name
  policy_arn = data.terraform_remote_state.infra_database_backups_bucket.outputs.dbadmin_write_database_backups_bucket_policy_arn
}

# All environments, except production for safety reasons, should be able to read from the production database
# backups bucket, to enable restoring the backups, and the overnight
# data syncs.
resource "aws_iam_role_policy_attachment" "read_from_production_database_backups_from_production_iam_role_policy_attachment" {
  count      = var.aws_environment != "production" ? 1 : 0
  role       = aws_iam_role.node_iam_role.name
  policy_arn = data.terraform_remote_state.infra_database_backups_bucket.outputs.production_dbadmin_read_database_backups_bucket_policy_arn
}

# integration environment should be able to read integration and staging database backups
resource "aws_iam_role_policy_attachment" "read_from_integration_database_backups_from_integration_iam_role_policy_attachment" {
  count      = var.aws_environment == "integration" ? 1 : 0
  role       = aws_iam_role.node_iam_role.name
  policy_arn = data.terraform_remote_state.infra_database_backups_bucket.outputs.integration_dbadmin_read_database_backups_bucket_policy_arn
}

# staging environment should be able to read staging database backups
resource "aws_iam_role_policy_attachment" "read_from_staging_database_backups_from_integration_iam_role_policy_attachment" {
  count      = var.aws_environment == "staging" ? 1 : 0
  role       = aws_iam_role.node_iam_role.name
  policy_arn = data.terraform_remote_state.infra_database_backups_bucket.outputs.staging_dbadmin_read_database_backups_bucket_policy_arn
}
