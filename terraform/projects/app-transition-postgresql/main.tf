/**
* ## Project: app-transition-postgresql
*
* RDS Transition PostgreSQL Primary instance
*/
variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-1"
}

variable "stackname" {
  type        = string
  description = "Stackname"
}

variable "aws_environment" {
  type        = string
  description = "AWS Environment"
}

variable "cloudwatch_log_retention" {
  type        = string
  description = "Number of days to retain Cloudwatch logs for"
}

variable "username" {
  type        = string
  description = "PostgreSQL username"
}

variable "password" {
  type        = string
  description = "DB password"
}

variable "multi_az" {
  type        = string
  description = "Enable multi-az."
  default     = true
}

variable "skip_final_snapshot" {
  type        = string
  description = "Set to true to NOT create a final snapshot when the cluster is deleted."
}

variable "snapshot_identifier" {
  type        = string
  description = "Specifies whether or not to create the database from this snapshot"
  default     = ""
}

variable "internal_zone_name" {
  type        = string
  description = "The name of the Route53 zone that contains internal records"
}

variable "internal_domain_name" {
  type        = string
  description = "The domain name of the internal DNS records, it could be different from the zone name"
}

variable "instance_type" {
  type        = string
  description = "Instance type used for RDS resources"
  default     = "db.m5.large"
}

# Resources
# --------------------------------------------------------------
terraform {
  backend "s3" {}
  required_version = "= 0.11.15"
}

provider "aws" {
  region  = var.aws_region
  version = "2.46.0"
}

data "aws_route53_zone" "internal" {
  name         = var.internal_zone_name
  private_zone = true
}

resource "aws_db_parameter_group" "app_transition_pg" {
  name_prefix = "app-transition-pg-"
  family      = "postgres13"

  parameter {
    name  = "log_min_duration_statement"
    value = "10000"
  }

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
}

module "transition-postgresql-primary_rds_instance" {
  source = "../../modules/aws/rds_instance"

  name                  = "${var.stackname}-transition-postgresql-primary"
  engine_name           = "postgres"
  engine_version        = "13"
  default_tags          = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "transition_postgresql_primary")}"
  subnet_ids            = data.terraform_remote_state.infra_networking.private_subnet_rds_ids
  username              = var.username
  password              = var.password
  allocated_storage     = "120"
  max_allocated_storage = "500"
  instance_class        = var.instance_type
  instance_name         = "${var.stackname}-transition-postgresql-primary"
  multi_az              = var.multi_az
  security_group_ids    = ["${data.terraform_remote_state.infra_security_groups.sg_transition-postgresql-primary_id}"]
  event_sns_topic_arn   = data.terraform_remote_state.infra_monitoring.sns_topic_rds_events_arn
  skip_final_snapshot   = var.skip_final_snapshot
  snapshot_identifier   = var.snapshot_identifier
  parameter_group_name  = aws_db_parameter_group.app_transition_pg.name
  monitoring_interval   = "60"
  monitoring_role_arn   = data.terraform_remote_state.infra_monitoring.rds_enhanced_monitoring_role_arn
}

resource "aws_route53_record" "service_record" {
  zone_id = data.aws_route53_zone.internal.zone_id
  name    = "transition-postgresql-primary.${var.internal_domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = ["${module.transition-postgresql-primary_rds_instance.rds_instance_address}"]
}

module "transition-postgresql-standby_rds_instance" {
  source = "../../modules/aws/rds_instance"

  name                       = "${var.stackname}-transition-postgresql-standby"
  default_tags               = map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "transition_postgresql_standby", "Environment", var.aws_environment, "Product", "GOVUK", "Owner", "govuk-replatforming-team@digital.cabinet-office.gov.uk", "System", "${var.stackname} Transition Database")
  instance_class             = var.instance_type
  instance_name              = "${var.stackname}-transition-postgresql-standby"
  security_group_ids         = ["${data.terraform_remote_state.infra_security_groups.sg_transition-postgresql-standby_id}"]
  create_replicate_source_db = "1"
  allocated_storage          = "120"
  max_allocated_storage      = "500"
  replicate_source_db        = module.transition-postgresql-primary_rds_instance.rds_instance_id
  event_sns_topic_arn        = data.terraform_remote_state.infra_monitoring.sns_topic_rds_events_arn
  skip_final_snapshot        = var.skip_final_snapshot
  parameter_group_name       = aws_db_parameter_group.app_transition_pg.name
  monitoring_interval        = "60"
  monitoring_role_arn        = data.terraform_remote_state.infra_monitoring.rds_enhanced_monitoring_role_arn
}

resource "aws_route53_record" "replica_service_record" {
  zone_id = data.aws_route53_zone.internal.zone_id
  name    = "transition-postgresql-standby.${var.internal_domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = ["${module.transition-postgresql-standby_rds_instance.rds_replica_address}"]
}

module "alarms-rds-transition-postgresql-primary" {
  source         = "../../modules/aws/alarms/rds"
  name_prefix    = "${var.stackname}-transition-postgresql-primary"
  alarm_actions  = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  db_instance_id = module.transition-postgresql-primary_rds_instance.rds_instance_id
}

module "alarms-rds-transition-postgresql-standby" {
  source               = "../../modules/aws/alarms/rds"
  name_prefix          = "${var.stackname}-transition-postgresql-standby"
  alarm_actions        = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  db_instance_id       = module.transition-postgresql-standby_rds_instance.rds_replica_id
  replicalag_threshold = "300"
}

# Outputs
# --------------------------------------------------------------

output "transition-postgresql-primary_id" {
  value       = module.transition-postgresql-primary_rds_instance.rds_instance_id
  description = "transition-postgresql instance ID"
}

output "transition-postgresql-primary_resource_id" {
  value       = module.transition-postgresql-primary_rds_instance.rds_instance_resource_id
  description = "transition-postgresql instance resource ID"
}

output "transition-postgresql-primary_endpoint" {
  value       = module.transition-postgresql-primary_rds_instance.rds_instance_endpoint
  description = "transition-postgresql instance endpoint"
}

output "transition-postgresql-primary_address" {
  value       = module.transition-postgresql-primary_rds_instance.rds_instance_address
  description = "transition-postgresql instance address"
}

output "transition-postgresql-standby-endpoint" {
  value       = module.transition-postgresql-standby_rds_instance.rds_replica_endpoint
  description = "transition-postgresql replica instance endpoint"
}

output "transition-postgresql-standby-address" {
  value       = module.transition-postgresql-standby_rds_instance.rds_replica_address
  description = "transition-postgresql replica instance address"
}
