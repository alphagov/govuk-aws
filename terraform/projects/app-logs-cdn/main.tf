# == Manifest: projects::app-logs-cdn
#
# logs-cdn node
#
# === Variables:
#
# aws_region
# stackname
# aws_environment
# ssh_public_key
# logs_cdn_subnet
#
# === Outputs:
#
# logs-cdn_elb_address
# service_dns_name

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
  description = "logs-cdn default public key material"
}

variable "logs_cdn_subnet" {
  type        = "string"
  description = "Name of the subnet to place the EBS volume"
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

resource "aws_elb" "logs-cdn_external_elb" {
  name            = "${var.stackname}-logs-cdn"
  subnets         = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_offsite_ssh_id}"]
  internal        = "false"

  listener {
    instance_port     = "6514"
    instance_protocol = "tcp"
    lb_port           = "6514"
    lb_protocol       = "tcp"
  }

  listener {
    instance_port     = "6515"
    instance_protocol = "tcp"
    lb_port           = "6515"
    lb_protocol       = "tcp"
  }

  listener {
    instance_port     = "6516"
    instance_protocol = "tcp"
    lb_port           = "6516"
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:6514"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = "${map("Name", "${var.stackname}-logs-cdn", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "logs_cdn")}"
}

resource "aws_route53_record" "service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.external_zone_id}"
  name    = "logs-cdn.${data.terraform_remote_state.infra_stack_dns_zones.external_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.logs-cdn_external_elb.dns_name}"
    zone_id                = "${aws_elb.logs-cdn_external_elb.zone_id}"
    evaluate_target_health = true
  }
}

module "logs-cdn" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-logs-cdn"
  vpc_id                        = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "logs_cdn", "aws_hostname", "logs-cdn-1")}"
  instance_subnet_ids           = "${data.terraform_remote_state.infra_networking.private_subnet_ids}"
  instance_security_group_ids   = "${matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.logs_cdn_subnet))}"
  instance_type                 = "t2.micro"
  create_instance_key           = true
  instance_key_name             = "${var.stackname}-logs-cdn"
  instance_public_key           = "${var.ssh_public_key}"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids              = ["${aws_elb.logs-cdn_external_elb.id}"]
  asg_max_size                  = "1"
  asg_min_size                  = "1"
  asg_desired_capacity          = "1"
}

resource "aws_ebs_volume" "logs-cdn" {
  availability_zone = "${lookup(data.terraform_remote_state.infra_networking.private_subnet_names_azs_map, var.logs_cdn_subnet)}"
  size              = 500
  type              = "gp2"

  tags {
    Name            = "${var.stackname}-logs-cdn"
    Project         = "${var.stackname}"
    aws_stackname   = "${var.stackname}"
    aws_environment = "${var.aws_environment}"
    aws_migration   = "logs_cdn"
    aws_hostname    = "logs-cdn-1"
    Device          = "xvdf"
  }
}

resource "aws_iam_policy" "logs-cdn_iam_policy" {
  name   = "${var.stackname}-logs-cdn-additional"
  path   = "/"
  policy = "${file("${path.module}/additional_policy.json")}"
}

resource "aws_iam_role_policy_attachment" "logs-cdn_iam_role_policy_attachment" {
  role       = "${module.logs-cdn.instance_iam_role_name}"
  policy_arn = "${aws_iam_policy.logs-cdn_iam_policy.arn}"
}

# Outputs
# --------------------------------------------------------------

output "logs-cdn_elb_address" {
  value       = "${aws_elb.logs-cdn_external_elb.dns_name}"
  description = "AWS' internal DNS name for the logs-cdn ELB"
}

output "service_dns_name" {
  value       = "${aws_route53_record.service_record.name}"
  description = "DNS name to access the node service"
}
