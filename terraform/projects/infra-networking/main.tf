/**
* ## Project: infra-networking
*
* This module governs the creation of full network stacks.
*/
variable "aws_region" {
  type        = "string"
  description = "AWS region"
  default     = "eu-west-1"
}

variable "remote_state_bucket" {
  type        = "string"
  description = "S3 bucket we store our terraform state in"
}

variable "remote_state_infra_vpc_key_stack" {
  type        = "string"
  description = "Override infra_vpc remote state path"
  default     = ""
}

variable "remote_state_infra_monitoring_key_stack" {
  type        = "string"
  description = "Override stackname path to infra_monitoring remote state "
  default     = ""
}

variable "stackname" {
  type        = "string"
  description = "Stackname"
}

variable "public_subnet_cidrs" {
  type        = "map"
  description = "Map containing public subnet names and CIDR associated"
}

variable "public_subnet_availability_zones" {
  type        = "map"
  description = "Map containing public subnet names and availability zones associated"
}

variable "public_subnet_nat_gateway_enable" {
  type        = "list"
  description = "List of public subnet names where we want to create a NAT Gateway"
}

variable "private_subnet_cidrs" {
  type        = "map"
  description = "Map containing private subnet names and CIDR associated"
}

variable "private_subnet_availability_zones" {
  type        = "map"
  description = "Map containing private subnet names and availability zones associated"
}

variable "private_subnet_nat_gateway_association" {
  type        = "map"
  description = "Map of private subnet names and public subnet used to route external traffic (the public subnet must be listed in public_subnet_nat_gateway_enable to ensure it has a NAT gateway attached)"
}

variable "private_subnet_elasticache_cidrs" {
  type        = "map"
  description = "Map containing private elasticache subnet names and CIDR associated"
  default     = {}
}

variable "private_subnet_elasticache_availability_zones" {
  type        = "map"
  description = "Map containing private elasticache subnet names and availability zones associated"
  default     = {}
}

variable "private_subnet_rds_cidrs" {
  type        = "map"
  description = "Map containing private rds subnet names and CIDR associated"
  default     = {}
}

variable "private_subnet_rds_availability_zones" {
  type        = "map"
  description = "Map containing private rds subnet names and availability zones associated"
  default     = {}
}

variable "private_subnet_reserved_ips_cidrs" {
  type        = "map"
  description = "Map containing private ENI subnet names and CIDR associated"
  default     = {}
}

variable "private_subnet_reserved_ips_availability_zones" {
  type        = "map"
  description = "Map containing private ENI subnet names and availability zones associated"
  default     = {}
}

variable "private_subnet_elasticsearch_cidrs" {
  type        = "map"
  description = "Map containing private elasticsearch subnet names and CIDR associated"
  default     = {}
}

variable "private_subnet_elasticsearch_availability_zones" {
  type        = "map"
  description = "Map containing private elasticsearch subnet names and availability zones associated"
  default     = {}
}

# Resources
# --------------------------------------------------------------
terraform {
  backend          "s3"             {}
  required_version = "= 0.11.14"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "2.33.0"
}

data "terraform_remote_state" "infra_vpc" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket}"
    key    = "${coalesce(var.remote_state_infra_vpc_key_stack, var.stackname)}/infra-vpc.tfstate"
    region = "${var.aws_region}"
  }
}

data "terraform_remote_state" "infra_monitoring" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket}"
    key    = "${coalesce(var.remote_state_infra_monitoring_key_stack, var.stackname)}/infra-monitoring.tfstate"
    region = "${var.aws_region}"
  }
}

module "infra_public_subnet" {
  source                    = "../../modules/aws/network/public_subnet"
  vpc_id                    = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags              = "${map("Project", var.stackname)}"
  route_table_public_id     = "${data.terraform_remote_state.infra_vpc.route_table_public_id}"
  subnet_cidrs              = "${var.public_subnet_cidrs}"
  subnet_availability_zones = "${var.public_subnet_availability_zones}"
}

module "infra_nat" {
  source            = "../../modules/aws/network/nat"
  subnet_ids        = "${matchkeys(values(module.infra_public_subnet.subnet_names_ids_map), keys(module.infra_public_subnet.subnet_names_ids_map), var.public_subnet_nat_gateway_enable)}"
  subnet_ids_length = "${length(var.public_subnet_nat_gateway_enable)}"
}

