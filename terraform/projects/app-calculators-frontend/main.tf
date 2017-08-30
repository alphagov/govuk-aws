# == Manifest: projects::app-calculators-frontend
#
# Calculators Frontend application servers
#
# === Variables:
#
# aws_region
# stackname
# aws_environment
# ssh_public_key
# elb_certname
# asg_max_size
# asg_min_size
# asg_desired_capacity
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

variable "elb_certname" {
  type        = "string"
  description = "The ACM cert domain name to find the ARN of"
}

variable "asg_max_size" {
  type        = "string"
  description = "The maximum size of the autoscaling group"
  default     = "2"
}

variable "asg_min_size" {
  type        = "string"
  description = "The minimum size of the autoscaling group"
  default     = "2"
}

variable "asg_desired_capacity" {
  type        = "string"
  description = "The desired capacity of the autoscaling group"
  default     = "2"
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

data "aws_acm_certificate" "elb_cert" {
  domain   = "${var.elb_certname}"
  statuses = ["ISSUED"]
}

resource "aws_elb" "calculators-frontend_elb" {
  name            = "${var.stackname}-calculators-frontend"
  subnets         = ["${data.terraform_remote_state.infra_networking.private_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_calculators-frontend_elb_id}"]
  internal        = "true"

  listener {
    instance_port     = 80
    instance_protocol = "https"
    lb_port           = 443
    lb_protocol       = "https"

    ssl_certificate_id = "${data.aws_acm_certificate.elb_cert.arn}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3

    target   = "TCP:80"
    interval = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = "${map("Name", "${var.stackname}-calculators-frontend", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "calculators_frontend")}"
}

resource "aws_route53_record" "service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.internal_zone_id}"
  name    = "calculators-frontend.${data.terraform_remote_state.infra_stack_dns_zones.internal_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.calculators-frontend_elb.dns_name}"
    zone_id                = "${aws_elb.calculators-frontend_elb.zone_id}"
    evaluate_target_health = true
  }
}

module "calculators-frontend" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-calculators-frontend"
  vpc_id                        = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "calculators_frontend", "aws_hostname", "calculators-frontend-1")}"
  instance_subnet_ids           = "${data.terraform_remote_state.infra_networking.private_subnet_ids}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_calculators-frontend_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "t2.medium"
  create_instance_key           = true
  instance_key_name             = "${var.stackname}-calculators-frontend"
  instance_public_key           = "${var.ssh_public_key}"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids              = ["${aws_elb.calculators-frontend_elb.id}"]
  asg_max_size                  = "${var.asg_max_size}"
  asg_min_size                  = "${var.asg_min_size}"
  asg_desired_capacity          = "${var.asg_desired_capacity}"
}

# Outputs
# --------------------------------------------------------------

output "calculators-frontend_elb_dns_name" {
  value       = "${aws_elb.calculators-frontend_elb.dns_name}"
  description = "DNS name to access the calculators-frontend service"
}

output "service_dns_name" {
  value       = "${aws_route53_record.service_record.name}"
  description = "DNS name to access the node service"
}
