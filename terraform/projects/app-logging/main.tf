# == Manifest: projects::app-logging
#
# logging node
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
  description = "logging default public key material"
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

resource "aws_elb" "logging_elb" {
  name            = "${var.stackname}-logging"
  subnets         = ["${data.terraform_remote_state.infra_networking.private_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_logging_elb_id}"]
  internal        = "true"

  listener {
    instance_port     = "514"
    instance_protocol = "tcp"
    lb_port           = "514"
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:514"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = "${map("Name", "${var.stackname}-logging", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "logging")}"
}

resource "aws_route53_record" "service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.internal_zone_id}"
  name    = "logging.${data.terraform_remote_state.infra_stack_dns_zones.internal_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.logging_elb.dns_name}"
    zone_id                = "${aws_elb.logging_elb.zone_id}"
    evaluate_target_health = true
  }
}

module "logging" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-logging"
  vpc_id                        = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "logging", "aws_hostname", "logging-1")}"
  instance_subnet_ids           = "${data.terraform_remote_state.infra_networking.private_subnet_ids}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_logging_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "t2.micro"
  create_instance_key           = true
  instance_key_name             = "${var.stackname}-logging"
  instance_public_key           = "${var.ssh_public_key}"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids              = ["${aws_elb.logging_elb.id}"]
  root_block_device_volume_size = "50"
  asg_max_size                  = "2"
  asg_min_size                  = "2"
  asg_desired_capacity          = "2"
}

# Outputs
# --------------------------------------------------------------

output "logging_elb_address" {
  value       = "${aws_elb.logging_elb.dns_name}"
  description = "AWS' internal DNS name for the logging ELB"
}

output "service_dns_name" {
  value       = "${aws_route53_record.service_record.name}"
  description = "DNS name to access the node service"
}
