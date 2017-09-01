# == Manifest: projects:: wraith-bucket :: writer
#
# Create a user that has full read/write access to the wraith bucket. Access
# keys will need to be generated separately via the UI.
#
# This doesn't create a role as the calling instance is assumed to already
# have one which should be attached to this policy.
#
# === Variables:
#
# === Outputs:
#
# write_wraith_bucket_policy_arn
#

resource "aws_iam_user" "wraith_writer" {
  name = "govuk-${var.aws_environment}-wraith-writer"
}

resource "aws_iam_policy" "wraith_writer" {
  name        = "govuk-${var.aws_environment}-wraith-writer-policy"
  policy      = "${data.aws_iam_policy_document.wraith_writer.json}"
  description = "Allows writing of the wraith bucket"
}

resource "aws_iam_policy_attachment" "wraith_writer" {
  name       = "wraith-writer-policy-attachment"
  users      = ["${aws_iam_user.wraith_writer.name}"]
  policy_arn = "${aws_iam_policy.wraith_writer.arn}"
}

data "aws_iam_policy_document" "wraith_writer" {
  statement {
    sid = "ReadBucketLists"

    actions = [
      "s3:ListBucket",
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation",
    ]

    resources = [
      "arn:aws:s3:::*",
    ]
  }

  statement {
    sid     = "WriteGovukWraith"
    actions = ["s3:*"]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.wraith.id}",
      "arn:aws:s3:::${aws_s3_bucket.wraith.id}/*",
    ]
  }
}

output "write_wraith_bucket_policy_arn" {
  value       = "${aws_iam_policy.wraith_writer.arn}"
  description = "ARN of the write wraith-bucket policy"
}
