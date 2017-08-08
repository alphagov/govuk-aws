# == Manifest: projects::app-mongo
#
# Mongo hosts
#
# === Variables:
#
# aws_region
# stackname
# aws_environment
# ssh_public_key
# mongo_1_subnet
# mongo_2_subnet
# mongo_3_subnet
#
# === Outputs:
#
# mongo_1_service_dns_name
# mongo_2_service_dns_name
# mongo_3_service_dns_name
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

variable "mongo_1_subnet" {
  type        = "string"
  description = "Name of the subnet to place the Router Mongo instance 1 and EBS volume"
}

variable "mongo_2_subnet" {
  type        = "string"
  description = "Name of the subnet to place the Router Mongo 2 and EBS volume"
}

variable "mongo_3_subnet" {
  type        = "string"
  description = "Name of the subnet to place the Router Mongo 3 and EBS volume"
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

resource "aws_key_pair" "mongo_key" {
  key_name   = "${var.stackname}-mongo"
  public_key = "${var.ssh_public_key}"
}

# Instance 1
resource "aws_elb" "mongo_1_elb" {
  name            = "${var.stackname}-mongo-1"
  subnets         = ["${data.terraform_remote_state.infra_networking.private_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_mongo_elb_id}"]
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

  tags = "${map("Name", "${var.stackname}-mongo-1", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "mongo")}"
}

resource "aws_route53_record" "mongo_1_service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.internal_zone_id}"
  name    = "mongo-1.${data.terraform_remote_state.infra_stack_dns_zones.internal_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.mongo_1_elb.dns_name}"
    zone_id                = "${aws_elb.mongo_1_elb.zone_id}"
    evaluate_target_health = true
  }
}

module "mongo-1" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-mongo-1"
  vpc_id                        = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "mongo", "aws_hostname", "mongo-1")}"
  instance_subnet_ids           = "${matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.mongo_1_subnet))}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_mongo_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "m4.large"
  create_instance_key           = false
  instance_key_name             = "${var.stackname}-mongo"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids              = ["${aws_elb.mongo_1_elb.id}"]
  root_block_device_volume_size = "20"
}

# Instance 2
resource "aws_elb" "mongo_2_elb" {
  name            = "${var.stackname}-mongo-2"
  subnets         = ["${data.terraform_remote_state.infra_networking.private_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_mongo_elb_id}"]
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

  tags = "${map("Name", "${var.stackname}-mongo-2", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "mongo")}"
}

resource "aws_route53_record" "mongo_2_service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.internal_zone_id}"
  name    = "mongo-2.${data.terraform_remote_state.infra_stack_dns_zones.internal_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.mongo_2_elb.dns_name}"
    zone_id                = "${aws_elb.mongo_2_elb.zone_id}"
    evaluate_target_health = true
  }
}

module "mongo-2" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-mongo-2"
  vpc_id                        = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "mongo", "aws_hostname", "mongo-2")}"
  instance_subnet_ids           = "${matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.mongo_2_subnet))}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_mongo_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "t2.medium"
  create_instance_key           = false
  instance_key_name             = "${var.stackname}-mongo"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids              = ["${aws_elb.mongo_2_elb.id}"]
  root_block_device_volume_size = "20"
}

# Instance 3
resource "aws_elb" "mongo_3_elb" {
  name            = "${var.stackname}-mongo-3"
  subnets         = ["${data.terraform_remote_state.infra_networking.private_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_mongo_elb_id}"]
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

  tags = "${map("Name", "${var.stackname}-mongo-3", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "mongo")}"
}

resource "aws_route53_record" "mongo_3_service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.internal_zone_id}"
  name    = "mongo-3.${data.terraform_remote_state.infra_stack_dns_zones.internal_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.mongo_3_elb.dns_name}"
    zone_id                = "${aws_elb.mongo_3_elb.zone_id}"
    evaluate_target_health = true
  }
}

module "mongo-3" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-mongo-3"
  vpc_id                        = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "mongo", "aws_hostname", "mongo-3")}"
  instance_subnet_ids           = "${matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.mongo_3_subnet))}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_mongo_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "t2.medium"
  create_instance_key           = false
  instance_key_name             = "${var.stackname}-mongo"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids              = ["${aws_elb.mongo_3_elb.id}"]
  root_block_device_volume_size = "20"
}

# Outputs
# --------------------------------------------------------------

output "mongo_1_service_dns_name" {
  value       = "${aws_route53_record.mongo_1_service_record.fqdn}"
  description = "DNS name to access the Router Mongo 1 internal service"
}

output "mongo_2_service_dns_name" {
  value       = "${aws_route53_record.mongo_2_service_record.fqdn}"
  description = "DNS name to access the Router Mongo 2 internal service"
}

output "mongo_3_service_dns_name" {
  value       = "${aws_route53_record.mongo_3_service_record.fqdn}"
  description = "DNS name to access the Router Mongo 3 internal service"
}
