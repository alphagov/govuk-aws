// IAM policies for legacy db-admin EC2 bastion hosts.
// TODO: delete these once db-admin machines are gone.

resource "aws_iam_policy" "integration_mongo_api_database_backups_reader" {
  name        = "govuk-integration-mongo-api_database_backups-reader-policy"
  policy      = data.aws_iam_policy_document.integration_mongo_api_database_backups_reader.json
  description = "Allows reading the mongo-api database_backups bucket"
}

data "aws_iam_policy_document" "integration_mongo_api_database_backups_reader" {
  statement {
    sid     = "MongoAPIReadBucket"
    actions = ["s3:Get*", "s3:List*"]
    resources = [
      "arn:aws:s3:::govuk-integration-database-backups",
      "arn:aws:s3:::govuk-integration-database-backups/*mongo-api*",
      "arn:aws:s3:::govuk-staging-database-backups",
      "arn:aws:s3:::govuk-staging-database-backups/*mongo-api*",
    ]
  }
}

resource "aws_iam_policy" "integration_mongo_router_database_backups_reader" {
  name        = "govuk-integration-mongo-router_database_backups-reader-policy"
  policy      = data.aws_iam_policy_document.integration_mongo_router_database_backups_reader.json
  description = "Allows reading the mongo-router database_backups bucket"
}

data "aws_iam_policy_document" "integration_mongo_router_database_backups_reader" {
  statement {
    sid     = "MongoRouterReadBucket"
    actions = ["s3:Get*", "s3:List*"]
    resources = [
      "arn:aws:s3:::govuk-integration-database-backups",
      "arn:aws:s3:::govuk-integration-database-backups/*router_backend*",
      "arn:aws:s3:::govuk-integration-database-backups/*mongo-router*",
      "arn:aws:s3:::govuk-staging-database-backups",
      "arn:aws:s3:::govuk-staging-database-backups/*router_backend*",
      "arn:aws:s3:::govuk-staging-database-backups/*mongo-router*",
    ]
  }
}

resource "aws_iam_policy" "integration_mongodb_database_backups_reader" {
  name        = "govuk-integration-mongodb_database_backups-reader-policy"
  policy      = data.aws_iam_policy_document.integration_mongodb_database_backups_reader.json
  description = "Allows reading the mongodb database_backups bucket"
}

data "aws_iam_policy_document" "integration_mongodb_database_backups_reader" {
  statement {
    sid     = "MongoDBReadBucket"
    actions = ["s3:Get*", "s3:List*"]
    resources = [
      "arn:aws:s3:::govuk-integration-database-backups",
      "arn:aws:s3:::govuk-integration-database-backups/*mongo*",
      "arn:aws:s3:::govuk-staging-database-backups",
      "arn:aws:s3:::govuk-staging-database-backups/*mongo*",
    ]
  }
}

resource "aws_iam_policy" "integration_dbadmin_database_backups_reader" {
  name        = "govuk-integration-dbadmin_database_backups-reader-policy"
  policy      = data.aws_iam_policy_document.integration_dbadmin_database_backups_reader.json
  description = "Allows reading the dbadmin database_backups bucket"
}

data "aws_iam_policy_document" "integration_dbadmin_database_backups_reader" {
  statement {
    sid     = "DBAdminReadBucket"
    actions = ["s3:Get*", "s3:List*"]
    resources = [
      "arn:aws:s3:::govuk-integration-database-backups",
      "arn:aws:s3:::govuk-integration-database-backups/*",
      "arn:aws:s3:::govuk-staging-database-backups",
      "arn:aws:s3:::govuk-staging-database-backups/*",
    ]
  }
}

resource "aws_iam_policy" "integration_transition_dbadmin_database_backups_reader" {
  name        = "govuk-integration-transition_dbadmin_database_backups-reader-policy"
  policy      = data.aws_iam_policy_document.integration_transition_dbadmin_database_backups_reader.json
  description = "Allows reading the transition_dbadmin database_backups bucket"
}

