# == Manifest: projects::app-mapit
#
# Mapit node
#
# === Variables:
#
# aws_environment
# aws_region
# stackname
# ssh_public_key
# mapit_1_subnet
# mapit_2_subnet
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

variable "mapit_1_subnet" {
  type        = "string"
  description = "Name of the subnet to place the mapit instance 1 and EBS volume"
}

variable "mapit_2_subnet" {
  type        = "string"
  description = "Name of the subnet to place the mapit instance 1 and EBS volume"
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

resource "aws_elb" "mapit_elb" {
  name            = "${var.stackname}-mapit-internal"
  subnets         = ["${data.terraform_remote_state.infra_networking.private_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_mapit_elb_id}"]
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

  tags = "${map("Name", "${var.stackname}-mapit-internal", "Project", var.stackname, "aws_migration", "mapit", "aws_environment", var.aws_environment)}"
}

resource "aws_route53_record" "mapit_service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.internal_zone_id}"
  name    = "mapit.${data.terraform_remote_state.infra_stack_dns_zones.internal_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.mapit_elb.dns_name}"
    zone_id                = "${aws_elb.mapit_elb.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_key_pair" "mapit_key" {
  key_name   = "${var.stackname}-mapit"
  public_key = "${var.ssh_public_key}"
}

module "mapit-1" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-mapit-1"
  vpc_id                        = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "mapit", "aws_hostname", "mapit-1")}"
  instance_subnet_ids           = "${matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.mapit_1_subnet))}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_mapit_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "t2.micro"
  create_instance_key           = false
  instance_key_name             = "${var.stackname}-mapit"
  instance_public_key           = "${var.ssh_public_key}"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids              = ["${aws_elb.mapit_elb.id}"]
  root_block_device_volume_size = "20"
}

resource "aws_ebs_volume" "mapit-1" {
  availability_zone = "${lookup(data.terraform_remote_state.infra_networking.private_subnet_names_azs_map, var.mapit_1_subnet)}"
  size              = 20
  type              = "gp2"

  tags {
    Name            = "${var.stackname}-mapit"
    Project         = "${var.stackname}"
    aws_hostname    = "mapit-1"
    aws_migration   = "mapit"
    aws_stackname   = "${var.stackname}"
    aws_environment = "${var.aws_environment}"
  }
}

module "mapit-2" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-mapit-2"
  vpc_id                        = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "mapit", "aws_hostname", "mapit-2")}"
  instance_subnet_ids           = "${matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.mapit_2_subnet))}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_mapit_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "t2.micro"
  create_instance_key           = false
  instance_key_name             = "${var.stackname}-mapit"
  instance_public_key           = "${var.ssh_public_key}"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids              = ["${aws_elb.mapit_elb.id}"]
  root_block_device_volume_size = "20"
}

resource "aws_ebs_volume" "mapit-2" {
  availability_zone = "${lookup(data.terraform_remote_state.infra_networking.private_subnet_names_azs_map, var.mapit_2_subnet)}"
  size              = 20
  type              = "gp2"

  tags {
    Name            = "${var.stackname}-mapit"
    Project         = "${var.stackname}"
    aws_hostname    = "mapit-2"
    aws_migration   = "mapit"
    aws_stackname   = "${var.stackname}"
    aws_environment = "${var.aws_environment}"
  }
}

resource "aws_iam_policy" "mapit_iam_policy" {
  name   = "${var.stackname}-mapit-additional"
  path   = "/"
  policy = "${file("${path.module}/additional_policy.json")}"
}

resource "aws_iam_role_policy_attachment" "mapit_1_iam_role_policy_attachment" {
  role       = "${module.mapit-1.instance_iam_role_name}"
  policy_arn = "${aws_iam_policy.mapit_iam_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "mapit_2_iam_role_policy_attachment" {
  role       = "${module.mapit-2.instance_iam_role_name}"
  policy_arn = "${aws_iam_policy.mapit_iam_policy.arn}"
}

# Outputs
# --------------------------------------------------------------

output "mapit_service_dns_name" {
  value       = "${aws_route53_record.mapit_service_record.fqdn}"
  description = "DNS name to access the mapit internal service"
}
