/**
* ## Project: database-backups-bucket
*
* This is used to provide and control access to the database backup bucket located in the Production environment.
* a) We have created individual resources that can be applied to individual projects.
* b) We have also restricted wich sub object can be accessed.
* c) The bucket gives read access to accounts from all three environments, but we believe that restricting at this level is sufficient.
*
*/

resource "aws_iam_policy" "integration_mongo_api_database_backups_reader" {
  name        = "govuk-integration-mongo-api_database_backups-reader-policy"
  policy      = "${data.aws_iam_policy_document.integration_mongo_api_database_backups_reader.json}"
  description = "Allows reading the mongo-api database_backups bucket"
}

data "aws_iam_policy_document" "integration_mongo_api_database_backups_reader" {
  statement {
    sid = "MongoAPIReadBucket"

    actions = [
      "s3:Get*",
      "s3:List*",
    ]

    # Need access to the top level of the tree.
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
  policy      = "${data.aws_iam_policy_document.integration_mongo_router_database_backups_reader.json}"
  description = "Allows reading the mongo-router database_backups bucket"
}

data "aws_iam_policy_document" "integration_mongo_router_database_backups_reader" {
  statement {
    sid = "MongoRouterReadBucket"

    actions = [
      "s3:Get*",
      "s3:List*",
    ]

    # Need access to the top level of the tree.
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
  policy      = "${data.aws_iam_policy_document.integration_mongodb_database_backups_reader.json}"
  description = "Allows reading the mongodb database_backups bucket"
}

data "aws_iam_policy_document" "integration_mongodb_database_backups_reader" {
  statement {
    sid = "MongoDBReadBucket"

    actions = [
      "s3:Get*",
      "s3:List*",
    ]

    # Need access to the top level of the tree.
    resources = [
      "arn:aws:s3:::govuk-integration-database-backups",
      "arn:aws:s3:::govuk-integration-database-backups/*mongo*",
      "arn:aws:s3:::govuk-staging-database-backups",
      "arn:aws:s3:::govuk-staging-database-backups/*mongo*",
    ]
  }
}

resource "aws_iam_policy" "integration_elasticsearch_database_backups_reader" {
  name        = "govuk-integration-elasticsearch_database_backups-reader-policy"
  policy      = "${data.aws_iam_policy_document.integration_elasticsearch_database_backups_reader.json}"
  description = "Allows reading the elasticsearch database_backups bucket"
}

data "aws_iam_policy_document" "integration_elasticsearch_database_backups_reader" {
  statement {
    sid = "ElasticsearchReadBucket"

    actions = [
      "s3:Get*",
      "s3:List*",
    ]

    # Need access to the top level of the tree.
    resources = [
      "arn:aws:s3:::govuk-integration-database-backups",
      "arn:aws:s3:::govuk-integration-database-backups/*elasticsearch*",
      "arn:aws:s3:::govuk-staging-database-backups",
      "arn:aws:s3:::govuk-staging-database-backups/*elasticsearch*",
    ]
  }
}

resource "aws_iam_policy" "integration_dbadmin_database_backups_reader" {
  name        = "govuk-integration-dbadmin_database_backups-reader-policy"
  policy      = "${data.aws_iam_policy_document.integration_dbadmin_database_backups_reader.json}"
  description = "Allows reading the dbadmin database_backups bucket"
}

data "aws_iam_policy_document" "integration_dbadmin_database_backups_reader" {
  statement {
    sid = "DBAdminReadBucket"

    actions = [
      "s3:Get*",
      "s3:List*",
    ]

    # Need access to the top level of the tree.
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
  policy      = "${data.aws_iam_policy_document.integration_transition_dbadmin_database_backups_reader.json}"
  description = "Allows reading the transition_dbadmin database_backups bucket"
}

data "aws_iam_policy_document" "integration_transition_dbadmin_database_backups_reader" {
  statement {
    sid = "TransitionDBAdminReadBucket"

    actions = [
      "s3:Get*",
      "s3:List*",
    ]

    # Need access to the top level of the tree.
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
  policy      = "${data.aws_iam_policy_document.integration_publishing-api_dbadmin_database_backups_reader.json}"
  description = "Allows reading the publishing-api_dbadmin database_backups bucket"
}

data "aws_iam_policy_document" "integration_publishing-api_dbadmin_database_backups_reader" {
  statement {
    sid = "publishingApiDBAdminReadBucket"

    actions = [
      "s3:Get*",
      "s3:List*",
    ]

    # Need access to the top level of the tree.
    resources = [
      "arn:aws:s3:::govuk-integration-database-backups",
      "arn:aws:s3:::govuk-integration-database-backups/*publishing-api*",
    ]
  }
}

resource "aws_iam_policy" "integration_email-alert-api_dbadmin_database_backups_reader" {
  name        = "govuk-integration-email-alert-api_dbadmin_database_backups-reader-policy"
  policy      = "${data.aws_iam_policy_document.integration_email-alert-api_dbadmin_database_backups_reader.json}"
  description = "Allows reading the email-alert-api_dbadmin database_backups bucket"
}

data "aws_iam_policy_document" "integration_email-alert-api_dbadmin_database_backups_reader" {
  statement {
    sid = "EmailAlertAPIDBAdminReadBucket"

    actions = [
      "s3:Get*",
      "s3:List*",
    ]

    # Need access to the top level of the tree.
    resources = [
      "arn:aws:s3:::govuk-integration-database-backups",
      "arn:aws:s3:::govuk-integration-database-backups/*email-alert-api*",
    ]
  }
}

resource "aws_iam_policy" "integration_graphite_database_backups_reader" {
  name        = "govuk-integration-graphite_database_backups-reader-policy"
  policy      = "${data.aws_iam_policy_document.integration_graphite_database_backups_reader.json}"
  description = "Allows reading the graphite database_backups bucket"
}

data "aws_iam_policy_document" "integration_graphite_database_backups_reader" {
  statement {
    sid = "GraphiteReadBucket"

    actions = [
      "s3:Get*",
      "s3:List*",
    ]

    # Need access to the top level of the tree.
    resources = [
      "arn:aws:s3:::govuk-integration-database-backups",
      "arn:aws:s3:::govuk-integration-database-backups/*whisper*",
      "arn:aws:s3:::govuk-staging-database-backups",
      "arn:aws:s3:::govuk-staging-database-backups/*whisper*",
    ]
  }
}

resource "aws_iam_policy" "staging_mongo_api_database_backups_reader" {
  name        = "govuk-staging-mongo-api_database_backups-reader-policy"
  policy      = "${data.aws_iam_policy_document.staging_mongo_api_database_backups_reader.json}"
  description = "Allows reading the mongo-api database_backups bucket"
}

data "aws_iam_policy_document" "staging_mongo_api_database_backups_reader" {
  statement {
    sid = "MongoAPIReadBucket"

    actions = [
      "s3:Get*",
      "s3:List*",
    ]

    # Need access to the top level of the tree.
    resources = [
      "arn:aws:s3:::govuk-staging-database-backups",
      "arn:aws:s3:::govuk-staging-database-backups/*mongo-api*",
    ]
  }
}

resource "aws_iam_policy" "staging_mongo_router_database_backups_reader" {
  name        = "govuk-staging-mongo-router_database_backups-reader-policy"
  policy      = "${data.aws_iam_policy_document.staging_mongo_router_database_backups_reader.json}"
  description = "Allows reading the mongo-router database_backups bucket"
}

data "aws_iam_policy_document" "staging_mongo_router_database_backups_reader" {
  statement {
    sid = "MongoRouterReadBucket"

    actions = [
      "s3:Get*",
      "s3:List*",
    ]

    # Need access to the top level of the tree.
    resources = [
      "arn:aws:s3:::govuk-staging-database-backups",
      "arn:aws:s3:::govuk-staging-database-backups/*router_backend*",
      "arn:aws:s3:::govuk-staging-database-backups/*mongo-router*",
    ]
  }
}

resource "aws_iam_policy" "staging_mongodb_database_backups_reader" {
  name        = "govuk-staging-mongodb_database_backups-reader-policy"
  policy      = "${data.aws_iam_policy_document.staging_mongodb_database_backups_reader.json}"
  description = "Allows reading the mongodb database_backups bucket"
}

data "aws_iam_policy_document" "staging_mongodb_database_backups_reader" {
  statement {
    sid = "MongoDBReadBucket"

    actions = [
      "s3:Get*",
      "s3:List*",
    ]

    # Need access to the top level of the tree.
    resources = [
      "arn:aws:s3:::govuk-staging-database-backups",
      "arn:aws:s3:::govuk-staging-database-backups/*mongo*",
    ]
  }
}

resource "aws_iam_policy" "staging_elasticsearch_database_backups_reader" {
  name        = "govuk-staging-elasticsearch_database_backups-reader-policy"
  policy      = "${data.aws_iam_policy_document.staging_elasticsearch_database_backups_reader.json}"
  description = "Allows reading the elasticsearch database_backups bucket"
}

data "aws_iam_policy_document" "staging_elasticsearch_database_backups_reader" {
  statement {
    sid = "ElasticsearchReadBucket"

    actions = [
      "s3:Get*",
      "s3:List*",
    ]

    # Need access to the top level of the tree.
    resources = [
      "arn:aws:s3:::govuk-staging-database-backups",
      "arn:aws:s3:::govuk-staging-database-backups/*elasticsearch*",
    ]
  }
}

resource "aws_iam_policy" "staging_dbadmin_database_backups_reader" {
  name        = "govuk-staging-dbadmin_database_backups-reader-policy"
  policy      = "${data.aws_iam_policy_document.staging_dbadmin_database_backups_reader.json}"
  description = "Allows reading the dbadmin database_backups bucket"
}

data "aws_iam_policy_document" "staging_dbadmin_database_backups_reader" {
  statement {
    sid = "DBAdminReadBucket"

    actions = [
      "s3:Get*",
      "s3:List*",
    ]

    # Need access to the top level of the tree.
    resources = [
      "arn:aws:s3:::govuk-staging-database-backups",
      "arn:aws:s3:::govuk-staging-database-backups/*",
    ]
  }
}

resource "aws_iam_policy" "staging_transition_dbadmin_database_backups_reader" {
  name        = "govuk-staging-transition_dbadmin_database_backups-reader-policy"
  policy      = "${data.aws_iam_policy_document.staging_transition_dbadmin_database_backups_reader.json}"
  description = "Allows reading the transition_dbadmin database_backups bucket"
}

data "aws_iam_policy_document" "staging_transition_dbadmin_database_backups_reader" {
  statement {
    sid = "TransitionDBAdminReadBucket"

    actions = [
      "s3:Get*",
      "s3:List*",
    ]

    # Need access to the top level of the tree.
    resources = [
      "arn:aws:s3:::govuk-staging-database-backups",
      "arn:aws:s3:::govuk-staging-database-backups/*transition*",
    ]
  }
}

resource "aws_iam_policy" "staging_publishing-api_dbadmin_database_backups_reader" {
  name        = "govuk-staging-publishing-api_dbadmin_database_backups-reader-policy"
  policy      = "${data.aws_iam_policy_document.staging_publishing-api_dbadmin_database_backups_reader.json}"
  description = "Allows reading the publishing-api_dbadmin database_backups bucket"
}

data "aws_iam_policy_document" "staging_publishing-api_dbadmin_database_backups_reader" {
  statement {
    sid = "publishingApiDBAdminReadBucket"

    actions = [
      "s3:Get*",
      "s3:List*",
    ]

    # Need access to the top level of the tree.
    resources = [
      "arn:aws:s3:::govuk-staging-database-backups",
      "arn:aws:s3:::govuk-staging-database-backups/*publishing-api*",
    ]
  }
}

resource "aws_iam_policy" "staging_email-alert-api_dbadmin_database_backups_reader" {
  name        = "govuk-staging-email-alert-api_dbadmin_database_backups-reader-policy"
  policy      = "${data.aws_iam_policy_document.staging_email-alert-api_dbadmin_database_backups_reader.json}"
  description = "Allows reading the email-alert-api_dbadmin database_backups bucket"
}

data "aws_iam_policy_document" "staging_email-alert-api_dbadmin_database_backups_reader" {
  statement {
    sid = "EmailAlertAPIDBAdminReadBucket"

    actions = [
      "s3:Get*",
      "s3:List*",
    ]

    # Need access to the top level of the tree.
    resources = [
      "arn:aws:s3:::govuk-staging-database-backups",
      "arn:aws:s3:::govuk-staging-database-backups/*email-alert-api*",
    ]
  }
}

resource "aws_iam_policy" "staging_graphite_database_backups_reader" {
  name        = "govuk-staging-graphite_database_backups-reader-policy"
  policy      = "${data.aws_iam_policy_document.staging_graphite_database_backups_reader.json}"
  description = "Allows reading the graphite database_backups bucket"
}

data "aws_iam_policy_document" "staging_graphite_database_backups_reader" {
  statement {
    sid = "GraphiteReadBucket"

    actions = [
      "s3:Get*",
      "s3:List*",
    ]

    # Need access to the top level of the tree.
    resources = [
      "arn:aws:s3:::govuk-staging-database-backups",
      "arn:aws:s3:::govuk-staging-database-backups/*whisper*",
    ]
  }
}

resource "aws_iam_policy" "production_mongo_api_database_backups_reader" {
  name        = "govuk-production-mongo-api_database_backups-reader-policy"
  policy      = "${data.aws_iam_policy_document.production_mongo_api_database_backups_reader.json}"
  description = "Allows reading the mongo-api database_backups bucket"
}

data "aws_iam_policy_document" "production_mongo_api_database_backups_reader" {
  statement {
    sid = "MongoAPIReadBucket"

    actions = [
      "s3:Get*",
      "s3:List*",
    ]

    # Need access to the top level of the tree.
    resources = [
      "arn:aws:s3:::govuk-production-database-backups",
      "arn:aws:s3:::govuk-production-database-backups/*mongo-api*",
    ]
  }
}

resource "aws_iam_policy" "production_mongo_router_database_backups_reader" {
  name        = "govuk-production-mongo-router_database_backups-reader-policy"
  policy      = "${data.aws_iam_policy_document.production_mongo_router_database_backups_reader.json}"
  description = "Allows reading the mongo-router database_backups bucket"
}

data "aws_iam_policy_document" "production_mongo_router_database_backups_reader" {
  statement {
    sid = "MongoRouterReadBucket"

    actions = [
      "s3:Get*",
      "s3:List*",
    ]

    # Need access to the top level of the tree.
    resources = [
      "arn:aws:s3:::govuk-production-database-backups",
      "arn:aws:s3:::govuk-production-database-backups/*router_backend*",
      "arn:aws:s3:::govuk-production-database-backups/*mongo-router*",
    ]
  }
}

resource "aws_iam_policy" "production_mongodb_database_backups_reader" {
  name        = "govuk-production-mongodb_database_backups-reader-policy"
  policy      = "${data.aws_iam_policy_document.production_mongodb_database_backups_reader.json}"
  description = "Allows reading the mongodb database_backups bucket"
}

data "aws_iam_policy_document" "production_mongodb_database_backups_reader" {
  statement {
    sid = "MongoDBReadBucket"

    actions = [
      "s3:Get*",
      "s3:List*",
    ]

    # Need access to the top level of the tree.
    resources = [
      "arn:aws:s3:::govuk-production-database-backups",
      "arn:aws:s3:::govuk-production-database-backups/*mongo*",
    ]
  }
}

resource "aws_iam_policy" "production_elasticsearch_database_backups_reader" {
  name        = "govuk-production-elasticsearch_database_backups-reader-policy"
  policy      = "${data.aws_iam_policy_document.production_elasticsearch_database_backups_reader.json}"
  description = "Allows reading the elasticsearch database_backups bucket"
}

data "aws_iam_policy_document" "production_elasticsearch_database_backups_reader" {
  statement {
    sid = "ElasticsearchReadBucket"

    actions = [
      "s3:Get*",
      "s3:List*",
    ]

    # Need access to the top level of the tree.
    resources = [
      "arn:aws:s3:::govuk-production-database-backups",
      "arn:aws:s3:::govuk-production-database-backups/*elasticsearch*",
    ]
  }
}

resource "aws_iam_policy" "production_dbadmin_database_backups_reader" {
  name        = "govuk-production-dbadmin_database_backups-reader-policy"
  policy      = "${data.aws_iam_policy_document.production_dbadmin_database_backups_reader.json}"
  description = "Allows reading the dbadmin database_backups bucket"
}

data "aws_iam_policy_document" "production_dbadmin_database_backups_reader" {
  statement {
    sid = "DBAdminReadBucket"

    actions = [
      "s3:Get*",
      "s3:List*",
    ]

    # Need access to the top level of the tree.
    resources = [
      "arn:aws:s3:::govuk-production-database-backups",
      "arn:aws:s3:::govuk-production-database-backups/*",
    ]
  }
}

resource "aws_iam_policy" "production_content_data_api_dbadmin_database_backups_reader" {
  name        = "govuk-production-content-data-api_dbadmin_database_backups-reader-policy"
  policy      = "${data.aws_iam_policy_document.production_content_data_api_dbadmin_database_backups_reader.json}"
  description = "Allows reading from govuk-production-database-backups bucket"
}

data "aws_iam_policy_document" "production_content_data_api_dbadmin_database_backups_reader" {
  statement {
    sid = "ContentDataAPIDBAdminListBucket"

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::govuk-production-database-backups",
    ]
  }

  statement {
    sid = "ContentDataAPIDBAdminGetObject"

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::govuk-production-database-backups/content-data-api-postgresql/*-content_data_api_production.gz",

      # This can be removed once the Content Data API is changed to
      # use the content_data_api_production database
      "arn:aws:s3:::govuk-production-database-backups/content-data-api-postgresql/*-content_performance_manager_production.gz",
    ]
  }
}

resource "aws_iam_policy" "production_transition_dbadmin_database_backups_reader" {
  name        = "govuk-production-transition_dbadmin_database_backups-reader-policy"
  policy      = "${data.aws_iam_policy_document.production_transition_dbadmin_database_backups_reader.json}"
  description = "Allows reading the transition_dbadmin database_backups bucket"
}

data "aws_iam_policy_document" "production_transition_dbadmin_database_backups_reader" {
  statement {
    sid = "TransitionDBAdminReadBucket"

    actions = [
      "s3:Get*",
      "s3:List*",
    ]

    # Need access to the top level of the tree.
    resources = [
      "arn:aws:s3:::govuk-production-database-backups",
      "arn:aws:s3:::govuk-production-database-backups/*transition*",
    ]
  }
}

resource "aws_iam_policy" "production_publishing-api_dbadmin_database_backups_reader" {
  name        = "govuk-production-publishing-api_dbadmin_database_backups-reader-policy"
  policy      = "${data.aws_iam_policy_document.production_publishing-api_dbadmin_database_backups_reader.json}"
  description = "Allows reading the publishing-api_dbadmin database_backups bucket"
}

data "aws_iam_policy_document" "production_publishing-api_dbadmin_database_backups_reader" {
  statement {
    sid = "publishingApiDBAdminReadBucket"

    actions = [
      "s3:Get*",
      "s3:List*",
    ]

    # Need access to the top level of the tree.
    resources = [
      "arn:aws:s3:::govuk-production-database-backups",
      "arn:aws:s3:::govuk-production-database-backups/*publishing-api*",
    ]
  }
}

resource "aws_iam_policy" "production_email-alert-api_dbadmin_database_backups_reader" {
  name        = "govuk-production-email-alert-api_dbadmin_database_backups-reader-policy"
  policy      = "${data.aws_iam_policy_document.production_email-alert-api_dbadmin_database_backups_reader.json}"
  description = "Allows reading the email-alert-api_dbadmin database_backups bucket"
}

data "aws_iam_policy_document" "production_email-alert-api_dbadmin_database_backups_reader" {
  statement {
    sid = "EmailAlertAPIDBAdminReadBucket"

    actions = [
      "s3:Get*",
      "s3:List*",
    ]

    # Need access to the top level of the tree.
    resources = [
      "arn:aws:s3:::govuk-production-database-backups",
      "arn:aws:s3:::govuk-production-database-backups/*email-alert-api*",
    ]
  }
}

resource "aws_iam_policy" "production_graphite_database_backups_reader" {
  name        = "govuk-production-graphite_database_backups-reader-policy"
  policy      = "${data.aws_iam_policy_document.production_graphite_database_backups_reader.json}"
  description = "Allows reading the graphite database_backups bucket"
}

data "aws_iam_policy_document" "production_graphite_database_backups_reader" {
  statement {
    sid = "GraphiteReadBucket"

    actions = [
      "s3:Get*",
      "s3:List*",
    ]

    # Need access to the top level of the tree.
    resources = [
      "arn:aws:s3:::govuk-production-database-backups",
      "arn:aws:s3:::govuk-production-database-backups/*whisper*",
    ]
  }
}

output "integration_mongo_api_read_database_backups_bucket_policy_arn" {
  value       = "${aws_iam_policy.integration_mongo_api_database_backups_reader.arn}"
  description = "ARN of the integration read mongo-api database_backups-bucket policy"
}

output "integration_mongo_router_read_database_backups_bucket_policy_arn" {
  value       = "${aws_iam_policy.integration_mongo_router_database_backups_reader.arn}"
  description = "ARN of the integration read router_backend database_backups-bucket policy"
}

output "integration_mongodb_read_database_backups_bucket_policy_arn" {
  value       = "${aws_iam_policy.integration_mongodb_database_backups_reader.arn}"
  description = "ARN of the integration read mongodb database_backups-bucket policy"
}

output "integration_elasticsearch_read_database_backups_bucket_policy_arn" {
  value       = "${aws_iam_policy.integration_elasticsearch_database_backups_reader.arn}"
  description = "ARN of the integration read elasticsearch database_backups-bucket policy"
}

output "integration_dbadmin_read_database_backups_bucket_policy_arn" {
  value       = "${aws_iam_policy.integration_dbadmin_database_backups_reader.arn}"
  description = "ARN of the integration read DBAdmin database_backups-bucket policy"
}

output "integration_transition_dbadmin_read_database_backups_bucket_policy_arn" {
  value       = "${aws_iam_policy.integration_transition_dbadmin_database_backups_reader.arn}"
  description = "ARN of the integration read TransitionDBAdmin database_backups-bucket policy"
}

output "integration_publishing-api_dbadmin_read_database_backups_bucket_policy_arn" {
  value       = "${aws_iam_policy.integration_publishing-api_dbadmin_database_backups_reader.arn}"
  description = "ARN of the integration read publishing-apiDBAdmin database_backups-bucket policy"
}

output "integration_email-alert-api_dbadmin_read_database_backups_bucket_policy_arn" {
  value       = "${aws_iam_policy.integration_email-alert-api_dbadmin_database_backups_reader.arn}"
  description = "ARN of the integration read EmailAlertAPUDBAdmin database_backups-bucket policy"
}

output "integration_graphite_read_database_backups_bucket_policy_arn" {
  value       = "${aws_iam_policy.integration_graphite_database_backups_reader.arn}"
  description = "ARN of the integration read Graphite database_backups-bucket policy"
}

output "staging_mongo_api_read_database_backups_bucket_policy_arn" {
  value       = "${aws_iam_policy.staging_mongo_api_database_backups_reader.arn}"
  description = "ARN of the staging read mongo-api database_backups-bucket policy"
}

output "staging_mongo_router_read_database_backups_bucket_policy_arn" {
  value       = "${aws_iam_policy.staging_mongo_router_database_backups_reader.arn}"
  description = "ARN of the staging read router_backend database_backups-bucket policy"
}

output "staging_mongodb_read_database_backups_bucket_policy_arn" {
  value       = "${aws_iam_policy.staging_mongodb_database_backups_reader.arn}"
  description = "ARN of the staging read mongodb database_backups-bucket policy"
}

output "staging_elasticsearch_read_database_backups_bucket_policy_arn" {
  value       = "${aws_iam_policy.staging_elasticsearch_database_backups_reader.arn}"
  description = "ARN of the staging read elasticsearch database_backups-bucket policy"
}

output "staging_dbadmin_read_database_backups_bucket_policy_arn" {
  value       = "${aws_iam_policy.staging_dbadmin_database_backups_reader.arn}"
  description = "ARN of the staging read DBAdmin database_backups-bucket policy"
}

output "staging_transition_dbadmin_read_database_backups_bucket_policy_arn" {
  value       = "${aws_iam_policy.staging_transition_dbadmin_database_backups_reader.arn}"
  description = "ARN of the staging read TransitionDBAdmin database_backups-bucket policy"
}

output "staging_publishing-api_dbadmin_read_database_backups_bucket_policy_arn" {
  value       = "${aws_iam_policy.staging_publishing-api_dbadmin_database_backups_reader.arn}"
  description = "ARN of the staging read publishing-apiDBAdmin database_backups-bucket policy"
}

output "staging_email-alert-api_dbadmin_read_database_backups_bucket_policy_arn" {
  value       = "${aws_iam_policy.staging_email-alert-api_dbadmin_database_backups_reader.arn}"
  description = "ARN of the staging read EmailAlertAPUDBAdmin database_backups-bucket policy"
}

output "staging_graphite_read_database_backups_bucket_policy_arn" {
  value       = "${aws_iam_policy.staging_graphite_database_backups_reader.arn}"
  description = "ARN of the staging read Graphite database_backups-bucket policy"
}

output "production_mongo_api_read_database_backups_bucket_policy_arn" {
  value       = "${aws_iam_policy.production_mongo_api_database_backups_reader.arn}"
  description = "ARN of the production read mongo-api database_backups-bucket policy"
}

output "production_mongo_router_read_database_backups_bucket_policy_arn" {
  value       = "${aws_iam_policy.production_mongo_router_database_backups_reader.arn}"
  description = "ARN of the production read router_backend database_backups-bucket policy"
}

output "production_mongodb_read_database_backups_bucket_policy_arn" {
  value       = "${aws_iam_policy.production_mongodb_database_backups_reader.arn}"
  description = "ARN of the production read mongodb database_backups-bucket policy"
}

output "production_elasticsearch_read_database_backups_bucket_policy_arn" {
  value       = "${aws_iam_policy.production_elasticsearch_database_backups_reader.arn}"
  description = "ARN of the production read elasticsearch database_backups-bucket policy"
}

output "production_dbadmin_read_database_backups_bucket_policy_arn" {
  value       = "${aws_iam_policy.production_dbadmin_database_backups_reader.arn}"
  description = "ARN of the production read DBAdmin database_backups-bucket policy"
}

output "production_content_data_api_dbadmin_read_database_backups_bucket_policy_arn" {
  value       = "${aws_iam_policy.production_content_data_api_dbadmin_database_backups_reader.arn}"
  description = "ARN of the production database_backups bucket reader policy for the Content Data API"
}

output "production_transition_dbadmin_read_database_backups_bucket_policy_arn" {
  value       = "${aws_iam_policy.production_transition_dbadmin_database_backups_reader.arn}"
  description = "ARN of the production read TransitionDBAdmin database_backups-bucket policy"
}

output "production_publishing-api_dbadmin_read_database_backups_bucket_policy_arn" {
  value       = "${aws_iam_policy.production_publishing-api_dbadmin_database_backups_reader.arn}"
  description = "ARN of the production read publishing-apiDBAdmin database_backups-bucket policy"
}

output "production_email-alert-api_dbadmin_read_database_backups_bucket_policy_arn" {
  value       = "${aws_iam_policy.production_email-alert-api_dbadmin_database_backups_reader.arn}"
  description = "ARN of the production read EmailAlertAPUDBAdmin database_backups-bucket policy"
}

output "production_graphite_read_database_backups_bucket_policy_arn" {
  value       = "${aws_iam_policy.production_graphite_database_backups_reader.arn}"
  description = "ARN of the production read Graphite database_backups-bucket policy"
}
