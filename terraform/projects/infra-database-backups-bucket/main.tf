terraform {
  backend "s3" {}
  required_version = "~> 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

locals {
  tags = {
    terraform_deployment = basename(abspath(path.root))
    aws_environment      = var.aws_environment
  }
  timelock_enabled = var.aws_environment == "production"
  timelock_days    = 120
}

provider "aws" {
  region = "eu-west-1"
  default_tags { tags = local.tags }
}

provider "aws" {
  alias  = "eu-west-2"
  region = "eu-west-2"
  default_tags { tags = local.tags }
}

resource "aws_s3_bucket" "main" {
  bucket              = "govuk-${var.aws_environment}-database-backups"
  object_lock_enabled = local.timelock_enabled
  tags                = { Name = "govuk-${var.aws_environment}-database-backups" }
}

resource "aws_s3_bucket" "replica" {
  bucket              = "govuk-${var.aws_environment}-database-backups-replica"
  provider            = aws.eu-west-2
  object_lock_enabled = local.timelock_enabled
  tags                = { Name = "govuk-${var.aws_environment}-database-backups-replica" }
}

resource "aws_s3_bucket_object_lock_configuration" "main" {
  count = local.timelock_enabled ? 1 : 0

  bucket = aws_s3_bucket.main.id
  rule {
    default_retention {
      mode = "COMPLIANCE"
      days = local.timelock_days
    }
  }
}

resource "aws_s3_bucket_object_lock_configuration" "replica" {
  count = local.timelock_enabled ? 1 : 0

  bucket   = aws_s3_bucket.replica.id
  provider = aws.eu-west-2
  rule {
    default_retention {
      mode = "COMPLIANCE"
      days = local.timelock_days
    }
  }
}

resource "aws_s3_bucket_public_access_block" "main" {
  bucket                  = aws_s3_bucket.main.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "replica" {
  bucket                  = aws_s3_bucket.replica.id
  provider                = aws.eu-west-2
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_logging" "main" {
  bucket        = aws_s3_bucket.main.id
  target_bucket = "govuk-${var.aws_environment}-aws-logging"
  target_prefix = "s3/govuk-${var.aws_environment}-database-backups/"
}

resource "aws_s3_bucket_logging" "replica" {
  bucket        = aws_s3_bucket.replica.id
  provider      = aws.eu-west-2
  target_bucket = "govuk-${var.aws_environment}-aws-secondary-logging"
  target_prefix = "s3/govuk-${var.aws_environment}-database-backups-replica/"
}

resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_versioning" "replica" {
  bucket   = aws_s3_bucket.replica.id
  provider = aws.eu-west-2
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_lifecycle_configuration" "main" {
  bucket = aws_s3_bucket.main.id
  rule {
    id     = "production"
    status = var.aws_environment == "production" ? "Enabled" : "Disabled"
    filter {}
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    transition {
      days          = 60
      storage_class = "GLACIER"
    }
    expiration { days = 120 }
    noncurrent_version_expiration { noncurrent_days = 1 }
  }
  rule {
    id     = "non-production"
    status = var.aws_environment != "production" ? "Enabled" : "Disabled"
    filter {}
    expiration { days = 2 }
    noncurrent_version_expiration { noncurrent_days = 1 }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "replica" {
  bucket   = aws_s3_bucket.replica.id
  provider = aws.eu-west-2
  rule {
    id     = "production"
    status = var.aws_environment == "production" ? "Enabled" : "Disabled"
    filter {}
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    transition {
      days          = 60
      storage_class = "GLACIER"
    }
    expiration { days = 120 }
    noncurrent_version_expiration { noncurrent_days = 1 }
  }
  rule {
    id     = "non-production"
    status = var.aws_environment != "production" ? "Enabled" : "Disabled"
    filter {}
    expiration { days = 2 }
    noncurrent_version_expiration { noncurrent_days = 1 }
  }
}

resource "aws_s3_bucket_replication_configuration" "main" {
  depends_on = [aws_s3_bucket_versioning.main] # TF doesn't infer this :(

  bucket = aws_s3_bucket.main.id
  role   = aws_iam_role.replication.arn

  rule {
    id       = "replicate-db-backups-out-of-region"
    priority = 10
    status   = var.aws_environment == "production" ? "Enabled" : "Disabled"
    delete_marker_replication { status = "Disabled" }
    destination {
      bucket        = aws_s3_bucket.replica.arn
      storage_class = "STANDARD_IA"
    }
    filter {}
  }
}

data "aws_iam_policy_document" "s3_can_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "replication" {
  name               = "database-backups-s3-replication"
  assume_role_policy = data.aws_iam_policy_document.s3_can_assume_role.json
}

data "aws_iam_policy_document" "replication" {
  statement {
    sid = "ReplicateFromSourceBucket"
    actions = [
      "s3:ListBucket",
      "s3:GetObject*",
      "s3:GetReplicationConfiguration",
    ]
    resources = [aws_s3_bucket.main.arn, "${aws_s3_bucket.main.arn}/*"]
  }
  statement {
    sid       = "ReplicateToDestinationBuckets"
    actions   = ["s3:ObjectOwnerOverrideToBucketOwner", "s3:Replicate*"]
    resources = ["${aws_s3_bucket.replica.arn}/*"]
  }
}

resource "aws_iam_policy" "replication" {
  name        = "db-backup-s3-replication"
  policy      = data.aws_iam_policy_document.replication.json
  description = "Allow S3 to replicate the database backup bucket out-of-region."
}

resource "aws_iam_role_policy_attachment" "replication" {
  role       = aws_iam_role.replication.name
  policy_arn = aws_iam_policy.replication.arn
}
