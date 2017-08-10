# == Manifest: projects:: Artefact-bucket :: reader
#
# Create a policy that allows reading of the artefacts bucket. This
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
# read_artefact_bucket_policy_arn
#

resource "aws_iam_policy" "artefact_reader" {
  name        = "govuk-${var.aws_environment}-artefact-reader-policy"
  policy      = "${data.aws_iam_policy_document.artefact_reader.json}"
  description = "Allows reading of the artefacts bucket"
}

resource "aws_iam_user" "artefact_reader" {
  name = "govuk-${var.aws_environment}-artefact-reader"
}

resource "aws_iam_policy_attachment" "artefact_reader" {
  name       = "artefact-reader-policy-attachment"
  users      = ["${aws_iam_user.artefact_reader.name}"]
  policy_arn = "${aws_iam_policy.artefact_reader.arn}"
}

data "aws_iam_policy_document" "artefact_reader" {
  statement {
    sid     = "ReadGovukArtefact"
    actions = ["s3:GetObject"]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.artefact.id}",
      "arn:aws:s3:::${aws_s3_bucket.artefact.id}/*",
    ]
  }
}

output "read_artefact_bucket_policy_arn" {
  value       = "${aws_iam_policy.artefact_reader.arn}"
  description = "ARN of the read artefact-bucket policy"
}
