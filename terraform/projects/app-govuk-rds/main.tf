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

variable "internal_zone_name" {
  type        = string
  description = "The name of the Route53 zone that contains internal records"
}

variable "internal_domain_name" {
  type        = string
  description = "The domain name of the internal DNS records, it could be different from the zone name"
}

variable "instance_ami_filter_name" {
  type        = string
  description = "Name to use to find AMI images for the instance"
  default     = "ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"
}

variable "instance_key_name" {
  type        = string
  description = "Name of the instance key"
  default     = "govuk-infra"
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

data "aws_route53_zone" "internal" {
  name         = var.internal_zone_name
  private_zone = true
}

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

resource "aws_route53_record" "database" {
  for_each = var.databases

  zone_id = data.aws_route53_zone.internal.zone_id
  name    = "${each.value.name}-${each.value.engine}.${var.internal_domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [aws_db_instance.instance[each.key].address]
}

# --------------------------------------------------------------

data "aws_ami" "node_ami_ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.instance_ami_filter_name]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  # this is the ID of the Amazon owner of the AMI we use
  owners = ["099720109477"]
}

data "aws_iam_policy_document" "assume_node_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "node_iam_role" {
  name = "${var.stackname}-govuk-rds-role"
  path = "/"

  assume_role_policy = data.aws_iam_policy_document.assume_node_role.json
}

