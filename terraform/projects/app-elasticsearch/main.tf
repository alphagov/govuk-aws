# == Manifest: projects::app-elasticsearch
#
# Elasticsearch node
#
# === Variables:
#
# aws_region
# stackname
# aws_environment
# ssh_public_key
# elasticsearch_1_subnet
# elasticsearch_2_subnet
# elasticsearch_3_subnet
# cluster_name
#
# === Outputs:
#
# service_dns_name
# elasticsearch_elb_dns_name
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

variable "elasticsearch_1_subnet" {
  type        = "string"
  description = "Name of the subnet to place the Elasticsearch instance 1 and EBS volume"
}

variable "elasticsearch_2_subnet" {
  type        = "string"
  description = "Name of the subnet to place the Elasticsearch 2 and EBS volume"
}

variable "elasticsearch_3_subnet" {
  type        = "string"
  description = "Name of the subnet to place the Elasticsearch instance 3 and EBS volume"
}

variable "cluster_name" {
  type        = "string"
  description = "Name of the Elasticsearch cluster to use for discovery"
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

resource "aws_elb" "elasticsearch_elb" {
  name            = "${var.stackname}-elasticsearch"
  subnets         = ["${data.terraform_remote_state.infra_networking.private_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_elasticsearch_elb_id}"]
  internal        = "true"

  listener {
    instance_port     = 9200
    instance_protocol = "tcp"
    lb_port           = 9200
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3

    target   = "TCP:9200"
    interval = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = "${map("Name", "${var.stackname}-elasticsearch", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "api_elasticsearch")}"
}

resource "aws_route53_record" "service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.internal_zone_id}"
  name    = "elasticsearch.${data.terraform_remote_state.infra_stack_dns_zones.internal_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.elasticsearch_elb.dns_name}"
    zone_id                = "${aws_elb.elasticsearch_elb.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_key_pair" "elasticsearch_key" {
  key_name   = "${var.stackname}-elasticsearch"
  public_key = "${var.ssh_public_key}"
}

# Instance 1
module "elasticsearch-1" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-elasticsearch-1"
  vpc_id                        = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "api_elasticsearch", "aws_hostname", "elasticsearch-1", "cluster_name", var.cluster_name)}"
  instance_subnet_ids           = "${matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.elasticsearch_1_subnet))}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_elasticsearch_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "t2.medium"
  create_instance_key           = false
  instance_key_name             = "${var.stackname}-elasticsearch"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids              = ["${aws_elb.elasticsearch_elb.id}"]
  root_block_device_volume_size = "20"
}

resource "aws_ebs_volume" "elasticsearch-1" {
  availability_zone = "${lookup(data.terraform_remote_state.infra_networking.private_subnet_names_azs_map, var.elasticsearch_1_subnet)}"
  size              = 100
  type              = "gp2"

  tags {
    Name            = "${var.stackname}-elasticsearch-1"
    Project         = "${var.stackname}"
    aws_stackname   = "${var.stackname}"
    aws_environment = "${var.aws_environment}"
    aws_migration   = "api_elasticsearch"
    aws_hostname    = "elasticsearch-1"
    Device          = "xvdf"
  }
}

# Instance 2
module "elasticsearch-2" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-elasticsearch-2"
  vpc_id                        = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "api_elasticsearch", "aws_hostname", "elasticsearch-2", "cluster_name", var.cluster_name)}"
  instance_subnet_ids           = "${matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.elasticsearch_2_subnet))}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_elasticsearch_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "t2.medium"
  create_instance_key           = false
  instance_key_name             = "${var.stackname}-elasticsearch"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids              = ["${aws_elb.elasticsearch_elb.id}"]
  root_block_device_volume_size = "20"
}

resource "aws_ebs_volume" "elasticsearch-2" {
  availability_zone = "${lookup(data.terraform_remote_state.infra_networking.private_subnet_names_azs_map, var.elasticsearch_2_subnet)}"
  size              = 100
  type              = "gp2"

  tags {
    Name            = "${var.stackname}-elasticsearch-2"
    Project         = "${var.stackname}"
    aws_stackname   = "${var.stackname}"
    aws_environment = "${var.aws_environment}"
    aws_migration   = "api_elasticsearch"
    aws_hostname    = "elasticsearch-2"
    Device          = "xvdf"
  }
}

# Instance 3
module "elasticsearch-3" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-elasticsearch-3"
  vpc_id                        = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "api_elasticsearch", "aws_hostname", "elasticsearch-3", "cluster_name", var.cluster_name)}"
  instance_subnet_ids           = "${matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.elasticsearch_3_subnet))}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_elasticsearch_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "t2.medium"
  create_instance_key           = false
  instance_key_name             = "${var.stackname}-elasticsearch"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids              = ["${aws_elb.elasticsearch_elb.id}"]
  root_block_device_volume_size = "20"
}

resource "aws_ebs_volume" "elasticsearch-3" {
  availability_zone = "${lookup(data.terraform_remote_state.infra_networking.private_subnet_names_azs_map, var.elasticsearch_3_subnet)}"
  size              = 100
  type              = "gp2"

  tags {
    Name            = "${var.stackname}-elasticsearch-3"
    Project         = "${var.stackname}"
    aws_stackname   = "${var.stackname}"
    aws_environment = "${var.aws_environment}"
    aws_migration   = "api_elasticsearch"
    aws_hostname    = "elasticsearch-3"
    Device          = "xvdf"
  }
}

resource "aws_iam_policy" "elasticsearch_iam_policy" {
  name   = "${var.stackname}-elasticsearch-additional"
  path   = "/"
  policy = "${file("${path.module}/additional_policy.json")}"
}

resource "aws_iam_role_policy_attachment" "elasticsearch_1_iam_role_policy_attachment" {
  role       = "${module.elasticsearch-1.instance_iam_role_name}"
  policy_arn = "${aws_iam_policy.elasticsearch_iam_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "elasticsearch_2_iam_role_policy_attachment" {
  role       = "${module.elasticsearch-2.instance_iam_role_name}"
  policy_arn = "${aws_iam_policy.elasticsearch_iam_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "elasticsearch_3_iam_role_policy_attachment" {
  role       = "${module.elasticsearch-3.instance_iam_role_name}"
  policy_arn = "${aws_iam_policy.elasticsearch_iam_policy.arn}"
}

# Outputs
# --------------------------------------------------------------

output "service_dns_name" {
  value       = "${aws_route53_record.service_record.fqdn}"
  description = "DNS name to access the Elasticsearch internal service"
}

output "elasticsearch_elb_dns_name" {
  value       = "${aws_elb.elasticsearch_elb.dns_name}"
  description = "DNS name to access the Elasticsearch ELB"
}
