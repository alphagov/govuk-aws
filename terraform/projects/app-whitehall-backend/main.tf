# == Manifest: projects::app-whitehall-backend
#
# Backend node
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
  description = "whitehall-backend default public key material"
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

resource "aws_elb" "whitehall-backend_external_elb" {
  name            = "${var.stackname}-whitehall-backend"
  subnets         = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_offsite_ssh_id}"]
  internal        = "false"

  listener {
    instance_port     = "443"
    instance_protocol = "tcp"
    lb_port           = "443"
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:443"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = "${map("Name", "${var.stackname}-whitehall-backend", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "whitehall_backend")}"
}

resource "aws_route53_record" "service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.external_zone_id}"
  name    = "whitehall-backend.${data.terraform_remote_state.infra_stack_dns_zones.external_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.whitehall-backend_external_elb.dns_name}"
    zone_id                = "${aws_elb.whitehall-backend_external_elb.zone_id}"
    evaluate_target_health = true
  }
}

module "whitehall-backend" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-whitehall-backend"
  vpc_id                        = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "whitehall_backend", "aws_hostname", "whitehall-backend-1")}"
  instance_subnet_ids           = "${data.terraform_remote_state.infra_networking.private_subnet_ids}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_whitehall-backend_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "t2.micro"
  create_instance_key           = true
  instance_key_name             = "${var.stackname}-whitehall-backend"
  instance_public_key           = "${var.ssh_public_key}"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids              = ["${aws_elb.whitehall-backend_external_elb.id}"]
  asg_max_size                  = "2"
  asg_min_size                  = "2"
  asg_desired_capacity          = "2"
}

# Outputs
# --------------------------------------------------------------

output "whitehall-backend_elb_address" {
  value       = "${aws_elb.whitehall-backend_external_elb.dns_name}"
  description = "AWS' internal DNS name for the whitehall-backend ELB"
}

output "service_dns_name" {
  value       = "${aws_route53_record.service_record.name}"
  description = "DNS name to access the node service"
}
