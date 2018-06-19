/**
* ## Project: database-backups-bucket
*
* Create a policy that allows writing of the database-backups bucket. This
* doesn't create a role as the calling instance is assumed to already
* have one which should be attached to this policy.
*
*/

resource "aws_iam_policy" "database_backups_writer" {
  name        = "govuk-${var.aws_environment}-database_backups-writer-policy"
  policy      = "${data.aws_iam_policy_document.database_backups_writer.json}"
  description = "Allows writing of the database_backups bucket"
}

data "aws_iam_policy_document" "database_backups_writer" {
  statement {
    sid = "ReadBucketLists"

    actions = [
      "s3:ListBucket",
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation",
    ]

    # In theory  should work but it doesn't so use * instead
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.database_backups.id}",
    ]
  }

  statement {
    sid = "WriteGovukDatabaseBackups"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.database_backups.id}/*",
    ]
  }
}

output "write_database_backups_bucket_policy_arn" {
  value       = "${aws_iam_policy.database_backups_writer.arn}"
  description = "ARN of the write database_backups-bucket policy"
}
