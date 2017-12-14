/**
* ## Module: aws::node_group
*
* This module creates an instance in a autoscaling group that expands
* in the subnets specified by the variable instance_subnet_ids. The instance
* AMI is Ubuntu, you can specify the version with the instance_ami_filter_name
* variable. The machine type can also be configured with a variable.
*
* When the variable create_service_dns_name is set to true, this module
* will create a DNS name service_dns_name in the zone_id specified pointing
* to the ELB record.
*
* Additionally, this module will create an IAM role that we can attach
* policies to in other modules.
*
* You can specify a list of Classic ELB ids to attach to the Autoscaling Group
* with the `instance_elb_ids` variable, or alternatively a list of Target Group ARNs
* to use with Application Load Balancers with the `instance_target_group_arns` variable.
*/
variable "name" {
  type        = "string"
  description = "Jumpbox resources name. Only alphanumeric characters and hyphens allowed"
}

variable "default_tags" {
  type        = "map"
  description = "Additional resource tags"
  default     = {}
}

variable "vpc_id" {
  type        = "string"
  description = "The ID of the VPC in which the jumpbox is created"
}

variable "instance_subnet_ids" {
  type        = "list"
  description = "List of subnet ids where the instance can be deployed"
}

variable "instance_security_group_ids" {
  type        = "list"
  description = "List of security group ids to attach to the ASG"
}

variable "instance_ami_filter_name" {
  type        = "string"
  description = "Name to use to find AMI images for the instance"
  default     = "ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"
}

variable "instance_type" {
  type        = "string"
  description = "Instance type"
  default     = "t2.micro"
}

variable "create_instance_key" {
  type        = "string"
  description = "Whether to create a key pair for the instance launch configuration"
  default     = false
}

variable "instance_key_name" {
  type        = "string"
  description = "Name of the instance key"
  default     = "govuk-infra"
}

variable "instance_public_key" {
  type        = "string"
  description = "The jumpbox default public key material"
  default     = ""
}

variable "instance_user_data" {
  type        = "string"
  description = "User_data provisioning script (default user_data.sh in module directory)"
  default     = "user_data.sh"
}

variable "instance_additional_user_data" {
  type        = "string"
  description = "Append additional user-data script"
  default     = ""
}

variable "instance_default_policy" {
  type        = "string"
  description = "Name of the JSON file containing the default IAM role policy for the instance"
  default     = "default_policy.json"
}

variable "instance_elb_ids" {
  type        = "list"
  description = "A list of the ELB IDs to attach this ASG to"
  default     = []
}

variable "instance_target_group_arns" {
  type        = "list"
  description = "The ARN of the target group with which to register targets."
  default     = []
}

variable "instance_target_group_arns_length" {
  type        = "string"
  description = "Length of instance_target_group_arns"
  default     = 0
}

variable "asg_desired_capacity" {
  type        = "string"
  description = "The autoscaling groups desired capacity"
  default     = "1"
}

variable "asg_max_size" {
  type        = "string"
  description = "The autoscaling groups max_size"
  default     = "1"
}

variable "asg_min_size" {
  type        = "string"
  description = "The autoscaling groups max_size"
  default     = "1"
}

variable "root_block_device_volume_size" {
  type        = "string"
  description = "The size of the instance root volume in gigabytes"
  default     = "20"
}

variable "create_asg_notifications" {
  type        = "string"
  description = "Enable Autoscaling Group notifications"
  default     = true
}

variable "asg_notification_types" {
  type        = "list"
  description = "A list of Notification Types that trigger Autoscaling Group notifications. Acceptable values are documented in https://docs.aws.amazon.com/AutoScaling/latest/APIReference/API_NotificationConfiguration.html"

  default = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
  ]
}

variable "asg_notification_topic_arn" {
  type        = "string"
  description = "The Topic ARN for Autoscaling Group notifications to be sent to"
  default     = ""
}

# Resources
#--------------------------------------------------------------

