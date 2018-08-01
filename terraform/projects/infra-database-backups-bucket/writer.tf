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
      "arn:aws:s3:::${aws_s3_bucket.database_backups.id}/*mongodb*",
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
      "arn:aws:s3:::${aws_s3_bucket.database_backups.id}/*mysql*",
      "arn:aws:s3:::${aws_s3_bucket.database_backups.id}/*postgres*",
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

output "graphite_write_database_backups_bucket_policy_arn" {
  value       = "${aws_iam_policy.graphite_database_backups_writer.arn}"
  description = "ARN of the Graphite write database_backups-bucket policy"
}
