/**
* ## Project: app-ckan
*
* CKAN node
*/
variable "aws_region" {
  type        = "string"
  description = "AWS region"
  default     = "eu-west-1"
}

variable "stackname" {
  type        = "string"
  description = "Stackname"
}

# Resources
# --------------------------------------------------------------
terraform {
  backend "s3" {}
  required_version = "= 0.11.15"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "2.46.0"
}

data "aws_security_group" "ckan-rds" {
  name = "${var.stackname}_ckan_rds_access"
}

resource "aws_security_group_rule" "ckan-rds_ingress_ckan_postgres" {
  type      = "ingress"
  from_port = 5432
  to_port   = 5432
  protocol  = "tcp"

  security_group_id        = "${data.aws_security_group.ckan-rds.0.id}"
  source_security_group_id = "${data.terraform_remote_state.infra_security_groups.sg_ckan_id}"
}
