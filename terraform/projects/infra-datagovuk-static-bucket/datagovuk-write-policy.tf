data "aws_iam_policy_document" "s3_datagovuk_writer_policy_doc" {
  statement {
    sid = "S3SyncReadLists"

    actions = [
      "s3:GetBucketLocation",
      "s3:ListAllMyBuckets",
    ]

    resources = [
      "arn:aws:s3:::*",
    ]
  }

  statement {
    sid     = "S3SyncReadWriteBucket"
    actions = ["s3:*"]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.datagovuk-static.id}",
      "arn:aws:s3:::${aws_s3_bucket.datagovuk-static.id}/*",
    ]
  }
}

resource "aws_iam_policy" "s3_datagovuk_writer_policy" {
  name   = "s3_datagovuk_writer_policy_for_${aws_s3_bucket.datagovuk-static.id}"
  policy = "${data.aws_iam_policy_document.s3_datagovuk_writer_policy_doc.json}"
}

resource "aws_iam_user" "s3_datagovuk_writer_user" {
  name = "s3_datagovuk_writer"
}

resource "aws_iam_policy_attachment" "s3_datagovuk_writer_user_policy" {
  name       = "s3_datagovuk_writers_user_policy_attachment"
  users      = ["${aws_iam_user.s3_datagovuk_writer_user.name}"]
  policy_arn = "${aws_iam_policy.s3_datagovuk_writer_policy.arn}"
}