data "aws_iam_policy_document" "integration_transition_dbadmin_database_backups_reader" {
  statement {
    sid     = "TransitionDBAdminReadBucket"
    actions = ["s3:Get*", "s3:List*"]
    resources = [
      "arn:aws:s3:::govuk-integration-database-backups",
      "arn:aws:s3:::govuk-integration-database-backups/*transition*",
      "arn:aws:s3:::govuk-staging-database-backups",
      "arn:aws:s3:::govuk-staging-database-backups/*transition*",
    ]
  }
}

resource "aws_iam_policy" "integration_publishing-api_dbadmin_database_backups_reader" {
  name        = "govuk-integration-publishing-api_dbadmin_database_backups-reader-policy"
  policy      = data.aws_iam_policy_document.integration_publishing-api_dbadmin_database_backups_reader.json
  description = "Allows reading the publishing-api_dbadmin database_backups bucket"
}

data "aws_iam_policy_document" "integration_publishing-api_dbadmin_database_backups_reader" {
  statement {
    sid     = "publishingApiDBAdminReadBucket"
    actions = ["s3:Get*", "s3:List*"]
    resources = [
      "arn:aws:s3:::govuk-integration-database-backups",
      "arn:aws:s3:::govuk-integration-database-backups/*publishing-api*",
    ]
  }
}

resource "aws_iam_policy" "integration_email-alert-api_dbadmin_database_backups_reader" {
  name        = "govuk-integration-email-alert-api_dbadmin_database_backups-reader-policy"
  policy      = data.aws_iam_policy_document.integration_email-alert-api_dbadmin_database_backups_reader.json
  description = "Allows reading the email-alert-api_dbadmin database_backups bucket"
}

data "aws_iam_policy_document" "integration_email-alert-api_dbadmin_database_backups_reader" {
  statement {
    sid     = "EmailAlertAPIDBAdminReadBucket"
    actions = ["s3:Get*", "s3:List*"]
    resources = [
      "arn:aws:s3:::govuk-integration-database-backups",
      "arn:aws:s3:::govuk-integration-database-backups/*email-alert-api*",
    ]
  }
}

resource "aws_iam_policy" "staging_mongo_api_database_backups_reader" {
  name        = "govuk-staging-mongo-api_database_backups-reader-policy"
  policy      = data.aws_iam_policy_document.staging_mongo_api_database_backups_reader.json
  description = "Allows reading the mongo-api database_backups bucket"
}

data "aws_iam_policy_document" "staging_mongo_api_database_backups_reader" {
  statement {
    sid     = "MongoAPIReadBucket"
    actions = ["s3:Get*", "s3:List*"]
    resources = [
      "arn:aws:s3:::govuk-staging-database-backups",
      "arn:aws:s3:::govuk-staging-database-backups/*mongo-api*",
    ]
  }
}

resource "aws_iam_policy" "staging_mongo_router_database_backups_reader" {
  name        = "govuk-staging-mongo-router_database_backups-reader-policy"
  policy      = data.aws_iam_policy_document.staging_mongo_router_database_backups_reader.json
  description = "Allows reading the mongo-router database_backups bucket"
}

data "aws_iam_policy_document" "staging_mongo_router_database_backups_reader" {
  statement {
    sid     = "MongoRouterReadBucket"
    actions = ["s3:Get*", "s3:List*"]
    resources = [
      "arn:aws:s3:::govuk-staging-database-backups",
      "arn:aws:s3:::govuk-staging-database-backups/*router_backend*",
      "arn:aws:s3:::govuk-staging-database-backups/*mongo-router*",
    ]
  }
}

resource "aws_iam_policy" "staging_mongodb_database_backups_reader" {
  name        = "govuk-staging-mongodb_database_backups-reader-policy"
  policy      = data.aws_iam_policy_document.staging_mongodb_database_backups_reader.json
  description = "Allows reading the mongodb database_backups bucket"
}

