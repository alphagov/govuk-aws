/**
* ## Project: app-mirrorer
*
* Mirrorer node
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
  default     = ""
}

variable "mirrorer_subnet" {
  type        = "string"
  description = "Subnet to contain mirrorer and its EBS volume"
}

# Resources
# --------------------------------------------------------------
terraform {
  backend          "s3"             {}
  required_version = "= 0.11.6"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "1.14.0"
}

module "mirrorer" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-mirrorer"
  vpc_id                        = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "mirrorer", "aws_hostname", "mirrorer-1")}"
  instance_subnet_ids           = "${matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.mirrorer_subnet))}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_mirrorer_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "t2.large"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids_length       = "0"
  instance_elb_ids              = []
  instance_ami_filter_name      = "${var.instance_ami_filter_name}"
  asg_max_size                  = "1"
  asg_min_size                  = "1"
  asg_desired_capacity          = "1"
  asg_notification_topic_arn    = "${data.terraform_remote_state.infra_monitoring.sns_topic_autoscaling_group_events_arn}"
  root_block_device_volume_size = "30"
}

resource "aws_ebs_volume" "mirrorer" {
  availability_zone = "${lookup(data.terraform_remote_state.infra_networking.private_subnet_names_azs_map, var.mirrorer_subnet)}"
  size              = 100
  type              = "gp2"

  tags {
    Name            = "${var.stackname}-mirrorer"
    Project         = "${var.stackname}"
    Device          = "xvdf"
    aws_hostname    = "mirrorer-1"
    aws_migration   = "mirrorer"
    aws_stackname   = "${var.stackname}"
    aws_environment = "${var.aws_environment}"
  }
}

resource "aws_iam_policy" "mirrorer_iam_policy" {
  name   = "${var.stackname}-mirrorer-additional"
  path   = "/"
  policy = "${file("${path.module}/additional_policy.json")}"
}

resource "aws_iam_role_policy_attachment" "mirrorer_iam_role_policy_attachment" {
  role       = "${module.mirrorer.instance_iam_role_name}"
  policy_arn = "${aws_iam_policy.mirrorer_iam_policy.arn}"
}

module "alarms-autoscaling-mirrorer" {
  source                            = "../../modules/aws/alarms/autoscaling"
  name_prefix                       = "${var.stackname}-mirrorer"
  autoscaling_group_name            = "${module.mirrorer.autoscaling_group_name}"
  alarm_actions                     = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  groupinserviceinstances_threshold = "1"
}

module "alarms-ec2-mirrorer" {
  source                   = "../../modules/aws/alarms/ec2"
  name_prefix              = "${var.stackname}-mirrorer"
  autoscaling_group_name   = "${module.mirrorer.autoscaling_group_name}"
  alarm_actions            = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  cpuutilization_threshold = "85"
}

# Outputs
# --------------------------------------------------------------

