/**
* ## Module: projects/infra-security
*
* Infrastructure security settings:
*  - Create admin role for trusted users from GDS proxy account
*  - Create users role for trusted users from GDS proxy account
*  - Default IAM password policy
*  - Default SSH key
*  - SOPS KMS key
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
  default     = ""
}

variable "role_admin_user_arns" {
  type        = list
  description = "List of ARNs of external users that can assume the role"
  default     = []
}

variable "role_admin_policy_arns" {
  type        = list
  description = "List of ARNs of policies to attach to the role"
  default     = []
}

variable "role_internal_admin_user_arns" {
  type        = list
  description = "List of ARNs of external users that can assume the role"
  default     = []
}

variable "role_internal_admin_policy_arns" {
  type        = list
  description = "List of ARNs of policies to attach to the role"
  default     = []
}

variable "role_platformhealth_poweruser_user_arns" {
  type        = list
  description = "List of ARNs of external users that can assume the role"
  default     = []
}

variable "role_platformhealth_poweruser_policy_arns" {
  type        = list
  description = "List of ARNs of policies to attach to the role"
  default     = []
}

variable "role_poweruser_user_arns" {
  type        = list
  description = "List of ARNs of external users that can assume the role"
  default     = []
}

variable "role_poweruser_policy_arns" {
  type        = list
  description = "List of ARNs of policies to attach to the role"
  default     = []
}

variable "role_datascienceuser_user_arns" {
  type        = list
  description = "List of ARNs of external users that can assume the role"
  default     = []
}

variable "role_datascienceuser_policy_arns" {
  type        = list
  description = "List of ARNs of policies to attach to the role"
  default     = []
}

variable "role_user_user_arns" {
  type        = list
  description = "List of ARNs of external users that can assume the role"
  default     = []
}

variable "role_user_policy_arns" {
  type        = list
  description = "List of ARNs of policies to attach to the role"
  default     = []
}

variable "ssh_public_key" {
  type        = string
  description = "The public part of an SSH keypair"
}

# Resources
# --------------------------------------------------------------

terraform {
  backend "s3" {}
  required_version = "= 0.12.30"
}

provider "aws" {
  region  = var.aws_region
  version = "2.46.0"
}

data "aws_caller_identity" "current" {}

module "role_admin" {
  source           = "../../modules/aws/iam/role_user"
  role_name        = "govuk-administrators"
  role_user_arns   = var.role_admin_user_arns
  role_policy_arns = var.role_admin_policy_arns
}

module "role_internal_admin" {
  source           = "../../modules/aws/iam/role_user"
  role_name        = "govuk-internal-administrators"
  role_user_arns   = var.role_internal_admin_user_arns
  role_policy_arns = var.role_internal_admin_policy_arns
}

module "role_platformhealth_poweruser" {
  source           = "../../modules/aws/iam/role_user"
  role_name        = "govuk-platformhealth-powerusers"
  role_user_arns   = var.role_platformhealth_poweruser_user_arns
  role_policy_arns = var.role_platformhealth_poweruser_policy_arns
}

module "role_poweruser" {
  source           = "../../modules/aws/iam/role_user"
  role_name        = "govuk-powerusers"
  role_user_arns   = var.role_poweruser_user_arns
  role_policy_arns = var.role_poweruser_policy_arns
}

module "role_datascienceuser" {
  source           = "../../modules/aws/iam/role_user"
  role_name        = "govuk-datascienceusers"
  role_user_arns   = var.role_datascienceuser_user_arns
  role_policy_arns = var.role_datascienceuser_policy_arns
}

module "role_user" {
  source           = "../../modules/aws/iam/role_user"
  role_name        = "govuk-users"
  role_user_arns   = var.role_user_user_arns
  role_policy_arns = var.role_user_policy_arns
}

resource "aws_iam_account_password_policy" "tighten_passwords" {
  allow_users_to_change_password = true
  minimum_password_length        = 12
  require_lowercase_characters   = true
  require_numbers                = true
  require_symbols                = true
  require_uppercase_characters   = true
}

# default key pair for all ssh instances. All other keys are puppet managed
resource "aws_key_pair" "govuk-infra-key" {
  key_name   = "govuk-infra"
  public_key = var.ssh_public_key
}

# Deny EIP Releasing for all users
data "aws_iam_policy_document" "deny-eip-release" {
  statement {
    actions   = ["ec2:ReleaseAddress"]
    effect    = "Deny"
    resources = ["*"]
  }
}

resource "aws_iam_policy" "deny-eip-release" {
  name        = "DenyEipRelease"
  description = "Deny users the ability to release allocated Elastic IPs"
  policy      = data.aws_iam_policy_document.deny-eip-release.json
}

# Allow IAM Key Rotation
data "aws_iam_policy_document" "allow-iam-key-rotation" {
  statement {
    actions = [
      "iam:CreateAccessKey",
      "iam:DeleteAccessKey",
      "iam:GetAccessKeyLastUsed",
      "iam:ListAccessKeys",
      "iam:UpdateAccessKey",
    ]

    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_policy" "allow-iam-key-rotation" {
  name        = "AllowIamKeyRotation"
  description = "Allow users the ability to rotate AWS IAM Access Keys"
  policy      = data.aws_iam_policy_document.allow-iam-key-rotation.json
}

# Data science access policy
data "aws_iam_policy_document" "data-science-access-glue" {
  statement {
    actions = [
      "glue:GetJob",
      "glue:ListJobs",
      "glue:StartJobRun",
      "glue:BatchGetJobs",
    ]

    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_policy" "data-science-access-glue" {
  name        = "DataScienceAccessGlue"
  description = "Allows users access to Glue resources for data science on GOV.UK"
  policy      = data.aws_iam_policy_document.data-science-access-glue.json
}

data "aws_iam_policy_document" "data-science-access-sagemaker" {
  statement {
    actions = [
      "sagemaker:CreateNotebookInstance",
      "sagemaker:CreatePresignedNotebookInstanceUrl",
      "sagemaker:DescribeNotebookInstance",
      "sagemaker:DeleteNotebookInstance",
      "sagemaker:ListNotebookInstances",
      "sagemaker:StartNotebookInstance",
      "sagemaker:StopNotebookInstance",
      "sagemaker:UpdateNotebookInstance",
    ]

    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_policy" "data-science-access-sagemaker" {
  name        = "DataScienceAccessSageMaker"
  description = "Allows users access to SageMaker resources for data science on GOV.UK"
  policy      = data.aws_iam_policy_document.data-science-access-sagemaker.json
}

# SOPS KMS key

data "aws_iam_policy_document" "kms_sops_policy" {
  statement {
    sid = "Enable IAM User Permission"

    actions = [
      "kms:*",
    ]

    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }

  statement {
    sid = "Allow access for Key Administrators"

    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion",
    ]

    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["${module.role_admin.role_arn}", "${module.role_internal_admin.role_arn}"]
    }
  }

  statement {
    sid = "Allow use of the key"

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]

    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["${module.role_admin.role_arn}", "${module.role_internal_admin.role_arn}"]
    }
  }

  statement {
    sid = "Allow attachment of persistent resources"

    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant",
    ]

    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["${module.role_admin.role_arn}", "${module.role_internal_admin.role_arn}"]
    }
  }
}

resource "aws_kms_key" "sops" {
  description = "Encryption key for govuk-aws-data"
  policy      = data.aws_iam_policy_document.kms_sops_policy.json
}

resource "aws_kms_alias" "sops" {
  name          = "alias/govuk-terraform-data"
  target_key_id = aws_kms_key.sops.key_id
}

resource "aws_kms_key" "licensify_documentdb" {
  description = "Encryption key for Licensify DocumentDB"
  policy      = data.aws_iam_policy_document.kms_sops_policy.json
}

resource "aws_kms_key" "shared_documentdb" {
  description = "Encryption key for Shared DocumentDB"
  policy      = data.aws_iam_policy_document.kms_sops_policy.json
}

# Outputs
# --------------------------------------------------------------

output "sops_kms_key_arn" {
  value       = aws_kms_key.sops.arn
  description = "The ARN of the Sops KMS key"
}

output "licensify_documentdb_kms_key_arn" {
  value       = aws_kms_key.licensify_documentdb.arn
  description = "The ARN of the Licensify DocumentDB KMS key"
}

output "shared_documentdb_kms_key_arn" {
  value       = aws_kms_key.shared_documentdb.arn
  description = "The ARN of the Shared DocumentDB KMS key"
}