data "aws_iam_policy_document" "staging_mongodb_database_backups_reader" {
  statement {
    sid     = "MongoDBReadBucket"
    actions = ["s3:Get*", "s3:List*"]
    resources = [
      "arn:aws:s3:::govuk-staging-database-backups",
      "arn:aws:s3:::govuk-staging-database-backups/*mongo*",
    ]
  }
}

resource "aws_iam_policy" "staging_dbadmin_database_backups_reader" {
  name        = "govuk-staging-dbadmin_database_backups-reader-policy"
  policy      = data.aws_iam_policy_document.staging_dbadmin_database_backups_reader.json
  description = "Allows reading the dbadmin database_backups bucket"
}

data "aws_iam_policy_document" "staging_dbadmin_database_backups_reader" {
  statement {
    sid     = "DBAdminReadBucket"
    actions = ["s3:Get*", "s3:List*"]
    resources = [
      "arn:aws:s3:::govuk-staging-database-backups",
      "arn:aws:s3:::govuk-staging-database-backups/*",
    ]
  }
}

resource "aws_iam_policy" "staging_publishing-api_dbadmin_database_backups_reader" {
  name        = "govuk-staging-publishing-api_dbadmin_database_backups-reader-policy"
  policy      = data.aws_iam_policy_document.staging_publishing-api_dbadmin_database_backups_reader.json
  description = "Allows reading the publishing-api_dbadmin database_backups bucket"
}

data "aws_iam_policy_document" "staging_publishing-api_dbadmin_database_backups_reader" {
  statement {
    sid     = "publishingApiDBAdminReadBucket"
    actions = ["s3:Get*", "s3:List*"]
    resources = [
      "arn:aws:s3:::govuk-staging-database-backups",
      "arn:aws:s3:::govuk-staging-database-backups/*publishing-api*",
    ]
  }
}

resource "aws_iam_policy" "staging_email-alert-api_dbadmin_database_backups_reader" {
  name        = "govuk-staging-email-alert-api_dbadmin_database_backups-reader-policy"
  policy      = data.aws_iam_policy_document.staging_email-alert-api_dbadmin_database_backups_reader.json
  description = "Allows reading the email-alert-api_dbadmin database_backups bucket"
}

data "aws_iam_policy_document" "staging_email-alert-api_dbadmin_database_backups_reader" {
  statement {
    sid     = "EmailAlertAPIDBAdminReadBucket"
    actions = ["s3:Get*", "s3:List*"]
    resources = [
      "arn:aws:s3:::govuk-staging-database-backups",
      "arn:aws:s3:::govuk-staging-database-backups/*email-alert-api*",
    ]
  }
}

resource "aws_iam_policy" "production_mongo_api_database_backups_reader" {
  name        = "govuk-production-mongo-api_database_backups-reader-policy"
  policy      = data.aws_iam_policy_document.production_mongo_api_database_backups_reader.json
  description = "Allows reading the mongo-api database_backups bucket"
}

data "aws_iam_policy_document" "production_mongo_api_database_backups_reader" {
  statement {
    sid     = "MongoAPIReadBucket"
    actions = ["s3:Get*", "s3:List*"]
    resources = [
      "arn:aws:s3:::govuk-production-database-backups",
      "arn:aws:s3:::govuk-production-database-backups/*mongo-api*",
    ]
  }
}

resource "aws_iam_policy" "production_mongo_router_database_backups_reader" {
  name        = "govuk-production-mongo-router_database_backups-reader-policy"
  policy      = data.aws_iam_policy_document.production_mongo_router_database_backups_reader.json
  description = "Allows reading the mongo-router database_backups bucket"
}

data "aws_iam_policy_document" "production_mongo_router_database_backups_reader" {
  statement {
    sid     = "MongoRouterReadBucket"
    actions = ["s3:Get*", "s3:List*"]
    resources = [
      "arn:aws:s3:::govuk-production-database-backups",
      "arn:aws:s3:::govuk-production-database-backups/*router_backend*",
      "arn:aws:s3:::govuk-production-database-backups/*mongo-router*",
    ]
  }
}

