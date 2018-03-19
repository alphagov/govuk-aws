/**
* ## Project: static-assets-bucket
*
* Create a policy that allows writing of the static-assets-bucket bucket. This
* doesn't create a role as the calling instance is assumed to already
* have one which should be attached to this policy.
*
*/

resource "aws_iam_policy" "static_assets_writer" {
  name        = "govuk-${var.aws_environment}-static_assets-writer-policy"
  policy      = "${data.aws_iam_policy_document.static_assets_writer.json}"
  description = "Allows writing of the static_assets bucket"
}

data "aws_iam_policy_document" "static_assets_writer" {
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
    sid     = "WriteGovukStaticAssets"
    actions = ["s3:*"]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.static_assets.id}",
      "arn:aws:s3:::${aws_s3_bucket.static_assets.id}/*",
    ]
  }
}

output "write_static_assets_bucket_policy_arn" {
  value       = "${aws_iam_policy.static_assets_writer.arn}"
  description = "ARN of the write static_assets-bucket policy"
}
