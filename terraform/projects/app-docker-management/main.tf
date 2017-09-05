# == Manifest: projects::app-docker_management
#
# Docker node from the 'management' VDC
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
  description = "Default public key material"
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
  required_version = "= 0.9.10"
}

provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_elb" "docker_management_etcd_elb" {
  name            = "${var.stackname}-docker-management-etcd"
  subnets         = ["${data.terraform_remote_state.infra_networking.private_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_docker_management_etcd_elb_id}"]
  internal        = "true"

  listener {
    instance_port     = 2379
    instance_protocol = "tcp"
    lb_port           = 2379
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3

    target   = "TCP:2379"
    interval = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = "${map("Name", "${var.stackname}-docker_management_etcd", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "docker_management_etcd")}"
}

resource "aws_route53_record" "docker_management_etcd_service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.internal_zone_id}"
  name    = "etcd.${data.terraform_remote_state.infra_stack_dns_zones.internal_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.docker_management_etcd_elb.dns_name}"
    zone_id                = "${aws_elb.docker_management_etcd_elb.zone_id}"
    evaluate_target_health = true
  }
}

# TODO: Add external record when we have the external zones working

module "docker_management" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-docker_management"
  vpc_id                        = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "docker_management", "aws_hostname", "docker-management-1")}"
  instance_subnet_ids           = "${data.terraform_remote_state.infra_networking.private_subnet_ids}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_docker_management_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "t2.medium"
  create_instance_key           = true
  instance_key_name             = "${var.stackname}-docker_management"
  instance_public_key           = "${var.ssh_public_key}"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids              = ["${aws_elb.docker_management_etcd_elb.id}"]
  instance_ami_filter_name      = "${var.instance_ami_filter_name}"
}

# Outputs
# --------------------------------------------------------------

output "docker_management_etcd_elb_dns_name" {
  value       = "${aws_elb.docker_management_etcd_elb.dns_name}"
  description = "DNS name to access the docker_management service"
}

output "etcd_service_dns_name" {
  value       = "${aws_route53_record.docker_management_etcd_service_record.fqdn}"
  description = "DNS name to access the node service"
}
