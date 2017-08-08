# == Manifest: projects::app-exception-handler
#
# Exception Handler node
#
# === Variables:
#
# aws_region
# stackname
# aws_environment
# ssh_public_key
# exception_handler_subnet
#
# === Outputs:
#
# exception_handler_internal_service_dns_name
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

variable "exception_handler_subnet" {
  type        = "string"
  description = "Name of the subnet to place the exception_handler instance 1 and EBS volume"
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

resource "aws_elb" "exception_handler_internal_elb" {
  name            = "${var.stackname}-exception-handler-internal"
  subnets         = ["${data.terraform_remote_state.infra_networking.private_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_exception_handler_internal_elb_id}"]
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

  tags = "${map("Name", "${var.stackname}-exception_handler-internal", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "exception_handler")}"
}

resource "aws_route53_record" "exception_handler_internal_service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.internal_zone_id}"
  name    = "exception-handler.${data.terraform_remote_state.infra_stack_dns_zones.internal_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.exception_handler_internal_elb.dns_name}"
    zone_id                = "${aws_elb.exception_handler_internal_elb.zone_id}"
    evaluate_target_health = true
  }
}

module "exception_handler" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-exception_handler"
  vpc_id                        = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "exception_handler", "aws_hostname", "exception-handler-1")}"
  instance_subnet_ids           = "${matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.exception_handler_subnet))}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_exception_handler_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "t2.medium"
  create_instance_key           = true
  instance_key_name             = "${var.stackname}-exception_handler"
  instance_public_key           = "${var.ssh_public_key}"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids              = ["${aws_elb.exception_handler_internal_elb.id}"]
  root_block_device_volume_size = "20"
}

resource "aws_ebs_volume" "exception_handler-mongodb-data" {
  availability_zone = "${lookup(data.terraform_remote_state.infra_networking.private_subnet_names_azs_map, var.exception_handler_subnet)}"
  size              = 32
  type              = "gp2"

  tags {
    Name            = "${var.stackname}-exception-handler-data"
    Project         = "${var.stackname}"
    Device          = "xvdf"
    aws_stackname   = "${var.stackname}"
    aws_environment = "${var.aws_environment}"
    aws_migration   = "exception_handler"
    aws_hostname    = "exception-handler-1"
  }
}

resource "aws_ebs_volume" "exception_handler-mongodb-backup" {
  availability_zone = "${lookup(data.terraform_remote_state.infra_networking.private_subnet_names_azs_map, var.exception_handler_subnet)}"
  size              = 64
  type              = "gp2"

  tags {
    Name            = "${var.stackname}-exception-handler-mongodb"
    Project         = "${var.stackname}"
    Device          = "xvdg"
    aws_stackname   = "${var.stackname}"
    aws_environment = "${var.aws_environment}"
    aws_migration   = "exception_handler"
    aws_hostname    = "exception-handler-1"
  }
}

resource "aws_iam_policy" "exception_handler_iam_policy" {
  name   = "${var.stackname}-exception_handler-additional"
  path   = "/"
  policy = "${file("${path.module}/additional_policy.json")}"
}

resource "aws_iam_role_policy_attachment" "exception_handler_iam_role_policy_attachment" {
  role       = "${module.exception_handler.instance_iam_role_name}"
  policy_arn = "${aws_iam_policy.exception_handler_iam_policy.arn}"
}

# Outputs
# --------------------------------------------------------------

output "exception_handler_internal_service_dns_name" {
  value       = "${aws_route53_record.exception_handler_internal_service_record.fqdn}"
  description = "DNS name to access the exception_handler internal service"
}
