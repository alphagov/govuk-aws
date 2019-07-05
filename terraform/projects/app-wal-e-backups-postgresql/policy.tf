data "aws_iam_policy_document" "readwrite_policy" {
  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:ListBucketMultipartUploads",
      "s3:ListBucketVersions",
    ]

    effect = "Allow"

    resources = [
      "arn:aws:s3:::${var.bucket_name}-${var.aws_environment}",
    ]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:GetObjectACL",
      "s3:GetObjectVersion",
      "s3:PutObject",
      "s3:PutObjectACL",
      "S3:DeleteObject",
      "s3:AbortMultipartUpload",
      "s3:ListMultipartUploadParts",
    ]

    effect = "Allow"

    resources = [
      "arn:aws:s3:::${var.bucket_name}-${var.aws_environment}/*",
    ]
  }
}
