resource "aws_s3_bucket" "assets_backup" {
  count    = var.aws_environment == "production" ? 1 : 0
  provider = aws.backup
  bucket   = "govuk-assets-backup-${var.aws_environment}"
}

resource "aws_s3_bucket_versioning" "assets_backup" {
  count    = var.aws_environment == "production" ? 1 : 0
  provider = aws.backup
  bucket   = aws_s3_bucket.assets_backup[0].id
  versioning_configuration { status = "Enabled" }
}

resource "aws_iam_policy" "backup" {
  count  = var.aws_environment == "production" ? 1 : 0
  name   = "govuk-${var.aws_environment}-assets-backup-policy"
  policy = data.template_file.backup_policy[0].rendered
}

resource "aws_iam_role" "backup" {
  count = var.aws_environment == "production" ? 1 : 0
  name  = "govuk-${var.aws_environment}-assets-backup"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": { "Service": "s3.amazonaws.com" },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_policy_attachment" "backup" {
  count      = var.aws_environment == "production" ? 1 : 0
  name       = "govuk-${var.aws_environment}-backup-policy-attachment"
  roles      = [aws_iam_role.backup[0].name]
  policy_arn = aws_iam_policy.backup[0].arn
}

data "template_file" "backup_policy" {
  count    = var.aws_environment == "production" ? 1 : 0
  template = file("backup_policy.tpl")

  vars = {
    src_bucket = aws_s3_bucket.assets.id
    dst_bucket = aws_s3_bucket.assets_backup[0].id
  }
}
