# == Manifest: projects::app-router-backend
#
# Router backend hosts both Mongo and router-api
#
# === Variables:
#
# aws_region
# stackname
# aws_environment
# ssh_public_key
# router-backend_1_subnet
# router-backend_2_subnet
# router-backend_3_subnet
# elb_internal_certname
#
# === Outputs:
#
# router_backend_1_service_dns_name
# router_backend_2_service_dns_name
# router_backend_3_service_dns_name
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

variable "router-backend_1_subnet" {
  type        = "string"
  description = "Name of the subnet to place the Router Mongo 1"
}

variable "router-backend_2_subnet" {
  type        = "string"
  description = "Name of the subnet to place the Router Mongo 2"
}

variable "router-backend_3_subnet" {
  type        = "string"
  description = "Name of the subnet to place the Router Mongo 3"
}

variable "elb_internal_certname" {
  type        = "string"
  description = "The ACM cert domain name to find the ARN of"
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

data "aws_acm_certificate" "elb_internal_cert" {
  domain   = "${var.elb_internal_certname}"
  statuses = ["ISSUED"]
}

resource "aws_key_pair" "router_backend_key" {
  key_name   = "${var.stackname}-router-backend"
  public_key = "${var.ssh_public_key}"
}

resource "aws_elb" "router_api_elb" {
  name            = "${var.stackname}-router-api"
  subnets         = ["${data.terraform_remote_state.infra_networking.private_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_router-backend_elb_id}"]
  internal        = "true"

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 443
    lb_protocol       = "https"

    ssl_certificate_id = "${data.aws_acm_certificate.elb_internal_cert.arn}"
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

  tags = "${map("Name", "${var.stackname}-router-api", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "router_backend")}"
}

resource "aws_route53_record" "router_api_service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.internal_zone_id}"
  name    = "router-api.${data.terraform_remote_state.infra_stack_dns_zones.internal_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.router_api_elb.dns_name}"
    zone_id                = "${aws_elb.router_api_elb.zone_id}"
    evaluate_target_health = true
  }
}

# Instance 1
resource "aws_elb" "router_backend_1_elb" {
  name            = "${var.stackname}-router-backend-1"
  subnets         = ["${data.terraform_remote_state.infra_networking.private_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_router-backend_elb_id}"]
  internal        = "true"

  listener {
    instance_port     = 27017
    instance_protocol = "tcp"
    lb_port           = 27017
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3

    target   = "TCP:27017"
    interval = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = "${map("Name", "${var.stackname}-router-backend-1", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "router_backend")}"
}

resource "aws_route53_record" "router_backend_1_service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.internal_zone_id}"
  name    = "router-backend-1.${data.terraform_remote_state.infra_stack_dns_zones.internal_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.router_backend_1_elb.dns_name}"
    zone_id                = "${aws_elb.router_backend_1_elb.zone_id}"
    evaluate_target_health = true
  }
}

module "router-backend-1" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-router-backend-1"
  vpc_id                        = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "router_backend", "aws_hostname", "router-backend-1")}"
  instance_subnet_ids           = "${matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.router-backend_1_subnet))}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_router-backend_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "t2.medium"
  create_instance_key           = false
  instance_key_name             = "${var.stackname}-router-backend"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids              = ["${aws_elb.router_backend_1_elb.id}", "${aws_elb.router_api_elb.id}"]
  root_block_device_volume_size = "20"
}

# Instance 2
resource "aws_elb" "router_backend_2_elb" {
  name            = "${var.stackname}-router-backend-2"
  subnets         = ["${data.terraform_remote_state.infra_networking.private_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_router-backend_elb_id}"]
  internal        = "true"

  listener {
    instance_port     = 27017
    instance_protocol = "tcp"
    lb_port           = 27017
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3

    target   = "TCP:27017"
    interval = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = "${map("Name", "${var.stackname}-router-backend-2", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "router_backend")}"
}

resource "aws_route53_record" "router_backend_2_service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.internal_zone_id}"
  name    = "router-backend-2.${data.terraform_remote_state.infra_stack_dns_zones.internal_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.router_backend_2_elb.dns_name}"
    zone_id                = "${aws_elb.router_backend_2_elb.zone_id}"
    evaluate_target_health = true
  }
}

module "router-backend-2" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-router-backend-2"
  vpc_id                        = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "router_backend", "aws_hostname", "router-backend-2")}"
  instance_subnet_ids           = "${matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.router-backend_2_subnet))}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_router-backend_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "t2.medium"
  create_instance_key           = false
  instance_key_name             = "${var.stackname}-router-backend"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids              = ["${aws_elb.router_backend_2_elb.id}", "${aws_elb.router_api_elb.id}"]
  root_block_device_volume_size = "20"
}

# Instance 3
resource "aws_elb" "router_backend_3_elb" {
  name            = "${var.stackname}-router-backend-3"
  subnets         = ["${data.terraform_remote_state.infra_networking.private_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_router-backend_elb_id}"]
  internal        = "true"

  listener {
    instance_port     = 27017
    instance_protocol = "tcp"
    lb_port           = 27017
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3

    target   = "TCP:27017"
    interval = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = "${map("Name", "${var.stackname}-router-backend-3", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "router_backend")}"
}

resource "aws_route53_record" "router_backend_3_service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.internal_zone_id}"
  name    = "router-backend-3.${data.terraform_remote_state.infra_stack_dns_zones.internal_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.router_backend_3_elb.dns_name}"
    zone_id                = "${aws_elb.router_backend_3_elb.zone_id}"
    evaluate_target_health = true
  }
}

module "router-backend-3" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-router-backend-3"
  vpc_id                        = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "router_backend", "aws_hostname", "router-backend-3")}"
  instance_subnet_ids           = "${matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.router-backend_3_subnet))}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_router-backend_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "t2.medium"
  create_instance_key           = false
  instance_key_name             = "${var.stackname}-router-backend"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids              = ["${aws_elb.router_backend_3_elb.id}", "${aws_elb.router_api_elb.id}"]
  root_block_device_volume_size = "20"
}

# Outputs
# --------------------------------------------------------------

output "router_api_service_dns_name" {
  value       = "${aws_route53_record.router_api_service_record.fqdn}"
  description = "DNS name to access the router-api internal service"
}

output "router_backend_1_service_dns_name" {
  value       = "${aws_route53_record.router_backend_1_service_record.fqdn}"
  description = "DNS name to access the Router Mongo 1 internal service"
}

output "router_backend_2_service_dns_name" {
  value       = "${aws_route53_record.router_backend_2_service_record.fqdn}"
  description = "DNS name to access the Router Mongo 2 internal service"
}

output "router_backend_3_service_dns_name" {
  value       = "${aws_route53_record.router_backend_3_service_record.fqdn}"
  description = "DNS name to access the Router Mongo 3 internal service"
}