data "aws_ami" "node_ami_ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["${var.instance_ami_filter_name}"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_iam_role" "node_iam_role" {
  name = "${var.name}"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "node_iam_policy_default" {
  name   = "${var.name}-default"
  path   = "/"
  policy = "${file("${path.module}/${var.instance_default_policy}")}"
}

resource "aws_iam_role_policy_attachment" "node_iam_role_policy_attachment_default" {
  role       = "${aws_iam_role.node_iam_role.name}"
  policy_arn = "${aws_iam_policy.node_iam_policy_default.arn}"
}

resource "aws_iam_instance_profile" "node_instance_profile" {
  name = "${var.name}"
  role = "${aws_iam_role.node_iam_role.name}"
}

resource "aws_key_pair" "node_key" {
  count      = "${var.create_instance_key}"
  key_name   = "${var.instance_key_name}"
  public_key = "${var.instance_public_key}"
}

resource "aws_launch_configuration" "node_launch_configuration" {
  name_prefix   = "${var.name}-"
  image_id      = "${data.aws_ami.node_ami_ubuntu.id}"
  instance_type = "${var.instance_type}"
  user_data     = "${join("\n\n", list(file("${path.module}/${var.instance_user_data}"), var.instance_additional_user_data))}"

  security_groups = ["${var.instance_security_group_ids}"]

  iam_instance_profile        = "${aws_iam_instance_profile.node_instance_profile.name}"
  associate_public_ip_address = false
  key_name                    = "${var.instance_key_name}"

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "${var.root_block_device_volume_size}"
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "null_resource" "node_autoscaling_group_tags" {
  count = "${length(keys(var.default_tags))}"

  triggers {
    key                 = "${element(keys(var.default_tags), count.index)}"
    value               = "${element(values(var.default_tags), count.index)}"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "node_autoscaling_group" {
  name = "${var.name}"

  vpc_zone_identifier = [
    "${var.instance_subnet_ids}",
  ]

  desired_capacity          = "${var.asg_desired_capacity}"
  min_size                  = "${var.asg_min_size}"
  max_size                  = "${var.asg_max_size}"
  health_check_grace_period = "60"
  health_check_type         = "EC2"
  force_delete              = false
  wait_for_capacity_timeout = 0
  launch_configuration      = "${aws_launch_configuration.node_launch_configuration.name}"

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

  tags = ["${concat(
    list(map("key", "Name", "value", "${var.name}", "propagate_at_launch", true)),
    null_resource.node_autoscaling_group_tags.*.triggers)
  }"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_attachment" "node_autoscaling_group_attachment_alb" {
  count                  = "${var.instance_target_group_arns_length}"
  autoscaling_group_name = "${aws_autoscaling_group.node_autoscaling_group.id}"
  alb_target_group_arn   = "${element(var.instance_target_group_arns, count.index)}"
}

resource "aws_autoscaling_attachment" "node_autoscaling_group_attachment_classic" {
  count                  = "${length(var.instance_elb_ids)}"
  autoscaling_group_name = "${aws_autoscaling_group.node_autoscaling_group.id}"
  elb                    = "${element(var.instance_elb_ids, count.index)}"
}

resource "aws_autoscaling_notification" "node_autoscaling_group_notifications" {
  count         = "${var.create_asg_notifications}"
  group_names   = ["${aws_autoscaling_group.node_autoscaling_group.name}"]
  notifications = ["${var.asg_notification_types}"]
  topic_arn     = "${var.asg_notification_topic_arn}"
}

# Outputs
#--------------------------------------------------------------

output "instance_iam_role_name" {
  value       = "${aws_iam_role.node_iam_role.name}"
  description = "Node IAM Role Name. Use with aws_iam_role_policy_attachment to attach specific policies to the node role"
}

output "autoscaling_group_name" {
  value       = "${aws_autoscaling_group.node_autoscaling_group.name}"
  description = "The name of the node auto scaling group."
}
