/**
* ## Project: app-mysql
*
* RDS Mysql Primary instance
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

variable "aws_environment" {
  type        = "string"
  description = "AWS Environment"
}

variable "cloudwatch_log_retention" {
  type        = "string"
  description = "Number of days to retain Cloudwatch logs for"
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
  required_version = "= 0.10.8"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "1.0.0"
}

# MySQL Primary instance
module "mysql_primary_rds_instance" {
  source               = "../../modules/aws/rds_instance"
  name                 = "${var.stackname}-mysql-primary"
  engine_name          = "mysql"
  engine_version       = "5.6.27"
  default_tags         = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "mysql-primary")}"
  subnet_ids           = "${data.terraform_remote_state.infra_networking.private_subnet_rds_ids}"
  username             = "${var.username}"
  password             = "${var.password}"
  allocated_storage    = "30"
  instance_class       = "db.m4.xlarge"
  security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_mysql-primary_id}"]
  parameter_group_name = "${aws_db_parameter_group.mysql-primary.name}"
}

resource "aws_db_parameter_group" "mysql-primary" {
  name_prefix = "mysql-primary"
  family      = "mysql5.6"

  parameter {
    name  = "max_allowed_packet"
    value = 1073741824
  }

  # TODO: this should be set to 0 when we have migrated to Production
  # as it not recommended to set this option
  parameter {
    name  = "log_bin_trust_function_creators"
    value = 1
  }

  tags {
    aws_stackname = "${var.stackname}"
  }
}

resource "aws_route53_record" "service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.internal_zone_id}"
  name    = "mysql-primary.${data.terraform_remote_state.infra_stack_dns_zones.internal_domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = ["${module.mysql_primary_rds_instance.rds_instance_address}"]
}

module "alarms-rds-mysql-primary" {
  source         = "../../modules/aws/alarms/rds"
  name_prefix    = "${var.stackname}-mysql-primary"
  alarm_actions  = ["${data.terraform_remote_state.infra_monitoring.sns_topic_alerts_arn}"]
  db_instance_id = "${module.mysql_primary_rds_instance.rds_instance_id}"
}

module "mysql_primary_log_exporter" {
  source                       = "../../modules/aws/rds_log_exporter"
  rds_instance_id              = "${module.mysql_primary_rds_instance.rds_instance_id}"
  s3_logging_bucket_name       = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  lambda_filename              = "${path.module}/../../lambda/RDSLogsToS3/RDSLogsToS3.zip"
  lambda_role_arn              = "${data.terraform_remote_state.infra_monitoring.lambda_rds_logs_to_s3_role_arn}"
  lambda_log_retention_in_days = "${var.cloudwatch_log_retention}"
}

# MySQL Replica instance
module "mysql_replica_rds_instance" {
  source                     = "../../modules/aws/rds_instance"
  name                       = "${var.stackname}-mysql-replica"
  default_tags               = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "mysql-replica")}"
  instance_class             = "db.m4.xlarge"
  security_group_ids         = ["${data.terraform_remote_state.infra_security_groups.sg_mysql-replica_id}"]
  create_replicate_source_db = "1"
  replicate_source_db        = "${module.mysql_primary_rds_instance.rds_instance_id}"
}

resource "aws_route53_record" "replica_service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.internal_zone_id}"
  name    = "mysql-replica.${data.terraform_remote_state.infra_stack_dns_zones.internal_domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = ["${module.mysql_replica_rds_instance.rds_replica_address}"]
}

module "alarms-rds-mysql-replica" {
  source               = "../../modules/aws/alarms/rds"
  name_prefix          = "${var.stackname}-mysql-replica"
  alarm_actions        = ["${data.terraform_remote_state.infra_monitoring.sns_topic_alerts_arn}"]
  db_instance_id       = "${module.mysql_replica_rds_instance.rds_replica_id}"
  replicalag_threshold = "120"
}

module "mysql_replica_log_exporter" {
  source                       = "../../modules/aws/rds_log_exporter"
  rds_instance_id              = "${module.mysql_replica_rds_instance.rds_replica_id}"
  s3_logging_bucket_name       = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  lambda_filename              = "${path.module}/../../lambda/RDSLogsToS3/RDSLogsToS3.zip"
  lambda_role_arn              = "${data.terraform_remote_state.infra_monitoring.lambda_rds_logs_to_s3_role_arn}"
  lambda_log_retention_in_days = "${var.cloudwatch_log_retention}"
}

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

output "mysql_replica_endpoint" {
  value       = "${module.mysql_replica_rds_instance.rds_instance_endpoint}"
  description = "Mysql instance endpoint"
}

output "mysql_replica_address" {
  value       = "${module.mysql_replica_rds_instance.rds_instance_address}"
  description = "Mysql instance address"
}
