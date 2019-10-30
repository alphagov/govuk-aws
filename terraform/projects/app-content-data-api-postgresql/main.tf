/**
* ## Project: projects/app-content-data-api-postgresql
*
* RDS PostgreSQL instance for the Content Data API
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
  default     = true
}

variable "skip_final_snapshot" {
  type        = "string"
  description = "Set to true to NOT create a final snapshot when the cluster is deleted."
}

variable "snapshot_identifier" {
  type        = "string"
  description = "Specifies whether or not to create the database from this snapshot"
  default     = ""
}

variable "instance_type" {
  type        = "string"
  description = "Instance type used for RDS resources"
  default     = "db.m4.large"
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

resource "aws_db_parameter_group" "content_data_api" {
  name_prefix = "govuk-content-data-api"
  family      = "postgres9.6"

  # DBInstanceClassMemory is in bytes, divide by 1024 * 16 to convert
  # to kilobytes, and specify that a a 16th of the overall system
  # memory should be available as work_mem for each session.
  #
  # As this is per session, the actual overall peak memory usage can
  # be many times this value, if there are many active sessions.
  parameter {
    name  = "work_mem"
    value = "GREATEST({DBInstanceClassMemory/${1024 * 16}},65536)"
  }

  # Just use a single worker, as some tables are very large, and it's
  # probably better just to vacuum one table at a time
  parameter {
    name         = "autovacuum_max_workers"
    value        = 1
    apply_method = "pending-reboot"
  }

  # DBInstanceClassMemory is in bytes, divide by 1024 * 3 to convert
  # to kilobytes, and specify that a third of the overall memory
  # should be available as work_mem
  parameter {
    name  = "maintenance_work_mem"
    value = "GREATEST({DBInstanceClassMemory/${1024 * 3}},65536)"
  }

  # Log information about autovacuuming activity, so this can be
  # better understood
  parameter {
    name  = "rds.force_autovacuum_logging_level"
    value = "log"
  }

  # Only log information about autovacuuming activity if it takes
  # longer than 10000ms.
  parameter {
    name  = "log_autovacuum_min_duration"
    value = 10000
  }

  tags {
    aws_stackname = "${var.stackname}"
  }
}

module "content-data-api-postgresql-primary_rds_instance" {
  source               = "../../modules/aws/rds_instance"
  name                 = "${var.stackname}-content-data-api-postgresql-primary"
  parameter_group_name = "${aws_db_parameter_group.content_data_api.name}"
  engine_name          = "postgres"
  engine_version       = "9.6"
  default_tags         = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "content_data_api_postgresql_primary")}"
  subnet_ids           = "${data.terraform_remote_state.infra_networking.private_subnet_rds_ids}"
  username             = "${var.username}"
  password             = "${var.password}"
  allocated_storage    = "1024"
  instance_class       = "${var.instance_type}"
  instance_name        = "${var.stackname}-content-data-api-postgresql-primary"
  multi_az             = "${var.multi_az}"
  security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_content-data-api-postgresql-primary_id}"]
  event_sns_topic_arn  = "${data.terraform_remote_state.infra_monitoring.sns_topic_rds_events_arn}"
  skip_final_snapshot  = "${var.skip_final_snapshot}"
  snapshot_identifier  = "${var.snapshot_identifier}"
}

resource "aws_route53_record" "service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.internal_zone_id}"
  name    = "content-data-api-postgresql-primary.${data.terraform_remote_state.infra_stack_dns_zones.internal_domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = ["${module.content-data-api-postgresql-primary_rds_instance.rds_instance_address}"]
}

module "content-data-api-postgresql-standby_rds_instance" {
  source                     = "../../modules/aws/rds_instance"
  name                       = "${var.stackname}-content-data-api-postgresql-standby"
  default_tags               = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "content_data_api_postgresql_standby")}"
  instance_class             = "db.m4.large"
  instance_name              = "${var.stackname}-content-data-api-postgresql-standby"
  security_group_ids         = ["${data.terraform_remote_state.infra_security_groups.sg_content-data-api-postgresql-primary_id}"]
  create_replicate_source_db = "1"
  replicate_source_db        = "${module.content-data-api-postgresql-primary_rds_instance.rds_instance_id}"
  event_sns_topic_arn        = "${data.terraform_remote_state.infra_monitoring.sns_topic_rds_events_arn}"
  skip_final_snapshot        = "${var.skip_final_snapshot}"
}

resource "aws_route53_record" "replica_service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.internal_zone_id}"
  name    = "content-data-api-postgresql-standby.${data.terraform_remote_state.infra_stack_dns_zones.internal_domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = ["${module.content-data-api-postgresql-standby_rds_instance.rds_replica_address}"]
}

module "alarms-rds-content-data-api-postgresql-primary" {
  source                     = "../../modules/aws/alarms/rds"
  name_prefix                = "${var.stackname}-content-data-api-postgresql-primary"
  alarm_actions              = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  db_instance_id             = "${module.content-data-api-postgresql-primary_rds_instance.rds_instance_id}"
  freestoragespace_threshold = "536870912000"
}

module "alarms-rds-postgresql-standby" {
  source                     = "../../modules/aws/alarms/rds"
  name_prefix                = "${var.stackname}-content-data-api-postgresql-standby"
  alarm_actions              = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  db_instance_id             = "${module.content-data-api-postgresql-standby_rds_instance.rds_replica_id}"
  replicalag_threshold       = "300"
  freestoragespace_threshold = "536870912000"
}

module "content-data-api-postgresql-primary_log_exporter" {
  source                       = "../../modules/aws/rds_log_exporter"
  rds_instance_id              = "${module.content-data-api-postgresql-primary_rds_instance.rds_instance_id}"
  s3_logging_bucket_name       = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  lambda_filename              = "../../lambda/RDSLogsToS3/RDSLogsToS3.zip"
  lambda_role_arn              = "${data.terraform_remote_state.infra_monitoring.lambda_rds_logs_to_s3_role_arn}"
  lambda_log_retention_in_days = "${var.cloudwatch_log_retention}"
}

module "postgresql-standby_log_exporter" {
  source                       = "../../modules/aws/rds_log_exporter"
  rds_instance_id              = "${module.content-data-api-postgresql-standby_rds_instance.rds_replica_id}"
  s3_logging_bucket_name       = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  lambda_filename              = "../../lambda/RDSLogsToS3/RDSLogsToS3.zip"
  lambda_role_arn              = "${data.terraform_remote_state.infra_monitoring.lambda_rds_logs_to_s3_role_arn}"
  lambda_log_retention_in_days = "${var.cloudwatch_log_retention}"
}

# Outputs
# --------------------------------------------------------------

output "content-data-api-postgresql-primary_id" {
  value       = "${module.content-data-api-postgresql-primary_rds_instance.rds_instance_id}"
  description = "postgresql instance ID"
}

output "content-data-api-postgresql-primary_resource_id" {
  value       = "${module.content-data-api-postgresql-primary_rds_instance.rds_instance_resource_id}"
  description = "postgresql instance resource ID"
}

output "content-data-api-postgresql-primary_endpoint" {
  value       = "${module.content-data-api-postgresql-primary_rds_instance.rds_instance_endpoint}"
  description = "postgresql instance endpoint"
}

output "content-data-api-postgresql-primary_address" {
  value       = "${module.content-data-api-postgresql-primary_rds_instance.rds_instance_address}"
  description = "postgresql instance address"
}

output "postgresql-standby_endpoint" {
  value       = "${module.content-data-api-postgresql-standby_rds_instance.rds_replica_endpoint}"
  description = "postgresql replica instance endpoint"
}

output "postgresql-standby_address" {
  value       = "${module.content-data-api-postgresql-standby_rds_instance.rds_replica_address}"
  description = "postgresql replica instance address"
}
