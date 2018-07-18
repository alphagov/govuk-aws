/**
* ## Module: govuk-repo-mirror
*
* Configures a user to allow the govuk-repo-mirror CI task
* to push to AWS CodeCommit
*/
variable "aws_region" {
  type        = "string"
  description = "AWS region"
  default     = "eu-west-1"
}

variable "aws_environment" {
  type        = "string"
  description = "AWS Environment"
}

variable "stackname" {
  type        = "string"
  description = "Stackname"
}

terraform {
  backend          "s3"             {}
  required_version = "= 0.11.7"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "1.27.0"
}

resource "aws_iam_user" "govuk_code_commit_user" {
  name = "govuk-${var.aws_environment}-govuk-code-commit-user"
}

resource "aws_iam_user_policy_attachment" "committer_managed_policy" {
  user       = "${aws_iam_user.govuk_code_commit_user.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitPowerUser"
}
