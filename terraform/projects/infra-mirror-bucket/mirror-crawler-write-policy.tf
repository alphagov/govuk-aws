variable "remote_state_app_mirrorer_key_stack" {
  type        = string
  description = "stackname path to app_mirrorer remote state "
  default     = ""
}

variable "app_mirrorer_stackname" {
  type        = string
  description = "Stackname of the app mirrorer"
}

# Resources
# --------------------------------------------------------------

data "terraform_remote_state" "app_mirrorer" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket
    key    = "${coalesce(var.remote_state_app_mirrorer_key_stack, var.app_mirrorer_stackname)}/app-mirrorer.tfstate"
    region = var.aws_replica_region
  }
}

data "aws_iam_policy_document" "s3_mirrors_crawler_writer_policy_doc" {
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
      "arn:aws:s3:::${aws_s3_bucket.govuk-mirror.id}",
      "arn:aws:s3:::${aws_s3_bucket.govuk-mirror.id}/*",
    ]
  }
}

resource "aws_iam_policy" "s3_mirrors_writer_policy" {
  name   = "s3_mirrors_writer_policy_for_${aws_s3_bucket.govuk-mirror.id}"
  policy = data.aws_iam_policy_document.s3_mirrors_crawler_writer_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "s3_mirrors_writer_user_policy" {
  policy_arn = aws_iam_policy.s3_mirrors_writer_policy.arn
  role       = data.terraform_remote_state.app_mirrorer.instance_iam_role_name
}
