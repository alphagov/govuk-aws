# == Manifest: projects::app-jumpbox
#
# Jumpbox node
#
# === Variables:
#
# aws_region
# stackname
# aws_environment
# ssh_public_key
# instance_ami_filter_name
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
  description = "Jumpbox default public key material"
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
  required_version = "= 0.10.7"
}

provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_elb" "jumpbox_external_elb" {
  name            = "${var.stackname}-jumpbox"
  subnets         = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_offsite_ssh_id}"]
  internal        = "false"

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

  tags = "${map("Name", "${var.stackname}-jumpbox", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "jumpbox")}"
}

resource "aws_route53_record" "service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.external_zone_id}"
  name    = "jumpbox.${data.terraform_remote_state.infra_stack_dns_zones.external_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.jumpbox_external_elb.dns_name}"
    zone_id                = "${aws_elb.jumpbox_external_elb.zone_id}"
    evaluate_target_health = true
  }
}

module "jumpbox" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-jumpbox"
  vpc_id                        = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "jumpbox", "aws_hostname", "jumpbox-1")}"
  instance_subnet_ids           = "${data.terraform_remote_state.infra_networking.private_subnet_ids}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_jumpbox_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "t2.micro"
  create_instance_key           = true
  instance_key_name             = "${var.stackname}-jumpbox"
  instance_public_key           = "${var.ssh_public_key}"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids              = ["${aws_elb.jumpbox_external_elb.id}"]
  instance_ami_filter_name      = "${var.instance_ami_filter_name}"
  root_block_device_volume_size = "64"
}

# Outputs
# --------------------------------------------------------------

output "jumpbox_elb_address" {
  value       = "${aws_elb.jumpbox_external_elb.dns_name}"
  description = "AWS' internal DNS name for the jumpbox ELB"
}

output "service_dns_name" {
  value       = "${aws_route53_record.service_record.name}"
  description = "DNS name to access the node service"
}
