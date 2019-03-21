/**
* ## Project: database-backups-bucket
*
* Create a policy that allows writing of the database-backups bucket. This
* doesn't create a role as the calling instance is assumed to already
* have one which should be attached to this policy.
*
*/

resource "aws_iam_policy" "mongo_api_database_backups_writer" {
  name        = "govuk-${var.aws_environment}-mongo-api_database_backups-writer-policy"
  policy      = "${data.aws_iam_policy_document.mongo_api_database_backups_writer.json}"
  description = "Allows writing of the mongo-api database_backups bucket"
}

data "aws_iam_policy_document" "mongo_api_database_backups_writer" {
  statement {
    sid = "ReadListOfBuckets"

    actions = [
      "s3:ListAllMyBuckets",
    ]

    resources = ["*"]
  }

  statement {
    sid = "MongoAPIReadBucketLists"

    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
    ]

    # The top level access is required.
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.database_backups.id}",
    ]

    # We can now apply restictions on what can be accessed.
    condition {
      test     = "StringLike"
      variable = "s3:prefix"

      values = [
        "mongo-api",
      ]
    }
  }

  statement {
    sid = "MongoAPIWriteGovukDatabaseBackups"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.database_backups.id}/*mongo-api*",
    ]
  }
}

resource "aws_iam_policy" "mongo_router_database_backups_writer" {
  name        = "govuk-${var.aws_environment}-mongo-router_database_backups-writer-policy"
  policy      = "${data.aws_iam_policy_document.mongo_router_database_backups_writer.json}"
  description = "Allows writing of the router_backend database_backups bucket"
}

data "aws_iam_policy_document" "mongo_router_database_backups_writer" {
  statement {
    sid = "ReadListOfBuckets"

    actions = [
      "s3:ListAllMyBuckets",
    ]

    resources = ["*"]
  }

  statement {
    sid = "MongoRouterReadBucketLists"

    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
    ]

    # The top level access is required.
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.database_backups.id}",
    ]

    # We can now apply restictions on what can be accessed.
    condition {
      test     = "StringLike"
      variable = "s3:prefix"

      values = [
        "router_backend",
        "mongo-router",
      ]
    }
  }

  statement {
    sid = "MongoRouterWriteGovukDatabaseBackups"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.database_backups.id}/*router_backend*",
      "arn:aws:s3:::${aws_s3_bucket.database_backups.id}/*mongo-router*",
    ]
  }
}

resource "aws_iam_policy" "mongodb_database_backups_writer" {
  name        = "govuk-${var.aws_environment}-mongodb_database_backups-writer-policy"
  policy      = "${data.aws_iam_policy_document.mongodb_database_backups_writer.json}"
  description = "Allows writing of the mongodb database_backups bucket"
}

data "aws_iam_policy_document" "mongodb_database_backups_writer" {
  statement {
    sid = "ReadListOfBuckets"

    actions = [
      "s3:ListAllMyBuckets",
    ]

    resources = ["*"]
  }

  statement {
    sid = "MongoDBReadBucketLists"

    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
    ]

    # The top level access is required.
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.database_backups.id}",
    ]

    # We can now apply restictions on what can be accessed.
    condition {
      test     = "StringLike"
      variable = "s3:prefix"

      values = [
        "mongodb",
      ]
    }
  }

  statement {
    sid = "MongoDBWriteGovukDatabaseBackups"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.database_backups.id}/*mongo*",
    ]
  }
}

resource "aws_iam_policy" "elasticsearch_database_backups_writer" {
  name        = "govuk-${var.aws_environment}-elasticsearch_database_backups-writer-policy"
  policy      = "${data.aws_iam_policy_document.elasticsearch_database_backups_writer.json}"
  description = "Allows writing of the elasticsearch database_backups bucket"
}

data "aws_iam_policy_document" "elasticsearch_database_backups_writer" {
  statement {
    sid = "ReadListOfBuckets"

    actions = [
      "s3:ListAllMyBuckets",
    ]

    resources = ["*"]
  }

  statement {
    sid = "ElasticsearchReadBucketLists"

    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
    ]

    # The top level access is required.
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.database_backups.id}",
    ]

    # We can now apply restictions on what can be accessed.
    condition {
      test     = "StringLike"
      variable = "s3:prefix"

      values = [
        "elasticsearch",
      ]
    }
  }

  statement {
    sid = "ElasticsearchWriteGovukDatabaseBackups"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.database_backups.id}/*elasticsearch*",
    ]
  }
}

resource "aws_iam_policy" "dbadmin_database_backups_writer" {
  name        = "govuk-${var.aws_environment}-dbadmin_database_backups-writer-policy"
  policy      = "${data.aws_iam_policy_document.dbadmin_database_backups_writer.json}"
  description = "Allows writing of the DBAdmin database_backups bucket"
}

data "aws_iam_policy_document" "dbadmin_database_backups_writer" {
  statement {
    sid = "ReadListOfBuckets"

    actions = [
      "s3:ListAllMyBuckets",
    ]

    resources = ["*"]
  }

  statement {
    sid = "DBAdminReadBucketLists"

    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
    ]

    # The top level access is required.
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.database_backups.id}",
    ]

    # We can now apply restictions on what can be accessed.
    condition {
      test     = "StringLike"
      variable = "s3:prefix"

      values = [
        "mysql",
        "postgres",
      ]
    }
  }

  statement {
    sid = "DBAdminWriteGovukDatabaseBackups"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.database_backups.id}/*whitehall*",
      "arn:aws:s3:::${aws_s3_bucket.database_backups.id}/*email-alert-api*",
      "arn:aws:s3:::${aws_s3_bucket.database_backups.id}/*publishing-api*",
      "arn:aws:s3:::${aws_s3_bucket.database_backups.id}/*mysql*",
      "arn:aws:s3:::${aws_s3_bucket.database_backups.id}/*postgres*",
    ]
  }
}

resource "aws_iam_policy" "content_data_api_dbadmin_database_backups_writer" {
  name        = "govuk-${var.aws_environment}-content_data_api_dbadmin_database_backups-writer-policy"
  policy      = "${data.aws_iam_policy_document.content_data_api_dbadmin_database_backups_writer.json}"
  description = "Allows writing Content Data API backups to the database_backups bucket"
}

data "aws_iam_policy_document" "content_data_api_dbadmin_database_backups_writer" {
  statement {
    sid = "ReadListOfBuckets"

    actions = [
      "s3:ListAllMyBuckets",
    ]

    resources = ["*"]
  }

  statement {
    sid = "ContentDataAPIDBAdminReadBucketLists"

    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
    ]

    # The top level access is required.
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.database_backups.id}",
    ]

    # We can now apply restictions on what can be accessed.
    condition {
      test     = "StringLike"
      variable = "s3:prefix"

      values = [
        "content-data-api-postgresql",
      ]
    }
  }

  statement {
    sid = "ContentDataAPIDBAdminWriteGovukDatabaseBackups"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.database_backups.id}/content-data-api-postgresql/*-content_data_api.gz",

      # The following line can be removed once the Content Data API
      # database is renamed
      "arn:aws:s3:::${aws_s3_bucket.database_backups.id}/content-data-api-postgresql/*-content_performance_manager.gz",
    ]
  }
}

resource "aws_iam_policy" "transition_dbadmin_database_backups_writer" {
  name        = "govuk-${var.aws_environment}-transition_dbadmin_database_backups-writer-policy"
  policy      = "${data.aws_iam_policy_document.transition_dbadmin_database_backups_writer.json}"
  description = "Allows writing of the TransitionDBAdmin database_backups bucket"
}

data "aws_iam_policy_document" "transition_dbadmin_database_backups_writer" {
  statement {
    sid = "ReadListOfBuckets"

    actions = [
      "s3:ListAllMyBuckets",
    ]

    resources = ["*"]
  }

  statement {
    sid = "TransitionDBAdminReadBucketLists"

    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
    ]

    # The top level access is required.
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.database_backups.id}",
    ]

    # We can now apply restictions on what can be accessed.
    condition {
      test     = "StringLike"
      variable = "s3:prefix"

      values = [
        "mysql",
        "postgres",
      ]
    }
  }

  statement {
    sid = "TransitionDBAdminWriteGovukDatabaseBackups"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.database_backups.id}/*transition*",
    ]
  }
}

resource "aws_iam_policy" "warehouse_dbadmin_database_backups_writer" {
  name        = "govuk-${var.aws_environment}-warehouse_dbadmin_database_backups-writer-policy"
  policy      = "${data.aws_iam_policy_document.warehouse_dbadmin_database_backups_writer.json}"
  description = "Allows writing of the WarehouseDBAdmin database_backups bucket"
}

data "aws_iam_policy_document" "warehouse_dbadmin_database_backups_writer" {
  statement {
    sid = "ReadListOfBuckets"

    actions = [
      "s3:ListAllMyBuckets",
    ]

    resources = ["*"]
  }

  statement {
    sid = "WarehouseDBAdminReadBucketLists"

    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
    ]

    # The top level access is required.
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.database_backups.id}",
    ]

    # We can now apply restictions on what can be accessed.
    condition {
      test     = "StringLike"
      variable = "s3:prefix"

      values = [
        "mysql",
        "postgres",
      ]
    }
  }

  statement {
    sid = "WarehouseDBAdminWriteGovukDatabaseBackups"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.database_backups.id}/*warehouse*",
    ]
  }
}

resource "aws_iam_policy" "publishing-api_dbadmin_database_backups_writer" {
  name        = "govuk-${var.aws_environment}-publishing-api_dbadmin_database_backups-writer-policy"
  policy      = "${data.aws_iam_policy_document.publishing-api_dbadmin_database_backups_writer.json}"
  description = "Allows writing of the publishing-apiDBAdmin database_backups bucket"
}

data "aws_iam_policy_document" "publishing-api_dbadmin_database_backups_writer" {
  statement {
    sid = "ReadListOfBuckets"

    actions = [
      "s3:ListAllMyBuckets",
    ]

    resources = ["*"]
  }

  statement {
    sid = "PublishingAPIDBAdminReadBucketLists"

    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
    ]

    # The top level access is required.
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.database_backups.id}",
    ]

    # We can now apply restictions on what can be accessed.
    condition {
      test     = "StringLike"
      variable = "s3:prefix"

      values = [
        "mysql",
        "postgres",
      ]
    }
  }

  statement {
    sid = "PublishingAPIDBAdminWriteGovukDatabaseBackups"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.database_backups.id}/*publishing-api*",
    ]
  }
}

resource "aws_iam_policy" "email-alert-api_dbadmin_database_backups_writer" {
  name        = "govuk-${var.aws_environment}-email-alert-api_dbadmin_database_backups-writer-policy"
  policy      = "${data.aws_iam_policy_document.email-alert-api_dbadmin_database_backups_writer.json}"
  description = "Allows writing of the email-alert-api DBAdmin database_backups bucket"
}

data "aws_iam_policy_document" "email-alert-api_dbadmin_database_backups_writer" {
  statement {
    sid = "ReadListOfBuckets"

    actions = [
      "s3:ListAllMyBuckets",
    ]

    resources = ["*"]
  }

  statement {
    sid = "EmailAlertAPIDBAdminReadBucketLists"

    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
    ]

    # The top level access is required.
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.database_backups.id}",
    ]

    # We can now apply restictions on what can be accessed.
    condition {
      test     = "StringLike"
      variable = "s3:prefix"

      values = [
        "mysql",
        "postgres",
      ]
    }
  }

  statement {
    sid = "EmailAlertAPIDBAdminWriteGovukDatabaseBackups"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.database_backups.id}/*email-alert-api*",
    ]
  }
}

resource "aws_iam_policy" "graphite_database_backups_writer" {
  name        = "govuk-${var.aws_environment}-graphite_database_backups-writer-policy"
  policy      = "${data.aws_iam_policy_document.graphite_database_backups_writer.json}"
  description = "Allows writing of the Graphite database_backups bucket"
}

data "aws_iam_policy_document" "graphite_database_backups_writer" {
  statement {
    sid = "ReadListOfBuckets"

    actions = [
      "s3:ListAllMyBuckets",
    ]

    resources = ["*"]
  }

  statement {
    sid = "GraphiteReadBucketLists"

    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
    ]

    # The top level access is required.
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.database_backups.id}",
    ]

    # We can now apply restictions on what can be accessed.
    condition {
      test     = "StringLike"
      variable = "s3:prefix"

      values = [
        "whisper",
      ]
    }
  }

  statement {
    sid = "GraphiteWriteGovukDatabaseBackups"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.database_backups.id}/*whisper*",
    ]
  }
}

output "mongo_api_write_database_backups_bucket_policy_arn" {
  value       = "${aws_iam_policy.mongo_api_database_backups_writer.arn}"
  description = "ARN of the mongo-api write database_backups-bucket policy"
}

output "mongo_router_write_database_backups_bucket_policy_arn" {
  value       = "${aws_iam_policy.mongo_router_database_backups_writer.arn}"
  description = "ARN of the router_backend write database_backups-bucket policy"
}

output "mongodb_write_database_backups_bucket_policy_arn" {
  value       = "${aws_iam_policy.mongodb_database_backups_writer.arn}"
  description = "ARN of the mongodb write database_backups-bucket policy"
}

output "elasticsearch_write_database_backups_bucket_policy_arn" {
  value       = "${aws_iam_policy.elasticsearch_database_backups_writer.arn}"
  description = "ARN of the elasticsearch write database_backups-bucket policy"
}

output "dbadmin_write_database_backups_bucket_policy_arn" {
  value       = "${aws_iam_policy.dbadmin_database_backups_writer.arn}"
  description = "ARN of the DBAdmin write database_backups-bucket policy"
}

output "content_data_api_dbadmin_write_database_backups_bucket_policy_arn" {
  value       = "${aws_iam_policy.content_data_api_dbadmin_database_backups_writer.arn}"
  description = "ARN of the Content Data API DBAdmin database_backups bucket writer policy"
}

output "transition_dbadmin_write_database_backups_bucket_policy_arn" {
  value       = "${aws_iam_policy.transition_dbadmin_database_backups_writer.arn}"
  description = "ARN of the TransitionDBAdmin write database_backups-bucket policy"
}

output "warehouse_dbadmin_write_database_backups_bucket_policy_arn" {
  value       = "${aws_iam_policy.warehouse_dbadmin_database_backups_writer.arn}"
  description = "ARN of the WarehouseDBAdmin write database_backups-bucket policy"
}

output "publishing-api_dbadmin_write_database_backups_bucket_policy_arn" {
  value       = "${aws_iam_policy.publishing-api_dbadmin_database_backups_writer.arn}"
  description = "ARN of the publishing-apiDBAdmin write database_backups-bucket policy"
}

output "email-alert-api_dbadmin_write_database_backups_bucket_policy_arn" {
  value       = "${aws_iam_policy.email-alert-api_dbadmin_database_backups_writer.arn}"
  description = "ARN of the EmailAlertAPIDBAdmin write database_backups-bucket policy"
}

output "graphite_write_database_backups_bucket_policy_arn" {
  value       = "${aws_iam_policy.graphite_database_backups_writer.arn}"
  description = "ARN of the Graphite write database_backups-bucket policy"
}
