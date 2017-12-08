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
