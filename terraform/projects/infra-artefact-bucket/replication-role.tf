# == Manifest: projects:: Artefact-bucket :: replication-role
#
# Creates a role with attached policy to enable replication of the
# artefacts bucket.
#
# === Variables:
#
# === Outputs:
#

resource "aws_iam_role" "artefact_replication" {
  name               = "govuk-${var.aws_environment}-artefact-replication-role"
  description        = "Allows replication of the artefacts bucket"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role.json}"
}

resource "aws_iam_policy" "artefact_replication" {
  name        = "govuk-${var.aws_environment}-artefact-replication-policy"
  policy      = "${data.aws_iam_policy_document.artefact_replication.json}"
  description = "Allows replication of the artefacts bucket"
}

resource "aws_iam_policy_attachment" "artefact_replication" {
  name       = "govuk-${var.aws_environment}-artefact-replication-policy-attachment"
  roles      = ["${aws_iam_role.artefact_replication.name}"]
  policy_arn = "${aws_iam_policy.artefact_replication.arn}"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "artefact_replication" {
  statement {
    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket",
    ]

    resources = ["${aws_s3_bucket.artefact.arn}"]
  }

  statement {
    actions = [
      "s3:GetObjectVersion",
      "s3:GetObjectVersionAcl",
    ]

    resources = [
      "${aws_s3_bucket.artefact.arn}/*",
    ]
  }

  statement {
    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
    ]

    resources = ["${aws_s3_bucket.artefact_replication_destination.arn}/*"]
  }
}
