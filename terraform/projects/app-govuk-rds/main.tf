terraform {
  backend "s3" {}
  required_version = "= 1.1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# --------------------------------------------------------------

output "rds_instance_id" {
  description = "RDS instance IDs"

  value = {
    for k, v in aws_db_instance.instance : k => v.id
  }
}

output "rds_resource_id" {
  description = "RDS instance resource IDs"

  value = {
    for k, v in aws_db_instance.instance : k => v.resource_id
  }
}

output "rds_endpoint" {
  description = "RDS instance endpoints"

  value = {
    for k, v in aws_db_instance.instance : k => v.endpoint
  }
}

output "rds_address" {
  description = "RDS instance addresses"

  value = {
    for k, v in aws_db_instance.instance : k => v.address
  }
}

output "instance_iam_role_name" {
  description = "db-admin node IAM role name"

  value = aws_iam_role.node_iam_role.name
}

output "autoscaling_group_name" {
  description = "ASG names"

  value = {
    for k, v in aws_autoscaling_group.node : k => v.name
  }
}

output "sg_rds" {
  description = "RDS instance security groups"

  value = {
    for k, v in aws_security_group.rds : k => v.id
  }
}

output "sg_db_admin" {
  description = "db-admin security groups"

  value = {
    for k, v in aws_security_group.db_admin : k => v.id
  }
}