# Intermediate variables in Terraform are not supported.
# There are a few workarounds to get around this limitation,
# https://github.com/hashicorp/terraform/issues/4084
# The template_file resources allow us to use a private_subnet_nat_gateway_association
# variable to select which NAT gateway, if any, each private
# subnet must use to route public traffic.
data "template_file" "nat_gateway_association_subnet_id" {
  count    = "${length(keys(var.private_subnet_nat_gateway_association))}"
  template = "$${subnet_id}"

  vars {
    subnet_id = "${lookup(module.infra_public_subnet.subnet_names_ids_map, element(values(var.private_subnet_nat_gateway_association), count.index))}"
  }
}

data "template_file" "nat_gateway_association_nat_id" {
  count      = "${length(keys(var.private_subnet_nat_gateway_association))}"
  template   = "$${nat_gateway_id}"
  depends_on = ["data.template_file.nat_gateway_association_subnet_id"]

  vars {
    nat_gateway_id = "${lookup(module.infra_nat.nat_gateway_subnets_ids_map, element(data.template_file.nat_gateway_association_subnet_id.*.rendered, count.index))}"
  }
}

module "infra_private_subnet" {
  source                     = "../../modules/aws/network/private_subnet"
  vpc_id                     = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags               = "${map("Project", var.stackname)}"
  subnet_cidrs               = "${var.private_subnet_cidrs}"
  subnet_availability_zones  = "${var.private_subnet_availability_zones}"
  subnet_nat_gateways        = "${zipmap(keys(var.private_subnet_nat_gateway_association), data.template_file.nat_gateway_association_nat_id.*.rendered)}"
  subnet_nat_gateways_length = "${length(keys(var.private_subnet_nat_gateway_association))}"
}

module "infra_private_subnet_elasticache" {
  source                     = "../../modules/aws/network/private_subnet"
  vpc_id                     = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags               = "${map("Project", var.stackname, "aws_migration", "elasticache")}"
  subnet_cidrs               = "${var.private_subnet_elasticache_cidrs}"
  subnet_availability_zones  = "${var.private_subnet_elasticache_availability_zones}"
  subnet_nat_gateways_length = "0"
}

module "infra_private_subnet_rds" {
  source                     = "../../modules/aws/network/private_subnet"
  vpc_id                     = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags               = "${map("Project", var.stackname, "aws_migration", "rds")}"
  subnet_cidrs               = "${var.private_subnet_rds_cidrs}"
  subnet_availability_zones  = "${var.private_subnet_rds_availability_zones}"
  subnet_nat_gateways_length = "0"
}

module "infra_private_subnet_reserved_ips" {
  source                     = "../../modules/aws/network/private_subnet"
  vpc_id                     = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags               = "${map("Project", var.stackname, "aws_migration", "eni")}"
  subnet_cidrs               = "${var.private_subnet_reserved_ips_cidrs}"
  subnet_availability_zones  = "${var.private_subnet_reserved_ips_availability_zones}"
  subnet_nat_gateways_length = "0"
}

module "infra_private_subnet_elasticsearch" {
  source                     = "../../modules/aws/network/private_subnet"
  vpc_id                     = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags               = "${map("Project", var.stackname, "aws_migration", "elasticsearch")}"
  subnet_cidrs               = "${var.private_subnet_elasticsearch_cidrs}"
  subnet_availability_zones  = "${var.private_subnet_elasticsearch_availability_zones}"
  subnet_nat_gateways_length = "0"
}

module "infra_alarms_natgateway" {
  source                 = "../../modules/aws/alarms/natgateway"
  name_prefix            = "${var.stackname}-natgateway"
  alarm_actions          = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  nat_gateway_ids        = ["${module.infra_nat.nat_gateway_ids}"]
  nat_gateway_ids_length = "${length(var.public_subnet_nat_gateway_enable)}"
}

# Outputs
# --------------------------------------------------------------
output "vpc_id" {
  value       = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "VPC ID where the stack resources are created"
}

