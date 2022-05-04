/**
* ## Module: govuk-repo-mirror
*
* Configures:
* 1. an IAM role to allow the `mirror_github_repositories` Jenkins job
*    in Production to mirror the GOV.UK GitHub repositories to AWS CodeCommit in
*    Tools
* 2. an IAM user with SSH authorized keys from Jenkins in Integration, Staging and
*    Production to access to AWS CodeCommit in Tools to deploy applications
*/
variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-1"
}

variable "aws_environment" {
  type        = string
  description = "AWS Environment"
}

variable "stackname" {
  type        = string
  description = "Stackname"
}

variable "govuk_codecommit_mirrorer_ssh_key" {
  type        = string
  description = "SSH key of the IAM user used by the GOV.UK repo mirroring script to access Tools AWS CodeCommit"
}

variable "mirrorer_jenkins_role_arn" {
  type        = string
  description = "ARN of the role that Mirrorer Jenkins uses to assume the govuk_codecommit_poweruser role"
}

variable "govuk_environments_ssh_key" {
  type        = list(object({ environment = string, ssh_key = string }))
  description = "Map of govuk-environment:ssh_key used to define a GOV.UK environment Jenkins access to AWS CodeCommit"
}


# Resources
# --------------------------------------------------------------

terraform {
  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.1.9"
}

provider "aws" {
  region = var.aws_region
}


// Allow Jenkins job to mirror GitHub repositories to AWS CodeCommit

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
        "AWS": "${var.mirrorer_jenkins_role_arn}"
      },
      "Effect": "Allow",
      "Sid": "AllowJenkinsAssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "govuk_codecommit_poweruser_policy_attachment" {
  role       = aws_iam_role.govuk_codecommit_poweruser.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitPowerUser"
}

resource "aws_iam_user" "govuk_codecommit_mirrorer" {
  name = "govuk-codecommit-mirrorer"
}

resource "aws_iam_user_policy_attachment" "govuk_codecommit_mirrorer_policy_attachment" {
  user       = aws_iam_user.govuk_codecommit_mirrorer.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitPowerUser"
}

resource "aws_iam_user_ssh_key" "govuk_codecommit_mirrorer_ssh_key" {
  username   = aws_iam_user.govuk_codecommit_mirrorer.name
  encoding   = "SSH"
  public_key = var.govuk_codecommit_mirrorer_ssh_key
}

// Allow Jenkins Deloy_App job to clone AWSCodeCommit repositories

resource "aws_iam_user" "govuk_codecommit_user" {
  for_each = { for item in var.govuk_environments_ssh_key : item.environment => item }
  name     = "govuk-${each.value.environment}-codecommit-user"
}

resource "aws_iam_user_policy_attachment" "govuk_codecommit_user_readonly_policy_attachment" {
  for_each   = { for item in var.govuk_environments_ssh_key : item.environment => item }
  user       = aws_iam_user.govuk_codecommit_user[each.value.environment].name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitReadOnly"
}

resource "aws_iam_policy" "govuk_codecommit_user_gitpush_policy" {
  for_each    = { for item in var.govuk_environments_ssh_key : item.environment => item }
  name        = "govuk-${each.value.environment}-codecommit-user-gitpush-resources-policy"
  description = "Allows pushing a specific branch to AWS CodeCommit"
  policy      = data.aws_iam_policy_document.allow_codecommit_gitpush_policy_document[each.value.environment].json
}

data "aws_iam_policy_document" "allow_codecommit_gitpush_policy_document" {
  for_each = { for item in var.govuk_environments_ssh_key : item.environment => item }

  statement {
    actions = [
      "codecommit:GitPush",
    ]

    resources = ["*"]

    condition {
      test     = "StringEqualsIfExists"
      variable = "codecommit:References"
      values   = ["refs/heads/deployed-to-${each.value.environment}"]
    }
  }
}

resource "aws_iam_user_policy_attachment" "govuk_codecommit_user_tag_resources_policy_attachment" {
  for_each   = { for item in var.govuk_environments_ssh_key : item.environment => item }
  user       = aws_iam_user.govuk_codecommit_user[each.value.environment].name
  policy_arn = aws_iam_policy.govuk_codecommit_user_gitpush_policy[each.value.environment].arn
}

resource "aws_iam_user_ssh_key" "govuk_codecommit_user_jenkins_ssh_key" {
  for_each   = { for item in var.govuk_environments_ssh_key : item.environment => item }
  username   = aws_iam_user.govuk_codecommit_user[each.value.environment].name
  encoding   = "SSH"
  public_key = each.value.ssh_key
}
