/**
* ## Module: govuk-repo-mirror
*
* Configures a user and role to allow the "Mirror GitHub repositories"
* Jenkins job to push to AWS CodeCommit. See
* See https://deploy.integration.publishing.service.gov.uk/job/Mirror_Github_Repositories/
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

variable "govuk_repo_mirror_user_ssh_public_key" {
  type        = "string"
  description = "The SSH public key of the govuk-repo-mirror-user user in AWS"
}

variable "jenkins_role_arn" {
  type        = "string"
  description = "The role ARN of the role that Jenkins uses to assume the govuk_jenkins_codecommit_role role"
}

terraform {
  backend          "s3"             {}
  required_version = "= 0.11.15"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "2.46.0"
}

resource "aws_iam_user" "govuk_codecommit_user" {
  name = "govuk-repo-mirror-user"
}

resource "aws_iam_user_policy_attachment" "govuk_codecommit_user_policy_attachment" {
  user       = "${aws_iam_user.govuk_codecommit_user.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitPowerUser"
}

resource "aws_iam_user_ssh_key" "govuk_repo_mirror_user_ssh_public_key" {
  username   = "${aws_iam_user.govuk_codecommit_user.name}"
  encoding   = "SSH"
  public_key = "${var.govuk_repo_mirror_user_ssh_public_key}"
}

resource "aws_iam_role" "govuk_jenkins_codecommit_role" {
  name = "govuk-repo-mirror-role"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "${var.jenkins_role_arn}"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "govuk_jenkins_codecommit_role_policy_attachment" {
  role       = "${aws_iam_role.govuk_jenkins_codecommit_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitPowerUser"
}
