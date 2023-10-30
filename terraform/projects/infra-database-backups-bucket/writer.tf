// IAM policies for legacy db-admin EC2 bastion hosts.
// TODO: delete these once db-admin machines are gone.

resource "aws_iam_policy" "mongo_api_database_backups_writer" {
  name        = "govuk-${var.aws_environment}-mongo-api_database_backups-writer-policy"
  policy      = data.aws_iam_policy_document.mongo_api_database_backups_writer.json
  description = "Allows writing of the mongo-api database_backups bucket"
}

data "aws_iam_policy_document" "mongo_api_database_backups_writer" {
  statement {
    sid       = "ReadListOfBuckets"
    actions   = ["s3:ListAllMyBuckets"]
    resources = ["*"]
  }

  statement {
    sid       = "MongoAPIReadBucketLists"
    actions   = ["s3:ListBucket", "s3:GetBucketLocation"]
    resources = [aws_s3_bucket.main.arn]
    condition {
      test     = "StringLike"
      variable = "s3:prefix"
      values   = ["mongo-api"]
    }
  }

  statement {
    sid       = "MongoAPIWriteGovukDatabaseBackups"
    actions   = ["s3:PutObject", "s3:GetObject", "s3:DeleteObject"]
    resources = ["${aws_s3_bucket.main.arn}/*mongo-api*"]
  }
}

resource "aws_iam_policy" "mongo_router_database_backups_writer" {
  name        = "govuk-${var.aws_environment}-mongo-router_database_backups-writer-policy"
  policy      = data.aws_iam_policy_document.mongo_router_database_backups_writer.json
  description = "Allows writing of the router_backend database_backups bucket"
}

data "aws_iam_policy_document" "mongo_router_database_backups_writer" {
  statement {
    sid       = "ReadListOfBuckets"
    actions   = ["s3:ListAllMyBuckets"]
    resources = ["*"]
  }

  statement {
    sid       = "MongoRouterReadBucketLists"
    actions   = ["s3:ListBucket", "s3:GetBucketLocation"]
    resources = [aws_s3_bucket.main.arn]
    condition {
      test     = "StringLike"
      variable = "s3:prefix"
      values   = ["router_backend", "mongo-router"]
    }
  }

  statement {
    sid     = "MongoRouterWriteGovukDatabaseBackups"
    actions = ["s3:PutObject", "s3:GetObject", "s3:DeleteObject"]
    resources = [
      "${aws_s3_bucket.main.arn}/*router_backend*",
      "${aws_s3_bucket.main.arn}/*mongo-router*",
    ]
  }
}

resource "aws_iam_policy" "mongodb_database_backups_writer" {
  name        = "govuk-${var.aws_environment}-mongodb_database_backups-writer-policy"
  policy      = data.aws_iam_policy_document.mongodb_database_backups_writer.json
  description = "Allows writing of the mongodb database_backups bucket"
}

data "aws_iam_policy_document" "mongodb_database_backups_writer" {
  statement {
    sid       = "ReadListOfBuckets"
    actions   = ["s3:ListAllMyBuckets"]
    resources = ["*"]
  }

  statement {
    sid       = "MongoDBReadBucketLists"
    actions   = ["s3:ListBucket", "s3:GetBucketLocation"]
    resources = [aws_s3_bucket.main.arn]
    condition {
      test     = "StringLike"
      variable = "s3:prefix"
      values   = ["mongodb"]
    }
  }

  statement {
    sid       = "MongoDBWriteGovukDatabaseBackups"
    actions   = ["s3:PutObject", "s3:GetObject", "s3:DeleteObject"]
    resources = ["${aws_s3_bucket.main.arn}/*mongo*"]
  }
}

resource "aws_iam_policy" "dbadmin_database_backups_writer" {
  name        = "govuk-${var.aws_environment}-dbadmin_database_backups-writer-policy"
  policy      = data.aws_iam_policy_document.dbadmin_database_backups_writer.json
  description = "Allows writing of the DBAdmin database_backups bucket"
}