output "nat_gateway_elastic_ips_list" {
  value       = "${module.infra_nat.nat_gateway_elastic_ips_list}"
  description = "List containing the public IPs associated with the NAT gateways"
}

output "public_subnet_ids" {
  value       = "${module.infra_public_subnet.subnet_ids}"
  description = "List of public subnet IDs"
}

output "public_subnet_names_ids_map" {
  value       = "${module.infra_public_subnet.subnet_names_ids_map}"
  description = "Map containing the pair name-id for each public subnet created"
}

output "public_subnet_names_azs_map" {
  value = "${var.public_subnet_availability_zones}"
}

output "private_subnet_ids" {
  value       = "${module.infra_private_subnet.subnet_ids}"
  description = "List of private subnet IDs"
}

output "private_subnet_names_ids_map" {
  value       = "${module.infra_private_subnet.subnet_names_ids_map}"
  description = "Map containing the pair name-id for each private subnet created"
}

output "private_subnet_names_azs_map" {
  value = "${var.private_subnet_availability_zones}"
}

output "private_subnet_names_route_tables_map" {
  value       = "${module.infra_private_subnet.subnet_names_route_tables_map}"
  description = "Map containing the name of each private subnet and route_table ID associated"
}

output "private_subnet_elasticache_ids" {
  value       = "${module.infra_private_subnet_elasticache.subnet_ids}"
  description = "List of private subnet IDs"
}

output "private_subnet_elasticache_names_ids_map" {
  value       = "${module.infra_private_subnet_elasticache.subnet_names_ids_map}"
  description = "Map containing the pair name-id for each private subnet created"
}

output "private_subnet_elasticache_names_azs_map" {
  value = "${var.private_subnet_elasticache_availability_zones}"
}

output "private_subnet_elasticache_names_route_tables_map" {
  value       = "${module.infra_private_subnet_elasticache.subnet_names_route_tables_map}"
  description = "Map containing the name of each private subnet and route_table ID associated"
}

output "private_subnet_rds_ids" {
  value       = "${module.infra_private_subnet_rds.subnet_ids}"
  description = "List of private subnet IDs"
}

output "private_subnet_rds_names_ids_map" {
  value       = "${module.infra_private_subnet_rds.subnet_names_ids_map}"
  description = "Map containing the pair name-id for each private subnet created"
}

output "private_subnet_rds_names_azs_map" {
  value = "${var.private_subnet_rds_availability_zones}"
}

output "private_subnet_rds_names_route_tables_map" {
  value       = "${module.infra_private_subnet_rds.subnet_names_route_tables_map}"
  description = "Map containing the name of each private subnet and route_table ID associated"
}

output "private_subnet_reserved_ips_ids" {
  value       = "${module.infra_private_subnet_reserved_ips.subnet_ids}"
  description = "List of private subnet IDs"
}

output "private_subnet_reserved_ips_names_ids_map" {
  value       = "${module.infra_private_subnet_reserved_ips.subnet_names_ids_map}"
  description = "Map containing the pair name-id for each private subnet created"
}

output "private_subnet_reserved_ips_names_azs_map" {
  value = "${var.private_subnet_reserved_ips_availability_zones}"
}

output "private_subnet_reserved_ips_names_route_tables_map" {
  value       = "${module.infra_private_subnet_reserved_ips.subnet_names_route_tables_map}"
  description = "Map containing the name of each private subnet and route_table ID associated"
}

output "private_subnet_elasticsearch_ids" {
  value       = "${module.infra_private_subnet_elasticsearch.subnet_ids}"
  description = "List of private subnet IDs"
}

output "private_subnet_elasticsearch_names_ids_map" {
  value       = "${module.infra_private_subnet_elasticsearch.subnet_names_ids_map}"
  description = "Map containing the pair name-id for each private subnet created"
}

output "private_subnet_elasticsearch_names_azs_map" {
  value = "${var.private_subnet_elasticsearch_availability_zones}"
}

output "private_subnet_elasticsearch_names_route_tables_map" {
  value       = "${module.infra_private_subnet_elasticsearch.subnet_names_route_tables_map}"
  description = "Map containing the name of each private subnet and route_table ID associated"
}
