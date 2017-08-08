# == Manifest: projects::app-backend-lb
#
# Frontend application servers
#
# === Variables:
#
# aws_region
# stackname
# aws_environment
# ssh_public_key
# app_service_records
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

variable "app_service_records" {
  type        = "list"
  description = "List of application service names that get traffic via this loadbalancer"
  default     = []
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

resource "aws_elb" "backend-lb_elb" {
  name            = "${var.stackname}-backend-lb"
  subnets         = ["${data.terraform_remote_state.infra_networking.private_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_backend-lb_elb_id}"]
  internal        = "true"

  listener {
    instance_port     = 443
    instance_protocol = "tcp"
    lb_port           = 443
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3

    target   = "TCP:443"
    interval = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = "${map("Name", "${var.stackname}-backend-lb", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "backend_lb")}"
}

resource "aws_route53_record" "backend-lb_service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.internal_zone_id}"
  name    = "backend-lb.${data.terraform_remote_state.infra_stack_dns_zones.internal_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.backend-lb_elb.dns_name}"
    zone_id                = "${aws_elb.backend-lb_elb.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_elb" "backend-lb_external_elb" {
  name            = "${var.stackname}-backend-lb-external"
  subnets         = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_backend-lb_external_elb_id}"]
  internal        = "false"

  listener {
    instance_port     = 443
    instance_protocol = "tcp"
    lb_port           = 443
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3

    target   = "TCP:443"
    interval = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = "${map("Name", "${var.stackname}-backend-lb_external", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "backend_lb")}"
}

resource "aws_route53_record" "backend-lb_external_service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.external_zone_id}"
  name    = "backend-lb.${data.terraform_remote_state.infra_stack_dns_zones.external_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.backend-lb_external_elb.dns_name}"
    zone_id                = "${aws_elb.backend-lb_external_elb.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "app_service_records" {
  count   = "${length(var.app_service_records)}"
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.external_zone_id}"
  name    = "${element(var.app_service_records, count.index)}.${data.terraform_remote_state.infra_stack_dns_zones.external_domain_name}"
  type    = "CNAME"
  records = ["backend-lb.${data.terraform_remote_state.infra_stack_dns_zones.external_domain_name}"]
}

module "backend-lb" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-backend-lb"
  vpc_id                        = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "backend_lb", "aws_hostname", "backend-lb-1")}"
  instance_subnet_ids           = "${data.terraform_remote_state.infra_networking.private_subnet_ids}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_backend-lb_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "t2.medium"
  create_instance_key           = true
  instance_key_name             = "${var.stackname}-backend-lb"
  instance_public_key           = "${var.ssh_public_key}"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids              = ["${aws_elb.backend-lb_elb.id}", "${aws_elb.backend-lb_external_elb.id}"]
  asg_max_size                  = "2"
  asg_min_size                  = "2"
  asg_desired_capacity          = "2"
}

# Outputs
# --------------------------------------------------------------

output "backend-lb_elb_dns_name" {
  value       = "${aws_elb.backend-lb_elb.dns_name}"
  description = "DNS name to access the backend-lb service"
}

output "service_dns_name" {
  value       = "${aws_route53_record.backend-lb_service_record.fqdn}"
  description = "DNS name to access the service"
}

output "backend-lb_external_elb_dns_name" {
  value       = "${aws_elb.backend-lb_external_elb.dns_name}"
  description = "DNS name to access the backend-lb service"
}

output "external_elb_service_dns_name" {
  value       = "${aws_route53_record.backend-lb_external_service_record.fqdn}"
  description = "DNS name to access the service"
}
