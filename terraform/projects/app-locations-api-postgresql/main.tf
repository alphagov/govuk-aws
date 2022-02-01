/**
* ## Project: projects/app-locations-api-postgresql
*
* RDS PostgreSQL instance for the Locations API
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
  default     = "db.m5.large"
}

# Resources
# --------------------------------------------------------------
terraform {
  backend          "s3"             {}
  required_version = "= 0.11.14"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "2.46.0"
}

resource "aws_db_parameter_group" "locations_api" {
  name_prefix = "govuk-locations-api"
  family      = "postgres13"

  # Only log information about autovacuuming activity if it takes
  # longer than 10000ms.
  parameter {
    name  = "log_autovacuum_min_duration"
    value = 10000
  }

  # Enable queries slower than 10000ms to be logged
  parameter {
    name  = "log_min_duration_statement"
    value = "10000"
  }

  # Log all types of logs
  parameter {
    name  = "log_statement"
    value = "all"
  }

  parameter {
    name  = "deadlock_timeout"
    value = 2500
  }

  parameter {
    name  = "log_lock_waits"
    value = true
  }

  tags {
    aws_stackname = "${var.stackname}"
  }
}

module "locations-api-postgresql-primary_rds_instance" {
  source                = "../../modules/aws/rds_instance"
  name                  = "${var.stackname}-locations-api-postgresql-primary"
  parameter_group_name  = "${aws_db_parameter_group.locations_api.name}"
  engine_name           = "postgres"
  engine_version        = "13.3"
  default_tags          = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "locations_api_postgresql_primary")}"
  subnet_ids            = "${data.terraform_remote_state.infra_networking.private_subnet_rds_ids}"
  username              = "${var.username}"
  password              = "${var.password}"
  allocated_storage     = "100"
  max_allocated_storage = "500"
  instance_class        = "${var.instance_type}"
  instance_name         = "${var.stackname}-locations-api-postgresql-primary"
  multi_az              = "${var.multi_az}"
  security_group_ids    = ["${data.terraform_remote_state.infra_security_groups.sg_locations-api-postgresql-primary_id}"]
  event_sns_topic_arn   = "${data.terraform_remote_state.infra_monitoring.sns_topic_rds_events_arn}"
  skip_final_snapshot   = "${var.skip_final_snapshot}"
  snapshot_identifier   = "${var.snapshot_identifier}"
  monitoring_interval   = "60"
  monitoring_role_arn   = "${data.terraform_remote_state.infra_monitoring.rds_enhanced_monitoring_role_arn}"
}

resource "aws_route53_record" "service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.internal_zone_id}"
  name    = "locations-api-postgresql-primary.${data.terraform_remote_state.infra_stack_dns_zones.internal_domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = ["${module.locations-api-postgresql-primary_rds_instance.rds_instance_address}"]
}

module "alarms-rds-locations-api-postgresql-primary" {
  source                     = "../../modules/aws/alarms/rds"
  name_prefix                = "${var.stackname}-locations-api-postgresql-primary"
  alarm_actions              = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  db_instance_id             = "${module.locations-api-postgresql-primary_rds_instance.rds_instance_id}"
  freestoragespace_threshold = "53687091200"
}

# Outputs
# --------------------------------------------------------------

output "locations-api-postgresql-primary_id" {
  value       = "${module.locations-api-postgresql-primary_rds_instance.rds_instance_id}"
  description = "postgresql instance ID"
}

output "locations-api-postgresql-primary_resource_id" {
  value       = "${module.locations-api-postgresql-primary_rds_instance.rds_instance_resource_id}"
  description = "postgresql instance resource ID"
}

output "locations-api-postgresql-primary_endpoint" {
  value       = "${module.locations-api-postgresql-primary_rds_instance.rds_instance_endpoint}"
  description = "postgresql instance endpoint"
}

output "locations-api-postgresql-primary_address" {
  value       = "${module.locations-api-postgresql-primary_rds_instance.rds_instance_address}"
  description = "postgresql instance address"
}
