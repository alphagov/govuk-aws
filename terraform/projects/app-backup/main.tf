# == Manifest: projects::app-backup
#
# Backup node
#
# === Variables:
#
# aws_region
# aws_environment
# stackname
# ssh_public_key
# instance_ami_filter_name
# backup_subnet
#
# === Outputs:
#

variable "aws_region" {
  type        = "string"
  description = "AWS region"
  default     = "eu-west-1"
}

variable "aws_environment" {
  type        = "string"
  description = "AWS Environment"
}

variable "stackname" {
  type        = "string"
  description = "Stackname"
}

variable "ssh_public_key" {
  type        = "string"
  description = "Default public key material"
}

variable "instance_ami_filter_name" {
  type        = "string"
  description = "Name to use to find AMI images"
  default     = ""
}

variable "backup_subnet" {
  type        = "string"
  description = "Name of the subnet to place the Backup instance 1 and EBS volume"
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

resource "aws_elb" "backup_elb" {
  name            = "${var.stackname}-backup-internal"
  subnets         = ["${data.terraform_remote_state.infra_networking.private_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_backup_elb_id}"]
  internal        = "true"

  listener {
    instance_port     = 22
    instance_protocol = "tcp"
    lb_port           = 22
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3

    target   = "TCP:22"
    interval = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = "${map("Name", "${var.stackname}-backup-internal", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "backup")}"
}

resource "aws_route53_record" "backup_internal_service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.internal_zone_id}"
  name    = "backup.${data.terraform_remote_state.infra_stack_dns_zones.internal_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.backup_elb.dns_name}"
    zone_id                = "${aws_elb.backup_elb.zone_id}"
    evaluate_target_health = true
  }
}

module "backup" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-backup"
  vpc_id                        = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "backup", "aws_hostname", "backup-1")}"
  instance_subnet_ids           = "${matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.backup_subnet))}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_backup_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "t2.medium"
  create_instance_key           = true
  instance_public_key           = "${var.ssh_public_key}"
  instance_key_name             = "${var.stackname}-backup"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids              = ["${aws_elb.backup_elb.id}"]
  instance_ami_filter_name      = "${var.instance_ami_filter_name}"
  root_block_device_volume_size = "20"
}

resource "aws_ebs_volume" "backup" {
  availability_zone = "${lookup(data.terraform_remote_state.infra_networking.private_subnet_names_azs_map, var.backup_subnet)}"
  size              = 750
  type              = "standard"

  tags {
    Name            = "${var.stackname}-backup"
    Project         = "${var.stackname}"
    Device          = "xvdf"
    aws_stackname   = "${var.stackname}"
    aws_environment = "${var.aws_environment}"
    aws_migration   = "backup"
    aws_hostname    = "backup-1"
  }
}

resource "aws_iam_policy" "backup_iam_policy" {
  name   = "${var.stackname}-backup-additional"
  path   = "/"
  policy = "${file("${path.module}/additional_policy.json")}"
}

resource "aws_iam_role_policy_attachment" "backup_iam_role_policy_attachment" {
  role       = "${module.backup.instance_iam_role_name}"
  policy_arn = "${aws_iam_policy.backup_iam_policy.arn}"
}

# Outputs
# --------------------------------------------------------------

output "backup_internal_service_dns_name" {
  value       = "${aws_route53_record.backup_internal_service_record.fqdn}"
  description = "DNS name to access the backup internal service"
}

output "backup_external_elb_dns_name" {
  value       = "${aws_elb.backup_elb.dns_name}"
  description = "DNS name to access the backup ELB"
}
