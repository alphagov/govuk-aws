resource "aws_s3_bucket" "assets_backup" {
  count    = var.aws_environment == "production" ? 1 : 0
  provider = aws.backup
  bucket   = "govuk-assets-backup-production"
}

resource "aws_s3_bucket_versioning" "assets_backup" {
  count    = var.aws_environment == "production" ? 1 : 0
  provider = aws.backup
  bucket   = aws_s3_bucket.assets_backup[0].id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_policy" "assets_backup" {
  count    = var.aws_environment == "production" ? 1 : 0
  provider = aws.backup
  bucket   = aws_s3_bucket.assets_backup[0].id
  policy   = data.aws_iam_policy_document.bucket_is_replication_target[0].json
}

data "aws_iam_policy_document" "bucket_is_replication_target" {
  count = var.aws_environment == "production" ? 1 : 0
  statement {
    sid = "S3RoleInSourceAccountReplicatesObjectsToDestinationBucket"
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.replication[0].arn]
    }
    actions = [
      "s3:GetObjectVersionTagging",
      "s3:Replicate*",
    ]
    resources = ["${aws_s3_bucket.assets_backup[0].arn}/*"]
  }
  statement {
    sid = "S3RoleInSourceAccountReplicatesToDestinationBucket"
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.replication[0].arn]
    }
    actions = [
      "s3:List*",
      "s3:GetBucketVersioning",
      "s3:PutBucketVersioning",
    ]
    resources = [aws_s3_bucket.assets_backup[0].arn]
  }
}
