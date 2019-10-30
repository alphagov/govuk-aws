/*
* ## Project: app-prometheus
*
* Prometheus node
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

variable "instance_ami_filter_name" {
  type        = "string"
  description = "Name to use to find AMI images"

  #  default     = "ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"
  default = "ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"
}

variable "prometheus_1_subnet" {
  type        = "string"
  description = "Name of the subnet to place the Prometheus instance and EBS volume"
}

variable "instance_type" {
  type        = "string"
  description = "Instance type used for EC2 resources"
  default     = "t3.micro"
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

module "prometheus-1" {
  source       = "../../modules/aws/node_group"
  name         = "${var.stackname}-prometheus-1"
  default_tags = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment",
var.aws_environment, "aws_migration", "prometheus", "aws_hostname", "prometheus-1")}"

  instance_subnet_ids = "${matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map),
keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.prometheus_1_subnet))}"

  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_prometheus_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "${var.instance_type}"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_ami_filter_name      = "${var.instance_ami_filter_name}"
  asg_notification_topic_arn    = "${data.terraform_remote_state.infra_monitoring.sns_topic_autoscaling_group_events_arn}"
}

resource "aws_ebs_volume" "prometheus-1" {
  availability_zone = "${lookup(data.terraform_remote_state.infra_networking.private_subnet_names_azs_map, var.prometheus_1_subnet)}"
  size              = 64
  type              = "gp2"

  tags {
    Name            = "${var.stackname}-prometheus-1"
    Project         = "${var.stackname}"
    Device          = "xvdf"
    aws_stackname   = "${var.stackname}"
    aws_environment = "${var.aws_environment}"
    aws_migration   = "prometheus"
    aws_hostname    = "prometheus-1"
  }
}

resource "aws_iam_policy" "prometheus_1_iam_policy" {
  name   = "${var.stackname}-prometheus-1-additional"
  path   = "/"
  policy = "${file("${path.module}/additional_policy.json")}"
}

resource "aws_iam_role_policy_attachment" "prometheus_1_iam_role_policy_attachment" {
  role       = "${module.prometheus-1.instance_iam_role_name}"
  policy_arn = "${aws_iam_policy.prometheus_1_iam_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "prometheus_1_iam_role_policy_cloudwatch_attachment" {
  role       = "${module.prometheus-1.instance_iam_role_name}"
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
}
