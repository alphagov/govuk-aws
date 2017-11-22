/**
* ## Project: projects/app-postgresql
*
* RDS PostgreSQL instances
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
  description = "PostgreSQL username"
}

variable "password" {
  type        = "string"
  description = "DB password"
}

variable "multi_az" {
  type        = "string"
  description = "Enable multi-az."
  default     = false
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

module "postgresql-primary_rds_instance" {
  source = "../../modules/aws/rds_instance"

  name               = "${var.stackname}-postgresql-primary"
  engine_name        = "postgres"
  engine_version     = "9.3.14"
  default_tags       = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "postgresql_primary")}"
  subnet_ids         = "${data.terraform_remote_state.infra_networking.private_subnet_rds_ids}"
  username           = "${var.username}"
  password           = "${var.password}"
  allocated_storage  = "120"
  instance_class     = "db.m4.large"
  multi_az           = "${var.multi_az}"
  security_group_ids = ["${data.terraform_remote_state.infra_security_groups.sg_postgresql-primary_id}"]
}

resource "aws_route53_record" "service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.internal_zone_id}"
  name    = "postgresql-primary.${data.terraform_remote_state.infra_stack_dns_zones.internal_domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = ["${module.postgresql-primary_rds_instance.rds_instance_address}"]
}

module "postgresql-standby_rds_instance" {
  source = "../../modules/aws/rds_instance"

  name                       = "${var.stackname}-postgresql-standby"
  default_tags               = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "postgresql_standby")}"
  instance_class             = "db.m4.large"
  security_group_ids         = ["${data.terraform_remote_state.infra_security_groups.sg_postgresql-primary_id}"]
  create_replicate_source_db = "1"
  replicate_source_db        = "${module.postgresql-primary_rds_instance.rds_instance_id}"
}

resource "aws_route53_record" "replica_service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.internal_zone_id}"
  name    = "postgresql-standby.${data.terraform_remote_state.infra_stack_dns_zones.internal_domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = ["${module.postgresql-standby_rds_instance.rds_replica_address}"]
}

module "alarms-rds-postgresql-primary" {
  source         = "../../modules/aws/alarms/rds"
  name_prefix    = "${var.stackname}-postgresql-primary"
  alarm_actions  = ["${data.terraform_remote_state.infra_monitoring.sns_topic_alerts_arn}"]
  db_instance_id = "${module.postgresql-primary_rds_instance.rds_instance_id}"
}

module "alarms-rds-postgresql-standby" {
  source               = "../../modules/aws/alarms/rds"
  name_prefix          = "${var.stackname}-postgresql-standby"
  alarm_actions        = ["${data.terraform_remote_state.infra_monitoring.sns_topic_alerts_arn}"]
  db_instance_id       = "${module.postgresql-standby_rds_instance.rds_replica_id}"
  replicalag_threshold = "120"
}

module "postgresql-primary_log_exporter" {
  source                       = "../../modules/aws/rds_log_exporter"
  rds_instance_id              = "${module.postgresql-primary_rds_instance.rds_instance_id}"
  s3_logging_bucket_name       = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  lambda_filename              = "${path.module}/../../lambda/RDSLogsToS3/RDSLogsToS3.zip"
  lambda_role_arn              = "${data.terraform_remote_state.infra_monitoring.lambda_rds_logs_to_s3_role_arn}"
  lambda_log_retention_in_days = "${var.cloudwatch_log_retention}"
}

module "postgresql-standby_log_exporter" {
  source                       = "../../modules/aws/rds_log_exporter"
  rds_instance_id              = "${module.postgresql-standby_rds_instance.rds_replica_id}"
  s3_logging_bucket_name       = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  lambda_filename              = "${path.module}/../../lambda/RDSLogsToS3/RDSLogsToS3.zip"
  lambda_role_arn              = "${data.terraform_remote_state.infra_monitoring.lambda_rds_logs_to_s3_role_arn}"
  lambda_log_retention_in_days = "${var.cloudwatch_log_retention}"
}

# Outputs
# --------------------------------------------------------------

output "postgresql-primary_id" {
  value       = "${module.postgresql-primary_rds_instance.rds_instance_id}"
  description = "postgresql instance ID"
}

output "postgresql-primary_resource_id" {
  value       = "${module.postgresql-primary_rds_instance.rds_instance_resource_id}"
  description = "postgresql instance resource ID"
}

output "postgresql-primary_endpoint" {
  value       = "${module.postgresql-primary_rds_instance.rds_instance_endpoint}"
  description = "postgresql instance endpoint"
}

output "postgresql-primary_address" {
  value       = "${module.postgresql-primary_rds_instance.rds_instance_address}"
  description = "postgresql instance address"
}

output "postgresql-standby_endpoint" {
  value       = "${module.postgresql-standby_rds_instance.rds_replica_endpoint}"
  description = "postgresql replica instance endpoint"
}

output "postgresql-standby_address" {
  value       = "${module.postgresql-standby_rds_instance.rds_replica_address}"
  description = "postgresql replica instance address"
}
