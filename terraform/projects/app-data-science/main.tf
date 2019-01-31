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
  default     = "Deep Learning AMI (Ubuntu) Version 21.0"
}

variable "data_science_1_subnet" {
  type        = "string"
  description = "Name of the subnet to place the data science instance 1"
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

module "data-science" {
  source                        = "../../modules/aws/node_group"
  name                          = "data-science-1"
  vpc_id                        = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags                  = "${map("aws_environment", var.aws_environment, "aws_migration", "data_science", "aws_hostname", "data-science-1")}"
  instance_subnet_ids           = "${matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.data_science_1_subnet))}"
  instance_security_group_ids   = ["${aws_security_group.data-science.id}"]
  instance_type                 = "C5.4xlarge"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_ami_filter_name      = "${var.instance_ami_filter_name}"
  asg_notification_topic_arn    = "${data.terraform_remote_state.infra_monitoring.sns_topic_autoscaling_group_events_arn}"
  root_block_device_volume_size = "20"
}
