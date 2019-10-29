/**
* ## Project: app-licensify-documentdb
*
* DocumentDB cluster for Licensify
*/
variable "aws_environment" {
  type        = "string"
  description = "AWS environment"
}

variable "aws_region" {
  type        = "string"
  description = "AWS region"
  default     = "eu-west-1"
}

variable "master_password" {
  type        = "string"
  description = "Password of master user on Licensify DocumentDB cluster"
}

variable "master_username" {
  type        = "string"
  description = "Username of master user on Licensify DocumentDB cluster"
}

variable "tls" {
  type        = "string"
  description = "Whether to enable or disable TLS for the Licensify DocumentDB cluster. Must be either 'enabled' or 'disabled'."
  default     = "enabled"
}

variable "backup_retention_period" {
  type        = "string"
  description = "Retention period in days for DocumentDB automatic snapshots"
  default     = "1"
}

variable "instance_count" {
  type        = "string"
  description = "Instance count used for Licensify DocumentDB resources"
  default     = "3"
}

variable "instance_type" {
  type        = "string"
  description = "Instance type used for Licensify DocumentDB resources"
  default     = "db.r5.large"
}

variable "stackname" {
  type        = "string"
  description = "Stackname"
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

resource "aws_docdb_subnet_group" "licensify_cluster_subnet" {
  name       = "licensify-documentdb-${var.aws_environment}"
  subnet_ids = ["${data.terraform_remote_state.infra_networking.private_subnet_ids}"]
}

resource "aws_docdb_cluster_parameter_group" "licensify_parameter_group" {
  family      = "docdb3.6"
  name        = "licensify-parameter-group"
  description = "Licensify DocumentDB cluster parameter group"

  parameter {
    name  = "tls"
    value = "${var.tls}"
  }
}

resource "aws_docdb_cluster" "licensify_cluster" {
  cluster_identifier              = "licensify-documentdb-${var.aws_environment}"
  availability_zones              = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  db_subnet_group_name            = "${aws_docdb_subnet_group.licensify_cluster_subnet.name}"
  db_cluster_parameter_group_name = "${aws_docdb_cluster_parameter_group.licensify_parameter_group.name}"
  master_username                 = "${var.master_username}"
  master_password                 = "${var.master_password}"
  storage_encrypted               = true
  backup_retention_period         = "${var.backup_retention_period}"
  kms_key_id                      = "${data.terraform_remote_state.infra_security.licensify_documentdb_kms_key_arn}"
  vpc_security_group_ids          = ["${data.terraform_remote_state.infra_security_groups.sg_licensify_documentdb_id}"]

  tags = {
    Service  = "documentdb"
    Customer = "licensify"
    Name     = "licensify-documentdb"
    Source   = "app-licensify-documentdb"
  }
}

resource "aws_docdb_cluster_instance" "licensify_cluster_instances" {
  count              = "${var.instance_count}"
  identifier         = "licensify-documentdb-${count.index}"
  cluster_identifier = "${aws_docdb_cluster.licensify_cluster.id}"
  instance_class     = "${var.instance_type}"
  tags               = "${aws_docdb_cluster.licensify_cluster.tags}"
}

# Outputs
# --------------------------------------------------------------
output "licensify_documentdb_endpoint" {
  value       = "${aws_docdb_cluster.licensify_cluster.endpoint}"
  description = "The endpoint of the Licensify DocumentDB"
}
