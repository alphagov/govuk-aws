/**
* ## Module: projects/infra-csw
*
* Role and policy for CSW
*/

variable "csw_prefix" {
  default = "csw-prod"
}

variable "aws_region" {
  type        = "string"
  description = "AWS region"
  default     = "eu-west-1"
}

variable "csw_agent_account_id" {}

# Resources
# --------------------------------------------------------------
terraform {
  backend          "s3"             {}
  required_version = "= 0.11.14"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "2.33.0"
}

module "csw_inspector_role" {
  source               = "git::https://github.com/alphagov/csw-client-role.git"
  region               = "${var.aws_region}"
  csw_prefix           = "${var.csw_prefix}"
  csw_agent_account_id = "${var.csw_agent_account_id}"
}
