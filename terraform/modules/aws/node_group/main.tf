# == Module: aws::node_group
#
# This module creates an instance in a autoscaling group that expands
# in the subnets specified by the variable instance_subnet_ids. An ELB
# is also provisioned to access the instance. The instance AMI is Ubuntu,
# you can specify the version with the instance_ami_filter_name variable.
# The machine type can also be configured with a variable.
#
# When the variable create_service_dns_name is set to true, this module
# will create a DNS name service_dns_name in the zone_id specified pointing
# to the ELB record.
#
# Additionally, this module will create an IAM role that we can attach
# policies to in other modules.
#
# === Variables:
#
# name
# vpc_id
# default_tags
# elb_subnet_ids
# elb_security_group_ids
# instance_subnet_ids
# instance_security_group_ids
# create_service_dns_name
# service_dns_name
# zone_id
# instance_ami_filter_name
# instance_type
# create_instance_key
# instance_key_name
# instance_public_key
# instance_user_data_file
# instance_additional_user_data_script
#
# === Outputs:
#
# instance_dns_name
# instance_iam_role_id
#

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

variable "elb_subnet_ids" {
  type        = "list"
  description = "List of subnet ids where the jumpbox ELB can be deployed"
}

variable "elb_security_group_ids" {
  type        = "list"
  description = "List of security group ids to attach to the ELB"
}

variable "elb_listener_instance_port" {
  type        = "string"
  description = "ELB listener instance port"
}

variable "elb_listener_instance_protocol" {
  type        = "string"
  description = "ELB listener instance protocol"
  default     = "tcp"
}

variable "elb_listener_lb_port" {
  type        = "string"
  description = "ELB listener lb port"
}

variable "elb_listener_lb_protocol" {
  type        = "string"
  description = "ELB listener lb protocol"
  default     = "tcp"
}

variable "elb_health_check_target" {
  type        = "string"
  description = "ELB health_check target"
}

variable "instance_subnet_ids" {
  type        = "list"
  description = "List of subnet ids where the instance can be deployed"
}

variable "instance_security_group_ids" {
  type        = "list"
  description = "List of security group ids to attach to the ASG"
}

variable "create_service_dns_name" {
  type        = "string"
  description = "Whether to add a DNS Alias to resolve the ELB service record"
  default     = false
}

variable "service_dns_name" {
  type        = "string"
  description = "Service DNS name, when service_dns_name_enable is true"
  default     = ""
}

variable "zone_id" {
  type        = "string"
  description = "Route53 Zone ID to add the service DNS record, when service_dns_name_enable is true"
  default     = ""
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
}

variable "instance_public_key" {
  type        = "string"
  description = "The jumpbox default public key material"
  default     = ""
}

variable "instance_user_data_file" {
  type        = "string"
  description = "Name of template file containing the instance user_data provisioning script"
  default     = "user_data.sh"
}

variable "instance_additional_user_data_script" {
  type        = "string"
  description = "Append addition user-data script"
  default     = ""
}

# Resources
#--------------------------------------------------------------
resource "aws_elb" "node_elb" {
  name            = "${var.name}"
  subnets         = ["${var.elb_subnet_ids}"]
  security_groups = ["${var.elb_security_group_ids}"]

  listener {
    instance_port     = "${var.elb_listener_instance_port}"
    instance_protocol = "${var.elb_listener_instance_protocol}"
    lb_port           = "${var.elb_listener_lb_port}"
    lb_protocol       = "${var.elb_listener_lb_protocol}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "${var.elb_health_check_target}"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = "${merge(var.default_tags, map("Name", var.name))}"
}

resource "aws_route53_record" "service_record" {
  count   = "${var.create_service_dns_name}"
  zone_id = "${var.zone_id}"
  name    = "${var.service_dns_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.node_elb.dns_name}"
    zone_id                = "${aws_elb.node_elb.zone_id}"
    evaluate_target_health = true
  }
}

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

data "template_file" "node_user_data" {
  template = "${file("${path.module}/${var.instance_user_data_file}")}"

  vars {
    additional_user_data_script = "${var.instance_additional_user_data_script}"
  }
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
  user_data     = "${data.template_file.node_user_data.rendered}"

  security_groups = ["${var.instance_security_group_ids}"]

  iam_instance_profile        = "${aws_iam_instance_profile.node_instance_profile.name}"
  associate_public_ip_address = false
  key_name                    = "${var.instance_key_name}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "node_autoscaling_group" {
  name = "${var.name}"

  vpc_zone_identifier = [
    "${var.instance_subnet_ids}",
  ]

  desired_capacity          = "1"
  min_size                  = "1"
  max_size                  = "1"
  health_check_grace_period = "60"
  health_check_type         = "EC2"
  force_delete              = false
  wait_for_capacity_timeout = 0
  launch_configuration      = "${aws_launch_configuration.node_launch_configuration.name}"
  load_balancers            = ["${aws_elb.node_elb.name}"]

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

  tag {
    key                 = "Name"
    value               = "${var.name}"
    propagate_at_launch = true
  }

#  tag {
#    count               = "${length(var.default_tags)}"
#    key                 = "${element(keys(var.default_tags), count.index)}"
#    value               = "${element(values(var.default_tags), count.index)}"
#    propagate_at_launch = true
#  }

  lifecycle {
    create_before_destroy = true
  }
}

# Outputs
#--------------------------------------------------------------
output "service_dns_name" {
  value       = "${var.create_service_dns_name == 1 ? var.service_dns_name : aws_elb.node_elb.dns_name}"
  description = "DNS name to access the node service"
}

output "instance_iam_role_id" {
  value       = "${aws_iam_role.node_iam_role.id}"
  description = "Node IAM Role ID. Use with aws_iam_role_policy resources to attach specific permissions to the node profile"
}

