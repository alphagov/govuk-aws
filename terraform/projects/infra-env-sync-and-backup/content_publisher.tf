resource "aws_iam_policy" "content_publisher_env_sync_s3_writer" {
  name   = "govuk-${var.aws_environment}-content-publisher-env-sync-s3-writer-policy"
  policy = data.template_file.content_publisher_env_sync_s3_writer_policy_template.rendered
}

resource "aws_iam_policy_attachment" "content_publisher_env_sync_s3_writer" {
  name       = "govuk-${var.aws_environment}-content-publisher-env-sync-s3-writer-policy-attachment"
  users      = ["${aws_iam_user.env_sync_and_backup.name}"]
  policy_arn = aws_iam_policy.content_publisher_env_sync_s3_writer.arn
}

data "template_file" "content_publisher_env_sync_s3_writer_policy_template" {
  template = file("s3_sync_policy.tpl")

  vars = {
    bucket_suffix = "content-publisher-activestorage"
  }
}
