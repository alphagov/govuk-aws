# == Manifest: projects::app-apt
#
# Apt node
#
# === Variables:
#
# aws_environment
# aws_region
# stackname
# ssh_public_key
# apt_1_subnet
#
# === Outputs:
#

variable "aws_environment" {
  type        = "string"
  description = "AWS environment"
}

variable "aws_region" {
  type        = "string"
  description = "AWS region"
  default     = "eu-west-1"
}

variable "stackname" {
  type        = "string"
  description = "Stackname"
}

variable "ssh_public_key" {
  type        = "string"
  description = "Default public key material"
}

variable "apt_1_subnet" {
  type        = "string"
  description = "Name of the subnet to place the apt instance 1 and EBS volume"
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

resource "aws_elb" "apt_external_elb" {
  name            = "${var.stackname}-apt-external"
  subnets         = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_apt_external_elb_id}"]
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

  tags = "${map("Name", "${var.stackname}-apt-external", "Project", var.stackname, "aws_migration", "apt")}"
}

resource "aws_elb" "apt_internal_elb" {
  name            = "${var.stackname}-apt-internal"
  subnets         = ["${data.terraform_remote_state.infra_networking.private_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_apt_internal_elb_id}"]
  internal        = "true"

  listener {
    instance_port     = 80
    instance_protocol = "tcp"
    lb_port           = 80
    lb_protocol       = "tcp"
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

  tags = "${map("Name", "${var.stackname}-apt-internal", "Project", var.stackname, "aws_migration", "apt", "aws_environment", var.aws_environment)}"
}

resource "aws_route53_record" "apt_internal_service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.internal_zone_id}"
  name    = "apt.${data.terraform_remote_state.infra_stack_dns_zones.internal_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.apt_internal_elb.dns_name}"
    zone_id                = "${aws_elb.apt_internal_elb.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "gemstash_internal_service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.internal_zone_id}"
  name    = "gemstash.${data.terraform_remote_state.infra_stack_dns_zones.internal_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.apt_internal_elb.dns_name}"
    zone_id                = "${aws_elb.apt_internal_elb.zone_id}"
    evaluate_target_health = true
  }
}

module "apt-1" {
  source                               = "../../modules/aws/node_group"
  name                                 = "${var.stackname}-apt-1"
  vpc_id                               = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags                         = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "apt", "aws_hostname", "apt-1")}"
  instance_subnet_ids                  = "${matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.apt_1_subnet))}"
  instance_security_group_ids          = ["${data.terraform_remote_state.infra_security_groups.sg_apt_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                        = "t2.medium"
  create_instance_key                  = true
  instance_key_name                    = "${var.stackname}-apt-1"
  instance_public_key                  = "${var.ssh_public_key}"
  instance_additional_user_data        = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids                     = ["${aws_elb.apt_internal_elb.id}", "${aws_elb.apt_external_elb.id}"]
  root_block_device_volume_size        = "20"
}

resource "aws_ebs_volume" "apt-1" {
  availability_zone = "${lookup(data.terraform_remote_state.infra_networking.private_subnet_names_azs_map, var.apt_1_subnet)}"
  size              = 40
  type              = "gp2"

  tags {
    Name            = "${var.stackname}-apt-1"
    Project         = "${var.stackname}"
    aws_hostname    = "apt-1"
    aws_migration   = "apt"
    aws_stackname   = "${var.stackname}"
    aws_environment = "${var.aws_environment}"
  }
}

resource "aws_iam_policy" "apt_1_iam_policy" {
  name   = "${var.stackname}-apt-1-additional"
  path   = "/"
  policy = "${file("${path.module}/additional_policy.json")}"
}

resource "aws_iam_role_policy_attachment" "apt_1_iam_role_policy_attachment" {
  role       = "${module.apt-1.instance_iam_role_name}"
  policy_arn = "${aws_iam_policy.apt_1_iam_policy.arn}"
}

# Outputs
# --------------------------------------------------------------

output "apt_internal_service_dns_name" {
  value       = "${aws_route53_record.apt_internal_service_record.fqdn}"
  description = "DNS name to access the apt internal service"
}

output "apt_external_elb_dns_name" {
  value       = "${aws_elb.apt_external_elb.dns_name}"
  description = "DNS name to access the apt external ELB"
}
