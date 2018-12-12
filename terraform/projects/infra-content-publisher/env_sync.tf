resource "aws_s3_bucket_policy" "cross_account_access" {
  count  = "${var.aws_environment != "production" ? 1 : 0}"
  bucket = "${aws_s3_bucket.activestorage.id}"
  policy = "${data.aws_iam_policy_document.cross_account_access.json}"
}

data "aws_iam_policy_document" "cross_account_access" {
  statement {
    effect = "Allow"

    principals = {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::210287912431:root",
        "arn:aws:iam::696911096973:root",
        "arn:aws:iam::172025368201:root",
        "arn:aws:iam::430354129336:root",
      ]
    }

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.activestorage.id}",
    ]
  }

  statement {
    effect = "Allow"

    principals = {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::210287912431:root",
        "arn:aws:iam::696911096973:root",
        "arn:aws:iam::172025368201:root",
        "arn:aws:iam::430354129336:root",
      ]
    }

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.activestorage.id}/*",
    ]
  }
}
