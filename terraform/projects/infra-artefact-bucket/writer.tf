# == Manifest: projects:: Artefact-bucket :: writer
#
# Create a policy that allows writing of the artefacts bucket. This
# doesn't create a role as the calling instance is assumed to already
# have one which should be attached to this policy.
#
# This does create a user that can be used by external services (e.g. from
# deploy in Carrenza).
#
# === Variables:
#
# === Outputs:
#
# write_artefact_bucket_policy_arn
#

resource "aws_iam_policy" "artefact_writer" {
  name        = "govuk-${var.aws_environment}-artefact-writer-policy"
  policy      = "${data.aws_iam_policy_document.artefact_writer.json}"
  description = "Allows writing of the artefacts bucket"
}

resource "aws_iam_user" "artefact_writer" {
  name = "govuk-${var.aws_environment}-artefact-writer"
}

resource "aws_iam_policy_attachment" "artefact_writer" {
  name       = "artefact-writer-policy-attachment"
  users      = ["${aws_iam_user.artefact_writer.name}"]
  policy_arn = "${aws_iam_policy.artefact_writer.arn}"
}

data "aws_iam_policy_document" "artefact_writer" {
  statement {
    sid = "ReadBucketLists"

    actions = [
      "s3:ListBucket",
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation",
    ]

    # In theory  should work but it doesn't so use * instead
    resources = [
      "arn:aws:s3:::*",
    ]
  }

  statement {
    sid     = "WriteGovukArtefact"
    actions = ["s3:*"]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.artefact.id}",
      "arn:aws:s3:::${aws_s3_bucket.artefact.id}/*",
    ]
  }
}

output "write_artefact_bucket_policy_arn" {
  value       = "${aws_iam_policy.artefact_writer.arn}"
  description = "ARN of the write artefact-bucket policy"
}
