variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-1"
}

variable "stackname" {
  type        = string
  description = "Stackname"
  default     = "blue"
}

variable "aws_environment" {
  type        = string
  description = "AWS Environment"
}

variable "databases" {
  type        = map(any)
  description = "Databases to create and their configuration."
}

variable "database_credentials" {
  type        = map(any)
  description = "RDS root account credentials for each database."
}

variable "multi_az" {
  type        = bool
  description = "Set to true to deploy the RDS instance in multiple AZs."
  default     = false
}

variable "maintenance_window" {
  type        = string
  description = "The window to perform maintenance in"
  default     = "Mon:04:00-Mon:06:00"
}

variable "backup_window" {
  type        = string
  description = "The daily time range during which automated backups are created if automated backups are enabled."
  default     = "01:00-03:00"
}

variable "backup_retention_period" {
  type        = string
  description = "The days to retain backups for."
  default     = "7"
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Set to true to NOT create a final snapshot when the cluster is deleted."
  default     = false
}

variable "terraform_create_rds_timeout" {
  type        = string
  description = "Set the timeout time for AWS RDS creation."
  default     = "2h"
}

variable "terraform_update_rds_timeout" {
  type        = string
  description = "Set the timeout time for AWS RDS modification."
  default     = "2h"
}

variable "terraform_delete_rds_timeout" {
  type        = string
  description = "Set the timeout time for AWS RDS deletion."
  default     = "2h"
}

locals {
  tags = {
    Project         = var.stackname
    aws_stackname   = var.stackname
    aws_environment = var.aws_environment
  }
}

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


# Resources
# --------------------------------------------------------------

resource "aws_db_subnet_group" "subnet_group" {
  name       = "${var.stackname}-govuk-rds-subnet"
  subnet_ids = data.terraform_remote_state.infra_networking.outputs.private_subnet_rds_ids

  tags = merge(local.tags, { Name = "${var.stackname}-govuk-rds-subnet" })
}

resource "aws_db_parameter_group" "engine_params" {
  for_each = var.databases

  name_prefix = "${each.value.name}-${each.value.engine}-"
  family      = "${each.value.engine}${each.value.engine_version}"

  dynamic "parameter" {
    for_each = each.value.engine_params

    content {
      name         = parameter.key
      value        = parameter.value.value
      apply_method = merge({ apply_method = "immediate" }, each.value)["apply_method"]
    }
  }
}

resource "aws_db_instance" "instance" {
  for_each = var.databases

  engine                  = each.value.engine
  engine_version          = each.value.engine_version
  username                = var.database_credentials[each.key].username
  password                = var.database_credentials[each.key].password
  allocated_storage       = each.value.allocated_storage
  max_allocated_storage   = each.value.allocated_storage
  instance_class          = each.value.instance_class
  identifier              = "${each.value.name}-${each.value.engine}"
  storage_type            = "gp2"
  db_subnet_group_name    = aws_db_subnet_group.subnet_group.name
  multi_az                = var.multi_az
  parameter_group_name    = aws_db_parameter_group.engine_params[each.key].name
  maintenance_window      = var.maintenance_window
  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  copy_tags_to_snapshot   = true
  snapshot_identifier     = "${each.value.name}-snapshot"
  monitoring_interval     = 60
  monitoring_role_arn     = data.terraform_remote_state.infra_monitoring.outputs.rds_enhanced_monitoring_role_arn

  vpc_security_group_ids = [
    data.terraform_remote_state.infra_security_groups.outputs.sg_mysql-primary_id,
    data.terraform_remote_state.infra_security_groups.outputs.sg_postgresql-primary_id,
  ]

  timeouts {
    create = var.terraform_create_rds_timeout
    delete = var.terraform_delete_rds_timeout
    update = var.terraform_update_rds_timeout
  }

  final_snapshot_identifier = "${each.value.name}-final-snapshot"
  skip_final_snapshot       = var.skip_final_snapshot

  tags = merge(local.tags, { Name = "${var.stackname}-govuk-rds-${each.value.name}-${each.value.engine}" })
}

resource "aws_db_event_subscription" "subscription" {
  for_each = var.databases

  name      = "${aws_db_instance.instance[each.key].name}-event-subscription"
  sns_topic = data.terraform_remote_state.infra_monitoring.outputs.sns_topic_rds_events_arn

  source_type = "db-instance"
  source_ids  = [aws_db_instance.instance[each.key].id]
  event_categories = [
    "availability",
    "deletion",
    "failure",
    "low storage",
  ]
}

# Alarm if average CPU utilisation is above the threshold (we use 80% for most of our databases) for 60s
resource "aws_cloudwatch_metric_alarm" "rds_cpuutilization" {
  for_each = var.databases

  alarm_name          = "${aws_db_instance.instance[each.key].name}-rds-cpuutilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = each.value.cpuutilization_threshold
  actions_enabled     = true
  alarm_actions       = [data.terraform_remote_state.infra_monitoring.outputs.sns_topic_cloudwatch_alarms_arn]
  alarm_description   = "This metric monitors the percentage of CPU utilization."

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.instance[each.key].id
  }
}

# Alarm if free storage space is below the threshold (we use 10GiB for most of our databases) for 60s
resource "aws_cloudwatch_metric_alarm" "rds_freestoragespace" {
  for_each = var.databases

  alarm_name          = "${aws_db_instance.instance[each.key].name}-rds-freestoragespace"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = each.value.freestoragespace_threshold
  actions_enabled     = true
  alarm_actions       = [data.terraform_remote_state.infra_monitoring.outputs.sns_topic_cloudwatch_alarms_arn]
  alarm_description   = "This metric monitors the amount of available storage space."

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.instance[each.key].id
  }
}


# Outputs
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
