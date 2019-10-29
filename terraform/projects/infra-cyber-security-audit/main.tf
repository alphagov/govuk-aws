/**
* ## Module: projects/infra-cyber-security-audit
*
* Role and policy for Cyber security audit, to eventually deprecate the CSW-specific role
*/

variable "chain_account_id" {
  type    = "string"
  default = "988997429095"
}

variable "aws_region" {
  type    = "string"
  default = "eu-west-1"
}

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

module "cyber_security_audit_role" {
  source = "git::https://github.com/alphagov/tech-ops.git?ref=13f54e5//cyber-security/modules/gds_security_audit_role"

  chain_account_id = "988997429095"
}
