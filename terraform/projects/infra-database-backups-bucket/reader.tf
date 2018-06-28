/**
* ## Project: database-backups-bucket
*
* Create a policy that allows listing and reading of the database-backups bucket.
*
*/

resource "aws_iam_policy" "database_backups_reader" {
  name        = "govuk-${var.aws_environment}-database_backups-reader-policy"
  policy      = "${data.aws_iam_policy_document.database_backups_reader.json}"
  description = "Allows reading of the database_backups bucket"
}

data "aws_iam_policy_document" "database_backups_reader" {
  statement {
    sid     = "CrossAccountPermissions"
    effect  = "Allow"
    actions = ["s3:Get*", "s3:List*"]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.database_backups.id}",
      "arn:aws:s3:::${aws_s3_bucket.database_backups.id}/mongo-api/*",
    ]

    condition {
      variable = "ArnEquals"
      test     = "StringEquals"

      values = [
        "arn:aws:iam::210287912431:root",
        "arn:aws:iam::696911096973:root",
        "arn:aws:iam::172025368201:root",
      ]
    }
  }

  statement {
    sid     = "AllowExternalRole"
    effect  = "Allow"
    actions = ["s3:Get*", "s3:List*"]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.database_backups.id}",
      "arn:aws:s3:::${aws_s3_bucket.database_backups.id}/mongo-api/*",
    ]

    condition {
      variable = "ArnEquals"
      test     = "StringEquals"

      values = [
        "arn:aws:iam::696911096973:role/blue-deploy",
        "arn:aws:iam::210287912431:role/blue-deploy",
      ]
    }
  }
}
