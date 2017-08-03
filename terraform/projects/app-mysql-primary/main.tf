# == Manifest: projects::app-mysql-primary
#
# RDS Mysql Primary instance
#
# === Variables:
#
# aws_region
# stackname
# aws_environment
#
# === Outputs:
#

variable "aws_region" {
  type        = "string"
  description = "AWS region"
  default     = "eu-west-1"
}

variable "stackname" {
  type        = "string"
  description = "Stackname"
}

variable "aws_environment" {
  type        = "string"
  description = "AWS Environment"
}

variable "username" {
  type        = "string"
  description = "Mysql username"
}

variable "password" {
  type        = "string"
  description = "DB password"
}

# Resources
# --------------------------------------------------------------
terraform {
  backend          "s3"             {}
  required_version = "= 0.9.10"
}

provider "aws" {
  region = "${var.aws_region}"
}

module "mysql_primary_rds_instance" {
  source             = "../../modules/aws/rds_instance"
  name               = "${var.stackname}-mysql-primary"
  engine_name        = "mysql"
  engine_version     = "5.6.27"
  default_tags       = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "mysql-primary")}"
  subnet_ids         = "${data.terraform_remote_state.infra_networking.private_subnet_rds_ids}"
  username           = "${var.username}"
  password           = "${var.password}"
  allocated_storage  = "30"
  instance_class     = "db.m4.xlarge"
  security_group_ids = ["${data.terraform_remote_state.infra_security_groups.sg_mysql-primary_id}"]
}

#resource "aws_route53_record" "service_record" {
#  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.internal_zone_id}"
#  name    = "logs-redis.${data.terraform_remote_state.infra_stack_dns_zones.internal_domain_name}"
#  type    = "CNAME"
#  ttl     = 300
#  records = ["${module.logs_redis_cluster.configuration_endpoint_address}"]
#}

# Outputs
# --------------------------------------------------------------

output "mysql_primary_id" {
  value       = "${module.mysql_primary_rds_instance.rds_instance_id}"
  description = "Mysql instance ID"
}

output "mysql_primary_resource_id" {
  value       = "${module.mysql_primary_rds_instance.rds_instance_resource_id}"
  description = "Mysql instance resource ID"
}

output "mysql_primary_endpoint" {
  value       = "${module.mysql_primary_rds_instance.rds_instance_endpoint}"
  description = "Mysql instance endpoint"
}

output "mysql_primary_address" {
  value       = "${module.mysql_primary_rds_instance.rds_instance_address}"
  description = "Mysql instance address"
}