data "aws_iam_policy_document" "node_iam_policy" {
  statement {
    actions = [
      "ec2:DescribeTags",
      "ec2:DescribeInstances",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "node_iam_policy" {
  name = "${var.stackname}-govuk-rds-iam-policy"
  path = "/"

  policy = data.aws_iam_policy_document.node_iam_policy.json
}

resource "aws_iam_role_policy_attachment" "node_iam_policy" {
  role       = aws_iam_role.node_iam_role.name
  policy_arn = aws_iam_policy.node_iam_policy.arn
}

data "aws_iam_policy_document" "node_additional_policy" {
  statement {
    actions = [
      "rds:ModifyDBInstance",
      "rds:DeleteDBInstance",
    ]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "rds:db-tag/scrubber"
      values   = ["scrubber"]
    }
  }


  statement {
    actions = [
      "rds:RestoreDBInstanceFromDBSnapshot",
      "rds:DescribeDBClusterSnapshotAttributes",
      "rds:DescribeDBClusterParameters",
      "rds:DescribeDBEngineVersions",
      "rds:DescribeDBSnapshots",
      "rds:CopyDBSnapshot",
      "rds:CopyDBClusterSnapshot",
      "rds:DescribePendingMaintenanceActions",
      "rds:DescribeDBLogFiles",
      "rds:DescribeDBParameterGroups",
      "rds:DescribeDBSnapshotAttributes",
      "rds:DescribeReservedDBInstancesOfferings",
      "rds:ListTagsForResource",
      "rds:CreateDBSnapshot",
      "rds:CreateDBClusterSnapshot",
      "rds:DescribeDBParameters",
      "rds:ModifyDBClusterSnapshotAttribute",
      "rds:ModifyDBSnapshot",
      "rds:ModifyDBSnapshotAttribute",
      "rds:DeleteDBSnapshot",
      "rds:DescribeDBClusters",
      "rds:DescribeDBClusterParameterGroups",
      "rds:DescribeDBClusterSnapshots",
      "rds:DescribeDBInstances",
      "rds:DescribeEngineDefaultClusterParameters",
      "rds:DescribeOrderableDBInstanceOptions",
      "rds:DescribeEngineDefaultParameters",
      "rds:DescribeCertificates",
      "rds:DescribeEventCategories",
      "rds:DescribeAccountAttributes",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "node_additional_policy" {
  name   = "${var.stackname}-govuk-rds-iam-additional"
  path   = "/"
  policy = data.aws_iam_policy_document.node_additional_policy.json
}

resource "aws_iam_role_policy_attachment" "node_additional_policy" {
  role       = aws_iam_role.node_iam_role.name
  policy_arn = aws_iam_policy.node_additional_policy.arn
}

resource "aws_iam_instance_profile" "node" {
  name = "${var.stackname}-govuk-rds-instance-profile"
  role = aws_iam_role.node_iam_role.name
}

resource "aws_launch_configuration" "node" {
  name_prefix   = "${var.stackname}-govuk-rds-"
  image_id      = data.aws_ami.node_ami_ubuntu.id
  instance_type = "t2.medium"
  user_data     = join("\n\n", [for f in ["00-base", "10-db-admin", "20-puppet-client"] : file("../../userdata/${f}")])

  security_groups = [
    data.terraform_remote_state.infra_security_groups.outputs.sg_db-admin_id,
    data.terraform_remote_state.infra_security_groups.outputs.sg_management_id,
  ]

  iam_instance_profile        = aws_iam_instance_profile.node.name
  associate_public_ip_address = false
  key_name                    = var.instance_key_name

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 512
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "node" {
  for_each = var.databases

  name = "${var.stackname}-govuk-rds-${each.value.name}"

  vpc_zone_identifier = data.terraform_remote_state.infra_networking.outputs.private_subnet_ids

  desired_capacity          = 1
  min_size                  = 1
  max_size                  = 1
  health_check_grace_period = 60
  health_check_type         = "EC2"
  force_delete              = false
  wait_for_capacity_timeout = 0
  launch_configuration      = aws_launch_configuration.node.name

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]

  tags = concat(
    [for k, v in local.tags : { key = k, value = v, propagate_at_launch = true }],
    [{ key = "name", value = "${var.stackname}-govuk-rds-${each.value.name}", propagate_at_launch = true }],
    [{ key = "aws_migration", value = "${replace(each.value.name, "-", "_")}_db_admin", propagate_at_launch = true }],
    [{ key = "aws_hostname", value = "${each.value.name}-db-admin-1", propagate_at_launch = true }]
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_notification" "notifications" {
  for_each = var.databases

  group_names = [aws_autoscaling_group.node[each.key].name]
  topic_arn   = data.terraform_remote_state.infra_monitoring.outputs.sns_topic_autoscaling_group_events_arn
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
  ]
}

# Alarm if there is no instance for 60s
resource "aws_cloudwatch_metric_alarm" "autoscaling_groupinserviceinstances" {
  for_each = var.databases

  alarm_name          = "${aws_autoscaling_group.node[each.key].name}-autoscaling-groupinserviceinstances"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "GroupInServiceInstances"
  namespace           = "AWS/AutoScaling"
  period              = "60"
  statistic           = "Average"
  threshold           = "1"
  actions_enabled     = true
  alarm_actions       = [data.terraform_remote_state.infra_monitoring.outputs.sns_topic_cloudwatch_alarms_arn]
  alarm_description   = "This metric monitors instances in service in an AutoScalingGroup"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.node[each.key].name
  }
}

# Alarm if the average CPU utilisation is over 85% for 60s
resource "aws_cloudwatch_metric_alarm" "ec2_cpuutilization" {
  for_each = var.databases

  alarm_name          = "${aws_autoscaling_group.node[each.key].name}-ec2-cpuutilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "85"
  actions_enabled     = true
  alarm_actions       = [data.terraform_remote_state.infra_monitoring.outputs.sns_topic_cloudwatch_alarms_arn]
  alarm_description   = "This metric monitors CPU utilization in an instance"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.node[each.key].name
  }
}

# Alarm if the EC2 status check is failing for 60s
resource "aws_cloudwatch_metric_alarm" "ec2_statuscheckfailed_instance" {
  for_each = var.databases

  alarm_name          = "${aws_autoscaling_group.node[each.key].name}-ec2-statuscheckfailed_instance"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "StatusCheckFailed_Instance"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "1"
  actions_enabled     = true
  alarm_actions       = [data.terraform_remote_state.infra_monitoring.outputs.sns_topic_cloudwatch_alarms_arn]
  alarm_description   = "This metric monitors the status of the instance status check"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.node[each.key].name
  }
}

# All environments should be able to write to the backups bucket for
# their respective environment.
resource "aws_iam_role_policy_attachment" "write_db-admin_database_backups_iam_role_policy_attachment" {
  role       = aws_iam_role.node_iam_role.name
  policy_arn = data.terraform_remote_state.infra_database_backups_bucket.outputs.dbadmin_write_database_backups_bucket_policy_arn
}

# All environments, except production for safety reasons, should be able to read from the production database
# backups bucket, to enable restoring the backups, and the overnight
# data syncs.
resource "aws_iam_role_policy_attachment" "read_from_production_database_backups_from_production_iam_role_policy_attachment" {
  count      = var.aws_environment != "production" ? 1 : 0
  role       = aws_iam_role.node_iam_role.name
  policy_arn = data.terraform_remote_state.infra_database_backups_bucket.outputs.production_dbadmin_read_database_backups_bucket_policy_arn
}

# integration environment should be able to read integration and staging database backups
resource "aws_iam_role_policy_attachment" "read_from_integration_database_backups_from_integration_iam_role_policy_attachment" {
  count      = var.aws_environment == "integration" ? 1 : 0
  role       = aws_iam_role.node_iam_role.name
  policy_arn = data.terraform_remote_state.infra_database_backups_bucket.outputs.integration_dbadmin_read_database_backups_bucket_policy_arn
}

# staging environment should be able to read staging database backups
resource "aws_iam_role_policy_attachment" "read_from_staging_database_backups_from_integration_iam_role_policy_attachment" {
  count      = var.aws_environment == "staging" ? 1 : 0
  role       = aws_iam_role.node_iam_role.name
  policy_arn = data.terraform_remote_state.infra_database_backups_bucket.outputs.staging_dbadmin_read_database_backups_bucket_policy_arn
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
