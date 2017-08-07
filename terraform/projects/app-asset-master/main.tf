# == Manifest: projects::app-asset-master
#
# Asset Master node.
#
# === Variables:
#
# aws_region
# stackname
# aws_environment
# ssh_public_key
#
# === Outputs:
#

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

variable "ssh_public_key" {
  type        = "string"
  description = "asset-master default public key material"
}

# Resources
# --------------------------------------------------------------
terraform {
  backend          "s3"             {}
  required_version = "= 0.10.7"
}

provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_efs_file_system" "assets-efs-fs" {
  creation_token = "${var.stackname}-assets"

  tags = "${map("Name", "${var.stackname}-asset-master", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "asset_master")}"
}

resource "aws_efs_mount_target" "assets-mount-target" {
  count          = "${length(data.terraform_remote_state.infra_networking.private_subnet_ids)}"
  file_system_id = "${aws_efs_file_system.assets-efs-fs.id}"
  subnet_id      = "${element(data.terraform_remote_state.infra_networking.private_subnet_ids, count.index)}"
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
  instance_type                 = "m4.large"
  create_instance_key           = true
  instance_key_name             = "${var.stackname}-asset-master"
  instance_public_key           = "${var.ssh_public_key}"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids              = []
  asg_max_size                  = "1"
  asg_min_size                  = "1"
  asg_desired_capacity          = "1"
  root_block_device_volume_size = "30"
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
