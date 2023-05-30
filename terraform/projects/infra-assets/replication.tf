# govuk-assets-production replicates to:
#   govuk-assets-backup-production (same account, different region, supposed to be a backup)
#   govuk-assets-staging (different account, objects owned by destination account)
#   govuk-assets-integration (different account, objects owned by destination account)
#
# See:
# https://docs.aws.amazon.com/AmazonS3/latest/userguide/setting-repl-config-perm-overview
# https://docs.aws.amazon.com/AmazonS3/latest/userguide/delete-marker-replication
# https://docs.aws.amazon.com/AmazonS3/latest/userguide/replication-change-owner
#
# TODO: govuk-assets-backup-production should really have timelock (AWS "Object
# Lock") or similar to properly serve as a backup.

locals {
  replication_role_name                    = "govuk-production-assets-s3-replication"
  replication_service_role_in_prod_account = "arn:aws:iam::172025368201:role/${local.replication_role_name}"
}

resource "aws_s3_bucket_replication_configuration" "assets" {
  count      = var.aws_environment == "production" ? 1 : 0
  depends_on = [aws_s3_bucket_versioning.assets] # TF doesn't infer this :(

  bucket = aws_s3_bucket.assets.id
  role   = aws_iam_role.replication[0].arn

  rule {
    id       = "prod-assets-to-prod-backup"
    priority = 10
    status   = "Enabled"
    delete_marker_replication { status = "Enabled" }
    destination { bucket = aws_s3_bucket.assets_backup[0].arn }
    filter {}
  }
  rule {
    id       = "prod-assets-to-staging"
    priority = 20
    status   = "Enabled"
    delete_marker_replication { status = "Enabled" }
    destination {
      account = "696911096973"
      bucket  = "arn:aws:s3:::govuk-assets-staging"
      access_control_translation { owner = "Destination" }
    }
    filter {}
  }
  rule {
    id       = "prod-assets-to-integration"
    priority = 30
    status   = "Enabled"
    delete_marker_replication { status = "Enabled" }
    destination {
      account = "210287912431"
      bucket  = "arn:aws:s3:::govuk-assets-integration"
      access_control_translation { owner = "Destination" }
    }
    filter {}
  }
}

resource "aws_iam_role" "replication" {
  count       = var.aws_environment == "production" ? 1 : 0
  name        = local.replication_role_name
  description = "Service role for S3 replication of govuk-assets-production to staging/integration and to govuk-assets-backup-production."
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { "Service" = "s3.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "replicate_production_assets" {
  count      = var.aws_environment == "production" ? 1 : 0
  role       = aws_iam_role.replication[0].name
  policy_arn = aws_iam_policy.replicate_production_assets[0].arn
}

resource "aws_iam_policy" "replicate_production_assets" {
  count  = var.aws_environment == "production" ? 1 : 0
  name   = "ReplicateProductionAssets"
  policy = data.aws_iam_policy_document.replicate_production_assets.json
}

data "aws_iam_policy_document" "replicate_production_assets" {
  statement {
    sid = "ReadSourceBucketReplicationConfig"
    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket", # For reading deletion markers.
    ]
    resources = ["arn:aws:s3:::${aws_s3_bucket.assets.id}"]
  }
  statement {
    sid       = "ReadSourceBucketObjectMetadataForReplication"
    actions   = ["s3:GetObjectVersion*"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.assets.id}/*"]
  }
  statement {
    sid = "ReplicateObjectsToDestinationBuckets"
    actions = [
      "s3:GetObjectVersionTagging",
      "s3:ObjectOwnerOverrideToBucketOwner",
      "s3:Replicate*",
    ]
    resources = [
      "arn:aws:s3:::govuk-assets-backup-production/*",
      "arn:aws:s3:::govuk-assets-staging/*",
      "arn:aws:s3:::govuk-assets-integration/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "assets_nonprod_replica" {
  count  = var.aws_environment != "production" ? 1 : 0
  bucket = aws_s3_bucket.assets.id
  policy = data.aws_iam_policy_document.bucket_is_cross_account_replication_target.json
}

data "aws_iam_policy_document" "bucket_is_cross_account_replication_target" {
  statement {
    sid = "S3RoleInSourceAccountReplicatesObjectsToDestinationBucket"
    principals {
      type        = "AWS"
      identifiers = [local.replication_service_role_in_prod_account]
    }
    actions = [
      "s3:GetObjectVersionTagging",
      "s3:ObjectOwnerOverrideToBucketOwner",
      "s3:Replicate*",
    ]
    resources = ["arn:aws:s3:::${aws_s3_bucket.assets.id}/*"]
  }
  statement {
    sid = "S3RoleInSourceAccountReplicatesToDestinationBucket"
    principals {
      type        = "AWS"
      identifiers = [local.replication_service_role_in_prod_account]
    }
    actions = [
      "s3:List*",
      "s3:GetBucketVersioning",
      "s3:PutBucketVersioning",
    ]
    resources = ["arn:aws:s3:::${aws_s3_bucket.assets.id}"]
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "assets_prod" {
  count  = var.aws_environment == "production" ? 1 : 0
  bucket = aws_s3_bucket.assets.id
  rule {
    id     = "Clean up incomplete multipart uploads in prod"
    status = "Enabled"
    filter {}
    abort_incomplete_multipart_upload { days_after_initiation = 2 }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "assets_nonprod_replica" {
  count  = var.aws_environment != "production" ? 1 : 0
  bucket = aws_s3_bucket.assets.id
  rule {
    id     = "Discard non-current versions in non-prod replicas"
    status = "Enabled"
    filter {}
    expiration { expired_object_delete_marker = true }
    noncurrent_version_expiration { noncurrent_days = 1 }
    abort_incomplete_multipart_upload { days_after_initiation = 1 }
  }
}
