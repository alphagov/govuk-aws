/**
* ## Project: app-asset-master
*
* Asset Master node.
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

# Resources
# --------------------------------------------------------------
terraform {
  backend          "s3"             {}
  required_version = "= 0.11.7"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "1.14.0"
}

resource "aws_efs_file_system" "assets-efs-fs" {
  creation_token = "${var.stackname}-assets"

  tags = "${map("Name", "${var.stackname}-asset-master", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "asset_master")}"
}

resource "aws_efs_mount_target" "assets-mount-target" {
  count           = "${length(data.terraform_remote_state.infra_networking.private_subnet_ids)}"
  file_system_id  = "${aws_efs_file_system.assets-efs-fs.id}"
  subnet_id       = "${element(data.terraform_remote_state.infra_networking.private_subnet_ids, count.index)}"
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_asset-master-efs_id}"]
}

resource "aws_route53_record" "assets_service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.internal_zone_id}"
  name    = "assets.${data.terraform_remote_state.infra_stack_dns_zones.internal_domain_name}"
  type    = "CNAME"
  records = ["${aws_efs_mount_target.assets-mount-target.0.dns_name}"]
  ttl     = "300"
}

module "asset-master" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-asset-master"
  vpc_id                        = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "asset_master", "aws_hostname", "asset-master-1")}"
  instance_subnet_ids           = "${data.terraform_remote_state.infra_networking.private_subnet_ids}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_asset-master_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "m5.large"
  instance_ami_filter_name      = "${var.instance_ami_filter_name}"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids_length       = "0"
  instance_elb_ids              = []
  asg_max_size                  = "1"
  asg_min_size                  = "1"
  asg_desired_capacity          = "1"
  asg_notification_topic_arn    = "${data.terraform_remote_state.infra_monitoring.sns_topic_autoscaling_group_events_arn}"
  root_block_device_volume_size = "30"
}

module "alarms-autoscaling-asset-master" {
  source                            = "../../modules/aws/alarms/autoscaling"
  name_prefix                       = "${var.stackname}-asset-master"
  autoscaling_group_name            = "${module.asset-master.autoscaling_group_name}"
  alarm_actions                     = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  groupinserviceinstances_threshold = "1"
}

module "alarms-ec2-asset-master" {
  source                   = "../../modules/aws/alarms/ec2"
  name_prefix              = "${var.stackname}-asset-master"
  autoscaling_group_name   = "${module.asset-master.autoscaling_group_name}"
  alarm_actions            = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  cpuutilization_threshold = "85"
}

# Outputs
# --------------------------------------------------------------
output "efs_mount_target_dns_names" {
  value       = "${aws_efs_mount_target.assets-mount-target.0.dns_name}"
  description = "DNS name for the mount targets"
}

output "assets_service_record" {
  value       = "${aws_route53_record.assets_service_record.name}"
  description = "DNS service name for assets"
}
