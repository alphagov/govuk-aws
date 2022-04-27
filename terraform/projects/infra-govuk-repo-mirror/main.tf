/**
* ## Module: govuk-repo-mirror
*
* Configures:
* 1. an IAM role to allow the `mirror_github_repositories` Jenkins job
*    in Integration to mirror the GOV.UK GitHub repositories to AWS CodeCommit in
*    Tools
* 2. an IAM user with SSH authorized keys from Jenkins in Integration, Staging and
*    Production to access to AWS CodeCommit in Tools to deploy applications
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

variable "jenkins_carrenza_staging_ssh_public_key" {
  type        = "string"
  description = "The SSH public key of the Jenkins instance in the Carrenza staging environment"
}

variable "jenkins_carrenza_production_ssh_public_key" {
  type        = "string"
  description = "The SSH public key of the Jenkins instance in the Carrenza production environment"
}

variable "integration_jenkins_role_arn" {
  type        = "string"
  description = "ARN of the role that Jenkins uses to assume the govuk_codecommit_poweruser role"
}

# Resources
# --------------------------------------------------------------

terraform {
  backend          "s3"             {}
  required_version = "= 0.11.15"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "2.46.0"
}

resource "aws_iam_user" "govuk_codecommit_user" {
  name = "govuk-${var.aws_environment}-govuk-code-commit-user"
}

resource "aws_iam_user_policy_attachment" "govuk_codecommit_user_policy_attachment" {
  user       = "${aws_iam_user.govuk_codecommit_user.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitPowerUser"
}

resource "aws_iam_user_ssh_key" "govuk_codecommit_user_jenkins_staging_ssh_key" {
  username   = "${aws_iam_user.govuk_codecommit_user.name}"
  encoding   = "SSH"
  public_key = "${var.jenkins_carrenza_staging_ssh_public_key}"
}

resource "aws_iam_user_ssh_key" "govuk_codecommit_user_jenkins_production_ssh_key" {
  username   = "${aws_iam_user.govuk_codecommit_user.name}"
  encoding   = "SSH"
  public_key = "${var.jenkins_carrenza_production_ssh_public_key}"
}

resource "aws_iam_user" "govuk_concourse_codecommit_user" {
  name = "govuk-concourse-codecommit-user"
}

resource "aws_iam_user_policy_attachment" "govuk_concourse_codecommit_user_policy_attachment" {
  user       = "${aws_iam_user.govuk_concourse_codecommit_user.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitPowerUser"
}

resource "aws_iam_user_ssh_key" "govuk_concourse_codecommit_staging_user_ssh_key" {
  username   = "${aws_iam_user.govuk_concourse_codecommit_user.name}"
  encoding   = "SSH"
  public_key = "${var.jenkins_carrenza_staging_ssh_public_key}"
}

resource "aws_iam_user_ssh_key" "govuk_concourse_codecommit_production_user_ssh_key" {
  username   = "${aws_iam_user.govuk_concourse_codecommit_user.name}"
  encoding   = "SSH"
  public_key = "${var.jenkins_carrenza_production_ssh_public_key}"
}

resource "aws_iam_role" "govuk_codecommit_poweruser" {
  name = "govuk-codecommit-poweruser"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "${var.integration_jenkins_role_arn}"
      },
      "Effect": "Allow",
      "Sid": "AllowJenkinsAssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "govuk_codecommit_poweruser_policy_attachment" {
  role       = "${aws_iam_role.govuk_codecommit_poweruser.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitPowerUser"
}