resource "aws_iam_policy" "production_mongodb_database_backups_reader" {
  name        = "govuk-production-mongodb_database_backups-reader-policy"
  policy      = data.aws_iam_policy_document.production_mongodb_database_backups_reader.json
  description = "Allows reading the mongodb database_backups bucket"
}

data "aws_iam_policy_document" "production_mongodb_database_backups_reader" {
  statement {
    sid     = "MongoDBReadBucket"
    actions = ["s3:Get*", "s3:List*"]
    resources = [
      "arn:aws:s3:::govuk-production-database-backups",
      "arn:aws:s3:::govuk-production-database-backups/*mongo*",
    ]
  }
}

resource "aws_iam_policy" "production_dbadmin_database_backups_reader" {
  name        = "govuk-production-dbadmin_database_backups-reader-policy"
  policy      = data.aws_iam_policy_document.production_dbadmin_database_backups_reader.json
  description = "Allows reading the dbadmin database_backups bucket"
}

data "aws_iam_policy_document" "production_dbadmin_database_backups_reader" {
  statement {
    sid     = "DBAdminReadBucket"
    actions = ["s3:Get*", "s3:List*"]
    resources = [
      "arn:aws:s3:::govuk-production-database-backups",
      "arn:aws:s3:::govuk-production-database-backups/*",
    ]
  }
}

resource "aws_iam_policy" "production_content_data_api_dbadmin_database_backups_reader" {
  name        = "govuk-production-content-data-api_dbadmin_database_backups-reader-policy"
  policy      = data.aws_iam_policy_document.production_content_data_api_dbadmin_database_backups_reader.json
  description = "Allows reading from govuk-production-database-backups bucket"
}

data "aws_iam_policy_document" "production_content_data_api_dbadmin_database_backups_reader" {
  statement {
    sid       = "ContentDataAPIDBAdminListBucket"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::govuk-production-database-backups"]
  }

  statement {
    sid     = "ContentDataAPIDBAdminGetObject"
    actions = ["s3:GetObject"]
    resources = [
      "arn:aws:s3:::govuk-production-database-backups/content-data-api-postgresql/*-content_data_api_production.gz",
      # TODO: Remove once Content Data API is using the content_data_api_production database.
      "arn:aws:s3:::govuk-production-database-backups/content-data-api-postgresql/*-content_performance_manager_production.gz",
    ]
  }
}

resource "aws_iam_policy" "production_publishing-api_dbadmin_database_backups_reader" {
  name        = "govuk-production-publishing-api_dbadmin_database_backups-reader-policy"
  policy      = data.aws_iam_policy_document.production_publishing-api_dbadmin_database_backups_reader.json
  description = "Allows reading the publishing-api_dbadmin database_backups bucket"
}

data "aws_iam_policy_document" "production_publishing-api_dbadmin_database_backups_reader" {
  statement {
    sid     = "publishingApiDBAdminReadBucket"
    actions = ["s3:Get*", "s3:List*"]
    resources = [
      "arn:aws:s3:::govuk-production-database-backups",
      "arn:aws:s3:::govuk-production-database-backups/*publishing-api*",
    ]
  }
}

resource "aws_iam_policy" "production_email-alert-api_dbadmin_database_backups_reader" {
  name        = "govuk-production-email-alert-api_dbadmin_database_backups-reader-policy"
  policy      = data.aws_iam_policy_document.production_email-alert-api_dbadmin_database_backups_reader.json
  description = "Allows reading the email-alert-api_dbadmin database_backups bucket"
}

data "aws_iam_policy_document" "production_email-alert-api_dbadmin_database_backups_reader" {
  statement {
    sid     = "EmailAlertAPIDBAdminReadBucket"
    actions = ["s3:Get*", "s3:List*"]
    resources = [
      "arn:aws:s3:::govuk-production-database-backups",
      "arn:aws:s3:::govuk-production-database-backups/*email-alert-api*",
    ]
  }
}
