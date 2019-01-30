/**
* ## Module: govuk-repo-mirror
*
* Configures a user and role to allow the govuk-repo-mirror CI task
* to push to AWS CodeCommit (the user is used by the existing Jenkins
* job and the role is used by the new Concourse job)
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

variable "jenkins_ssh_public_key" {
  type        = "string"
  description = "The SSH public key of the Jenkins instance for the relevant environment"
}

terraform {
  backend          "s3"             {}
  required_version = "= 0.11.7"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "1.40.0"
}

resource "aws_iam_user" "govuk_codecommit_user" {
  name = "govuk-${var.aws_environment}-govuk-code-commit-user"
}

resource "aws_iam_user_policy_attachment" "govuk_codecommit_user_policy_attachment" {
  user       = "${aws_iam_user.govuk_codecommit_user.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitPowerUser"
}

resource "aws_iam_user_ssh_key" "govuk_codecommit_user_jenkins_ssh_key" {
  username   = "${aws_iam_user.govuk_codecommit_user.name}"
  encoding   = "SSH"
  public_key = "${var.jenkins_ssh_public_key}"
}

resource "aws_iam_role" "govuk_concourse_codecommit_role" {
  name = "govuk-concourse-codecommit-role"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "arn:aws:iam::047969882937:role/cd-govuk-tools-concourse-worker"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "govuk_concourse_codecommit_role_policy_attachment" {
  role       = "${aws_iam_user.govuk_concourse_codecommit_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitPowerUser"
}
