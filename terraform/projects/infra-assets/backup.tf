resource "aws_s3_bucket" "assets_backup" {
  provider = aws.backup
  bucket   = "govuk-assets-backup-${var.aws_environment}"
}

resource "aws_s3_bucket_versioning" "assets_backup" {
  provider = aws.backup
  bucket   = aws_s3_bucket.assets_backup.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_iam_policy" "backup" {
  name   = "govuk-${var.aws_environment}-assets-backup-policy"
  policy = data.template_file.backup_policy.rendered
}

resource "aws_iam_role" "backup" {
  name = "govuk-${var.aws_environment}-assets-backup"

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
  name       = "govuk-${var.aws_environment}-backup-policy-attachment"
  roles      = [aws_iam_role.backup.name]
  policy_arn = aws_iam_policy.backup.arn
}

data "template_file" "backup_policy" {
  template = file("backup_policy.tpl")

  vars = {
    src_bucket = aws_s3_bucket.assets.id
    dst_bucket = aws_s3_bucket.assets_backup.id
  }
}