data "aws_iam_policy_document" "dbadmin_database_backups_writer" {
  statement {
    sid       = "ReadListOfBuckets"
    actions   = ["s3:ListAllMyBuckets"]
    resources = ["*"]
  }

  statement {
    sid       = "DBAdminReadBucketLists"
    actions   = ["s3:ListBucket", "s3:GetBucketLocation"]
    resources = [aws_s3_bucket.main.arn]
    condition {
      test     = "StringLike"
      variable = "s3:prefix"
      values   = ["mysql", "postgres"]
    }
  }

  statement {
    sid     = "DBAdminWriteGovukDatabaseBackups"
    actions = ["s3:PutObject", "s3:GetObject", "s3:DeleteObject"]

    resources = [
      "${aws_s3_bucket.main.arn}/*whitehall*",
      "${aws_s3_bucket.main.arn}/*email-alert-api*",
      "${aws_s3_bucket.main.arn}/*account*",
      "${aws_s3_bucket.main.arn}/*publishing-api*",
      "${aws_s3_bucket.main.arn}/*mongo-licensing*",
      "${aws_s3_bucket.main.arn}/*mysql*",
      "${aws_s3_bucket.main.arn}/*postgres*",
      "${aws_s3_bucket.main.arn}/*mongo-normal*",
    ]
  }
}

resource "aws_iam_policy" "publishing-api_dbadmin_database_backups_writer" {
  name        = "govuk-${var.aws_environment}-publishing-api_dbadmin_database_backups-writer-policy"
  policy      = data.aws_iam_policy_document.publishing-api_dbadmin_database_backups_writer.json
  description = "Allows writing of the publishing-apiDBAdmin database_backups bucket"
}

data "aws_iam_policy_document" "publishing-api_dbadmin_database_backups_writer" {
  statement {
    sid       = "ReadListOfBuckets"
    actions   = ["s3:ListAllMyBuckets"]
    resources = ["*"]
  }

  statement {
    sid       = "PublishingAPIDBAdminReadBucketLists"
    actions   = ["s3:ListBucket", "s3:GetBucketLocation"]
    resources = [aws_s3_bucket.main.arn]
    condition {
      test     = "StringLike"
      variable = "s3:prefix"
      values   = ["mysql", "postgres"]
    }
  }

  statement {
    sid       = "PublishingAPIDBAdminWriteGovukDatabaseBackups"
    actions   = ["s3:PutObject", "s3:GetObject", "s3:DeleteObject"]
    resources = ["${aws_s3_bucket.main.arn}/*publishing-api*"]
  }
}

resource "aws_iam_policy" "email-alert-api_dbadmin_database_backups_writer" {
  name        = "govuk-${var.aws_environment}-email-alert-api_dbadmin_database_backups-writer-policy"
  policy      = data.aws_iam_policy_document.email-alert-api_dbadmin_database_backups_writer.json
  description = "Allows writing of the email-alert-api DBAdmin database_backups bucket"
}

data "aws_iam_policy_document" "email-alert-api_dbadmin_database_backups_writer" {
  statement {
    sid       = "ReadListOfBuckets"
    actions   = ["s3:ListAllMyBuckets"]
    resources = ["*"]
  }

  statement {
    sid       = "EmailAlertAPIDBAdminReadBucketLists"
    actions   = ["s3:ListBucket", "s3:GetBucketLocation"]
    resources = [aws_s3_bucket.main.arn]
    condition {
      test     = "StringLike"
      variable = "s3:prefix"
      values   = ["mysql", "postgres"]
    }
  }

  statement {
    sid       = "EmailAlertAPIDBAdminWriteGovukDatabaseBackups"
    actions   = ["s3:PutObject", "s3:GetObject", "s3:DeleteObject"]
    resources = ["${aws_s3_bucket.main.arn}/*email-alert-api*"]
  }
}
