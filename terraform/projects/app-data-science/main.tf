/**
* ## Project: app-data-science
*
* Data science experimentation playground.
*
* Run resource intensive scripts for data science purposes.
*/
variable "aws_environment" {
  type        = "string"
  description = "AWS environment"
}

variable "aws_region" {
  type        = "string"
  description = "AWS region"
  default     = "eu-west-2"
}

variable "instance_ami_filter_name" {
  type        = "string"
  description = "Name to use to find AMI images"
  default     = ""
}

variable "office_ips" {
  type        = "list"
  description = "An array of CIDR blocks that will be allowed offsite access."
}

variable "stackname" {
  type        = "string"
  description = "Stackname"
}

# Resources
# --------------------------------------------------------------
terraform {
  backend          "s3"             {}
  required_version = "= 0.11.7"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "1.40.0"
}

resource "aws_security_group" "data-science" {
  name        = "${var.stackname}_data-science_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Control access to the data science machines"

  tags {
    Name = "${var.stackname}_data-science_access"
  }
}

resource "aws_security_group_rule" "data-science_ingress_offsite-ssh_ssh" {
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  cidr_blocks       = ["${var.office_ips}"]
  security_group_id = "${aws_security_group.data-science.id}"
}

resource "aws_security_group_rule" "data-science_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.data-science.id}"
}

resource "aws_elb" "data-science_external_elb" {
  name            = "${var.stackname}-data-science"
  subnets         = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups = ["${aws_security_group.data-science.id}"]
  internal        = "false"

  access_logs {
    bucket        = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    bucket_prefix = "elb/${var.stackname}-data-science-external-elb"
    interval      = 60
  }

  listener {
    instance_port     = "22"
    instance_protocol = "tcp"
    lb_port           = "22"
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:22"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = "${map("Name", "${var.stackname}-data-science", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "data-science")}"
}

module "data-science" {
  source                        = "../../modules/aws/node_group"
  name                          = "data-science-1"
  vpc_id                        = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags                  = "${map("aws_environment", var.aws_environment, "aws_migration", "data-science", "aws_hostname", "data-science-1")}"
  instance_subnet_ids           = "${data.terraform_remote_state.infra_networking.private_subnet_ids}"
  instance_security_group_ids   = ["${aws_security_group.data-science.id}"]
  instance_type                 = "p2.xlarge"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids              = ["${aws_elb.data-science_external_elb.id}"]
  instance_elb_ids_length       = "1"
  instance_ami_filter_name      = "${var.instance_ami_filter_name}"
  asg_notification_topic_arn    = "${data.terraform_remote_state.infra_monitoring.sns_topic_autoscaling_group_events_arn}"
  root_block_device_volume_size = "200"
}

module "alarms-elb-data-science-internal" {
  source                         = "../../modules/aws/alarms/elb"
  name_prefix                    = "${var.stackname}-data-science-external"
  alarm_actions                  = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  elb_name                       = "${aws_elb.data-science_external_elb.name}"
  httpcode_backend_4xx_threshold = "0"
  httpcode_backend_5xx_threshold = "0"
  httpcode_elb_4xx_threshold     = "0"
  httpcode_elb_5xx_threshold     = "0"
  surgequeuelength_threshold     = "200"
  healthyhostcount_threshold     = "1"
}

# Outputs
# --------------------------------------------------------------

output "data-science_elb_address" {
  value       = "${aws_elb.data-science_external_elb.dns_name}"
  description = "AWS' internal DNS name for the data-science ELB"
}
