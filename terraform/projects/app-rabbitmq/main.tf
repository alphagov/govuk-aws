# == Manifest: projects::app-rabbitmq
#
# rabbitmq nodes (1 - 3)
#
# === Variables:
#
# aws_region
# stackname
# aws_environment
# ssh_public_key
# rabbitmq_1_subnet
# rabbitmq_2_subnet
# rabbitmq_3_subnet
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

variable "rabbitmq_1_subnet" {
  type        = "string"
  description = "Name of the subnet to place the rabbitmq instance 1 and EBS volume"
}

variable "rabbitmq_2_subnet" {
  type        = "string"
  description = "Name of the subnet to place the rabbitmq instance 2 and EBS volume"
}

variable "rabbitmq_3_subnet" {
  type        = "string"
  description = "Name of the subnet to place the rabbitmq instance 3 and EBS volume"
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


resource "aws_elb" "rabbitmq_elb" {
  name            = "${var.stackname}-rabbitmq-internal"
  subnets         = ["${data.terraform_remote_state.infra_networking.private_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_rabbitmq_elb_id}"]
  internal        = "true"

  listener {
    instance_port     = 5672
    instance_protocol = "tcp"
    lb_port           = 5672
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3

    target   = "TCP:5672"
    interval = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = "${map("Name", "${var.stackname}-rabbitmq-internal", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "rabbitmq")}"
}

resource "aws_route53_record" "rabbitmq_internal_service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.internal_zone_id}"
  name    = "rabbitmq.${data.terraform_remote_state.infra_stack_dns_zones.internal_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.rabbitmq_elb.dns_name}"
    zone_id                = "${aws_elb.rabbitmq_elb.zone_id}"
    evaluate_target_health = true
  }
}

module "rabbitmq-1" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-rabbitmq-1"
  vpc_id                        = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "rabbitmq", "aws_hostname", "rabbitmq-1")}"
  instance_subnet_ids           = "${matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.rabbitmq_1_subnet))}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_rabbitmq_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "t2.medium"
  create_instance_key           = true
  instance_key_name             = "${var.stackname}-rabbitmq"
  instance_public_key           = "${var.ssh_public_key}"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids              = ["${aws_elb.rabbitmq_elb.id}"]
  root_block_device_volume_size = "20"
}

resource "aws_ebs_volume" "rabbitmq-1" {
  availability_zone = "${lookup(data.terraform_remote_state.infra_networking.private_subnet_names_azs_map, var.rabbitmq_1_subnet)}"
  size              = 100
  type              = "gp2"

  tags {
    Name            = "${var.stackname}-rabbitmq-1"
    Project         = "${var.stackname}"
    Device          = "xvdf"
    aws_stackname   = "${var.stackname}"
    aws_environment = "${var.aws_environment}"
    aws_migration   = "rabbitmq"
    aws_hostname    = "rabbitmq-1"
  }
}

module "rabbitmq-2" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-rabbitmq-2"
  vpc_id                        = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "rabbitmq", "aws_hostname", "rabbitmq-2")}"
  instance_subnet_ids           = "${matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.rabbitmq_1_subnet))}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_rabbitmq_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "t2.medium"
  create_instance_key           = false
  instance_key_name             = "${var.stackname}-rabbitmq"
  instance_public_key           = "${var.ssh_public_key}"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids              = ["${aws_elb.rabbitmq_elb.id}"]
  root_block_device_volume_size = "20"
}

resource "aws_ebs_volume" "rabbitmq-2" {
  availability_zone = "${lookup(data.terraform_remote_state.infra_networking.private_subnet_names_azs_map, var.rabbitmq_1_subnet)}"
  size              = 100
  type              = "gp2"

  tags {
    Name            = "${var.stackname}-rabbitmq-2"
    Project         = "${var.stackname}"
    Device          = "xvdf"
    aws_stackname   = "${var.stackname}"
    aws_environment = "${var.aws_environment}"
    aws_migration   = "rabbitmq"
    aws_hostname    = "rabbitmq-2"
  }
}

module "rabbitmq-3" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-rabbitmq-3"
  vpc_id                        = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "rabbitmq", "aws_hostname", "rabbitmq-3")}"
  instance_subnet_ids           = "${matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.rabbitmq_1_subnet))}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_rabbitmq_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "t2.medium"
  create_instance_key           = false
  instance_key_name             = "${var.stackname}-rabbitmq"
  instance_public_key           = "${var.ssh_public_key}"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids              = ["${aws_elb.rabbitmq_elb.id}"]
  root_block_device_volume_size = "20"
}

resource "aws_ebs_volume" "rabbitmq-3" {
  availability_zone = "${lookup(data.terraform_remote_state.infra_networking.private_subnet_names_azs_map, var.rabbitmq_1_subnet)}"
  size              = 100
  type              = "gp2"

  tags {
    Name            = "${var.stackname}-rabbitmq-3"
    Project         = "${var.stackname}"
    Device          = "xvdf"
    aws_stackname   = "${var.stackname}"
    aws_environment = "${var.aws_environment}"
    aws_migration   = "rabbitmq"
    aws_hostname    = "rabbitmq-3"
  }
}

resource "aws_iam_policy" "rabbitmq_iam_policy" {
  name   = "${var.stackname}-rabbitmq-1-additional"
  path   = "/"
  policy = "${file("${path.module}/additional_policy.json")}"
}

resource "aws_iam_role_policy_attachment" "rabbitmq_1_iam_role_policy_attachment" {
  role       = "${module.rabbitmq-1.instance_iam_role_name}"
  policy_arn = "${aws_iam_policy.rabbitmq_iam_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "rabbitmq_2_iam_role_policy_attachment" {
  role       = "${module.rabbitmq-2.instance_iam_role_name}"
  policy_arn = "${aws_iam_policy.rabbitmq_iam_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "rabbitmq_3_iam_role_policy_attachment" {
  role       = "${module.rabbitmq-3.instance_iam_role_name}"
  policy_arn = "${aws_iam_policy.rabbitmq_iam_policy.arn}"
}

# Outputs
# --------------------------------------------------------------

output "rabbitmq_internal_service_dns_name" {
  value       = "${aws_route53_record.rabbitmq_internal_service_record.fqdn}"
  description = "DNS name to access the rabbitmq internal service"
}
