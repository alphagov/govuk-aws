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
  required_version = "= 0.11.7"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "1.60.0"
}

module "cyber_security_audit_role" {
  source = "git::https://github.com/alphagov/tech-ops//cyber-security/modules/gds_security_audit_role?ref=2d39415f6f92874dcf5eaee376f4d0af49992b8d"

  chain_account_id = "988997429095"
}
