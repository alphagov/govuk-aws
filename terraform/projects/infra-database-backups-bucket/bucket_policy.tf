/**
* ## Project: database-backups-bucket
*
* Create a policy that allows listing and reading of the database-backups bucket.
*
*/

resource "aws_s3_bucket_policy" "database_backups_cross_account_access" {
  bucket = "${aws_s3_bucket.database_backups.id}"
  policy = "${data.aws_iam_policy_document.database_backups_cross_account_access.json}"
}

data "aws_iam_policy_document" "database_backups_cross_account_access" {
  statement {
    sid     = "CrossAccountPermissions"
    effect  = "Allow"
    actions = ["s3:Get*", "s3:List*"]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.database_backups.id}",
    ]

    principals = {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::210287912431:root",
        "arn:aws:iam::696911096973:root",
        "arn:aws:iam::172025368201:root",
      ]
    }
  }
}
