/**
* ## Project: app-elasticsearch
*
* Elasticsearch cluster
*/
variable "aws_environment" {
  type        = "string"
  description = "AWS Environment"
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

variable "elasticsearch_version" {
  type        = "string"
  description = "Which version of ElasticSearch to use (eg 5.6)"
  default     = "5.6"
}

variable "elasticsearch_instance_type" {
  type        = "string"
  description = "The instance type of the individual ElasticSearch nodes, only instances which allow EBS volumes are supported"
  default     = "m4.2xlarge.elasticsearch"
}

variable "elasticsearch_instance_count" {
  type        = "string"
  description = "The number of ElasticSearch nodes"
  default     = "3"
}

variable "elasticsearch_ebs_encrypt" {
  type        = "string"
  description = "Whether to encrypt the EBS volume at rest"
}

variable "elasticsearch_ebs_size" {
  type        = "string"
  description = "The amount of EBS storage to attach"
  default     = 32
}

variable "elasticsearch_snapshot_start_hour" {
  type        = "string"
  description = "The hour in which the daily snapshot is taken"
  default     = 1
}

variable "elasticsearch_subnet_names" {
  type        = "list"
  description = "Names of the subnets to place the ElasticSearch domain in"
}

# Resources
# --------------------------------------------------------------
terraform {
  backend          "s3"             {}
  required_version = "= 0.11.7"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "1.40.0"
}

module "elasticsearch" {
  source = "../../modules/aws/es_domain"
  name   = "${var.stackname}-elasticsearch"

  instance_type  = "${var.elasticsearch_instance_type}"
  instance_count = "${var.elasticsearch_instance_count}"

  ebs_size    = "${var.elasticsearch_ebs_size}"
  ebs_encrypt = "${var.elasticsearch_ebs_encrypt}"

  elasticsearch_version = "${var.elasticsearch_version}"
  snapshot_start_hour   = "${var.elasticsearch_snapshot_start_hour}"

  subnet_ids = "${matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), var.elasticsearch_subnet_names)}"

  security_group_ids = ["${data.terraform_remote_state.infra_security_groups.sg_elasticsearch_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]

  default_tags = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment)}"
}

# Outputs
# --------------------------------------------------------------

output "service_role_id" {
  value       = "${module.elasticsearch.es_role_id}"
  description = "Unique identifier for the service-linked role"
}

output "service_endpoint" {
  value       = "${module.elasticsearch.es_endpoint}"
  description = "Endpoint to submit index, search, and upload requests"
}
