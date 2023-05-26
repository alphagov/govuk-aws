/**
* ## Project: infra-assets
*
* Stores ActiveStorage blobs uploaded via Content Publisher.
*/

terraform {
  backend "s3" {}

  required_version = "~> 1.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.9"
    }
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      terraform_deployment = basename(abspath(path.root))
      aws_environment      = var.aws_environment
    }
  }
}

provider "aws" {
  region = var.aws_backup_region
  alias  = "backup"
}

resource "aws_s3_bucket" "assets" {
  bucket = "govuk-assets-${var.aws_environment}"
  tags = {
    Name = "govuk-assets-${var.aws_environment}"
  }
}

resource "aws_s3_bucket_versioning" "assets" {
  bucket = aws_s3_bucket.assets.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_replication_configuration" "assets" {
  count      = var.aws_environment == "production" ? 1 : 0
  depends_on = [aws_s3_bucket_versioning.assets] # TF doesn't infer this :(

  bucket = aws_s3_bucket.assets.id
  role   = aws_iam_role.backup[0].arn

  rule {
    id       = "govuk-${var.aws_environment}-assets-replication-rule"
    priority = 10
    status   = "Enabled"
    delete_marker_replication { status = "Disabled" }
    destination {
      bucket        = aws_s3_bucket.assets_backup[0].arn
      storage_class = "STANDARD"
    }
    filter {}
  }
}

resource "aws_s3_bucket_logging" "assets" {
  bucket        = aws_s3_bucket.assets.id
  target_bucket = data.terraform_remote_state.infra_monitoring.outputs.aws_logging_bucket_id
  target_prefix = "s3/govuk-assets-${var.aws_environment}/"
}


resource "aws_iam_user" "app_user" {
  name = "govuk-assets-${var.aws_environment}-user"
}

resource "aws_iam_policy" "s3_writer" {
  name = "govuk-${var.aws_environment}-assets-s3-writer-policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket",
          "s3:ListAllMyBuckets",
          "s3:GetBucketLocation",
        ],
        "Resource" : ["arn:aws:s3:::*"],
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject",
          "s3:DeleteObject",
        ],
        "Resource" : [
          "arn:aws:s3:::${aws_s3_bucket.assets.id}",
          "arn:aws:s3:::${aws_s3_bucket.assets.id}/*",
        ],
      },
    ],
  })
}

resource "aws_iam_policy_attachment" "s3_writer" {
  name       = "govuk-${var.aws_environment}-assets-s3-writer-policy-attachment"
  users      = [aws_iam_user.app_user.name]
  policy_arn = aws_iam_policy.s3_writer.arn
}
