resource "aws_iam_policy" "asset_manager_env_sync_s3_writer" {
  name   = "govuk-${var.aws_environment}-asset-manager-env-sync-s3-writer-policy"
  policy = "${data.template_file.asset_manager_env_sync_s3_writer_policy_template.rendered}"
}

resource "aws_iam_policy_attachment" "asset_manager_env_sync_s3_writer" {
  name       = "govuk-${var.aws_environment}-asset-manager-env-sync-s3-writer-policy-attachment"
  users      = ["${aws_iam_user.env_sync_and_backup.name}"]
  policy_arn = "${aws_iam_policy.asset_manager_env_sync_s3_writer.arn}"
}

data "template_file" "asset_manager_env_sync_s3_writer_policy_template" {
  template = "${file("s3_assets_sync_policy.tpl")}"
}
