/**
* ## Module: projects/infra-security
*
* Infrastructure security settings:
*  - Create admin role for trusted users from GDS proxy account
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
  default     = ""
}

variable "role_admin_user_arns" {
  type        = "list"
  description = "List of ARNs of external users that can assume the role"
}

variable "role_admin_policy_arns" {
  type        = "list"
  description = "List of ARNs of policies to attach to the role"
  default     = []
}

variable "role_user_user_arns" {
  type        = "list"
  description = "List of ARNs of external users that can assume the role"
}

variable "role_user_policy_arns" {
  type        = "list"
  description = "List of ARNs of policies to attach to the role"
  default     = []
}

variable "ssh_public_key" {
  type        = "string"
  description = "The public part of an SSH keypair"
}

# Resources
# --------------------------------------------------------------

terraform {
  backend          "s3"             {}
  required_version = "= 0.11.1"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "1.0.0"
}

module "role_admin" {
  source           = "../../modules/aws/iam/role_user"
  role_name        = "govuk-administrators"
  role_user_arns   = ["${var.role_admin_user_arns}"]
  role_policy_arns = ["${var.role_admin_policy_arns}"]
}

module "role_user" {
  source           = "../../modules/aws/iam/role_user"
  role_name        = "govuk-users"
  role_user_arns   = ["${var.role_user_user_arns}"]
  role_policy_arns = ["${var.role_user_policy_arns}"]
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
  public_key = "${var.ssh_public_key}"
}
