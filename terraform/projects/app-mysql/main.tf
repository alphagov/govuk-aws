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

variable "skip_final_snapshot" {
  type        = "string"
  description = "Set to true to NOT create a final snapshot when the cluster is deleted."
}

variable "snapshot_identifier" {
  type        = "string"
  description = "Specifies whether or not to create the database from this snapshot"
  default     = ""
}

variable "storage_size" {
  type        = "string"
  description = "Defines the AWS RDS storage capacity, in gigabytes."
  default     = "30"
}

variable "internal_zone_name" {
  type        = "string"
  description = "The name of the Route53 zone that contains internal records"
}

variable "internal_domain_name" {
  type        = "string"
  description = "The domain name of the internal DNS records, it could be different from the zone name"
}

variable "instance_type" {
  type        = "string"
  description = "Instance type used for RDS resources"
  default     = "db.m4.xlarge"
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

data "aws_route53_zone" "internal" {
  name         = "${var.internal_zone_name}"
  private_zone = true
}

# MySQL Primary instance
module "mysql_primary_rds_instance" {
  source               = "../../modules/aws/rds_instance"
  name                 = "${var.stackname}-mysql-primary"
  instance_name        = "${var.stackname}-mysql-primary"
  engine_name          = "mysql"
  engine_version       = "5.6"
  default_tags         = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "mysql-primary")}"
  subnet_ids           = "${data.terraform_remote_state.infra_networking.private_subnet_rds_ids}"
  username             = "${var.username}"
  password             = "${var.password}"
  allocated_storage    = "${var.storage_size}"
  instance_class       = "${var.instance_type}"
  security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_mysql-primary_id}"]
  parameter_group_name = "${aws_db_parameter_group.mysql-primary.name}"
  event_sns_topic_arn  = "${data.terraform_remote_state.infra_monitoring.sns_topic_rds_events_arn}"
  skip_final_snapshot  = "${var.skip_final_snapshot}"
  snapshot_identifier  = "${var.snapshot_identifier}"
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
  zone_id = "${data.aws_route53_zone.internal.zone_id}"
  name    = "mysql-primary.${var.internal_domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = ["${module.mysql_primary_rds_instance.rds_instance_address}"]
}

module "alarms-rds-mysql-primary" {
  source         = "../../modules/aws/alarms/rds"
  name_prefix    = "${var.stackname}-mysql-primary"
  alarm_actions  = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  db_instance_id = "${module.mysql_primary_rds_instance.rds_instance_id}"
}

module "mysql_primary_log_exporter" {
  source                       = "../../modules/aws/rds_log_exporter"
  rds_instance_id              = "${module.mysql_primary_rds_instance.rds_instance_id}"
  s3_logging_bucket_name       = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  lambda_filename              = "../../lambda/RDSLogsToS3/RDSLogsToS3.zip"
  lambda_role_arn              = "${data.terraform_remote_state.infra_monitoring.lambda_rds_logs_to_s3_role_arn}"
  lambda_log_retention_in_days = "${var.cloudwatch_log_retention}"
}

# MySQL Replica instance
module "mysql_replica_rds_instance" {
  source                     = "../../modules/aws/rds_instance"
  name                       = "${var.stackname}-mysql-replica"
  default_tags               = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "mysql-replica")}"
  instance_class             = "${var.instance_type}"
  instance_name              = "${var.stackname}-mysql-replica"
  security_group_ids         = ["${data.terraform_remote_state.infra_security_groups.sg_mysql-replica_id}"]
  create_replicate_source_db = "1"
  replicate_source_db        = "${module.mysql_primary_rds_instance.rds_instance_id}"
  event_sns_topic_arn        = "${data.terraform_remote_state.infra_monitoring.sns_topic_rds_events_arn}"
  skip_final_snapshot        = "${var.skip_final_snapshot}"
}

resource "aws_route53_record" "replica_service_record" {
  zone_id = "${data.aws_route53_zone.internal.zone_id}"
  name    = "mysql-replica.${var.internal_domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = ["${module.mysql_replica_rds_instance.rds_replica_address}"]
}

module "alarms-rds-mysql-replica" {
  source               = "../../modules/aws/alarms/rds"
  name_prefix          = "${var.stackname}-mysql-replica"
  alarm_actions        = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  db_instance_id       = "${module.mysql_replica_rds_instance.rds_replica_id}"
  replicalag_threshold = "300"
}

module "mysql_replica_log_exporter" {
  source                       = "../../modules/aws/rds_log_exporter"
  rds_instance_id              = "${module.mysql_replica_rds_instance.rds_replica_id}"
  s3_logging_bucket_name       = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  lambda_filename              = "../../lambda/RDSLogsToS3/RDSLogsToS3.zip"
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
