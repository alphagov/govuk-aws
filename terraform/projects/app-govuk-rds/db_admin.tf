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
  owners = ["099720109477", "696911096973"]
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
  for_each = var.databases

  name_prefix   = "${var.stackname}-govuk-rds-${each.value.name}-"
  image_id      = data.aws_ami.node_ami_ubuntu.id
  instance_type = "t2.medium"
  user_data     = join("\n\n", [for f in ["00-base", "10-db-admin", "20-puppet-client"] : file("../../userdata/${f}")])

  security_groups = [
    aws_security_group.db_admin[each.key].id,
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
  launch_configuration      = aws_launch_configuration.node[each.key].name

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
    [{ key = "Name", value = "${var.stackname}-govuk-rds-${each.value.name}", propagate_at_launch = true }],
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

  alarm_name          = "${each.value.name}-autoscaling-groupinserviceinstances"
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

  alarm_name          = "${each.value.name}-ec2-cpuutilization"
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

  alarm_name          = "${each.value.name}-ec2-statuscheckfailed_instance"
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
