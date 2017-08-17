# == Manifest: projects::app-cache
#
# Frontend application servers
#
# === Variables:
#
# aws_region
# stackname
# aws_environment
# ssh_public_key
# elb_certname
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

variable "elb_certname" {
  type        = "string"
  description = "The ACM cert domain name to find the ARN of"
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

data "aws_acm_certificate" "elb_cert" {
  domain   = "${var.elb_certname}"
  statuses = ["ISSUED"]
}

resource "aws_elb" "cache_elb" {
  name            = "${var.stackname}-cache"
  subnets         = ["${data.terraform_remote_state.infra_networking.private_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_cache_elb_id}"]
  internal        = "true"

  listener {
    instance_port     = 80
    instance_protocol = "http"
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

  tags = "${map("Name", "${var.stackname}-cache", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "cache")}"
}

resource "aws_route53_record" "cache_service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.internal_zone_id}"
  name    = "cache.${data.terraform_remote_state.infra_stack_dns_zones.internal_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.cache_elb.dns_name}"
    zone_id                = "${aws_elb.cache_elb.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_elb" "cache_external_elb" {
  name            = "${var.stackname}-cache-external"
  subnets         = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_cache_external_elb_id}"]
  internal        = "false"

  listener {
    instance_port     = 80
    instance_protocol = "http"
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

  tags = "${map("Name", "${var.stackname}-cache", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "cache")}"
}

resource "aws_route53_record" "cache_external_service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.external_zone_id}"
  name    = "cache.${data.terraform_remote_state.infra_stack_dns_zones.external_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.cache_external_elb.dns_name}"
    zone_id                = "${aws_elb.cache_external_elb.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "app_service_records" {
  count   = "${length(var.app_service_records)}"
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.external_zone_id}"
  name    = "${element(var.app_service_records, count.index)}.${data.terraform_remote_state.infra_stack_dns_zones.external_domain_name}"
  type    = "CNAME"
  records = ["cache.${data.terraform_remote_state.infra_stack_dns_zones.external_domain_name}"]
  ttl     = "300"
}

module "cache" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-cache"
  vpc_id                        = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "cache", "aws_hostname", "cache-1")}"
  instance_subnet_ids           = "${data.terraform_remote_state.infra_networking.private_subnet_ids}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_cache_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "t2.medium"
  create_instance_key           = true
  instance_key_name             = "${var.stackname}-cache"
  instance_public_key           = "${var.ssh_public_key}"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids              = ["${aws_elb.cache_elb.id}", "${aws_elb.cache_external_elb.id}"]
  asg_max_size                  = "3"
  asg_min_size                  = "3"
  asg_desired_capacity          = "3"
}

# Outputs
# --------------------------------------------------------------

output "cache_elb_dns_name" {
  value       = "${aws_elb.cache_elb.dns_name}"
  description = "DNS name to access the cache service"
}

output "service_dns_name" {
  value       = "${aws_route53_record.cache_service_record.fqdn}"
  description = "DNS name to access the service"
}

output "cache_external_elb_dns_name" {
  value       = "${aws_elb.cache_external_elb.dns_name}"
  description = "DNS name to access the external cache service"
}

output "external_service_dns_name" {
  value       = "${aws_route53_record.cache_external_service_record.fqdn}"
  description = "DNS name to access the external service"
}
