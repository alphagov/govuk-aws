/**
* ## Project: app-documentdb
*
* Shared DocumentDB initially for Licensify
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

variable "stackname" {
  type        = "string"
  description = "Stackname"
}

variable "instance_type" {
  type        = "string"
  description = "Instance type used for DocumentDB resources"
  default     = "db.r5.large"
}

variable "instance_count" {
  type        = "string"
  description = "Instance count used for DocumentDB resources"
  default     = "3"
}

variable "master_username" {
  type        = "string"
  description = "Username of master user on DocumentDB cluster"
}

variable "master_password" {
  type        = "string"
  description = "Password of master user on DocumentDB cluster"
}

# Resources
# --------------------------------------------------------------
terraform {
  backend          "s3"             {}
  required_version = "= 0.11.14"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "2.16.0"
}

resource "aws_docdb_cluster_instance" "cluster_instances" {
  count              = "${var.instance_count}"
  identifier         = "documentdb-${count.index}"
  cluster_identifier = "${aws_docdb_cluster.cluster.id}"
  instance_class     = "${var.instance_type}"
  tags               = "${aws_docdb_cluster.cluster.tags}"
}

resource "aws_docdb_subnet_group" "cluster_subnet" {
  name       = "documentdb-${var.aws_environment}"
  subnet_ids = ["${data.terraform_remote_state.infra_networking.private_subnet_ids}"]
}

resource "aws_docdb_cluster" "cluster" {
  cluster_identifier     = "documentdb-${var.aws_environment}"
  availability_zones     = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  db_subnet_group_name   = "${aws_docdb_subnet_group.cluster_subnet.name}"
  master_username        = "${var.master_username}"
  master_password        = "${var.master_password}"
  vpc_security_group_ids = ["${data.terraform_remote_state.infra_security_groups.sg_documentdb_id}"]

  tags = {
    Service  = "documentdb"
    Customer = "licensify"
    Name     = "documentdb-licensify"
    Source   = "app-documentdb"
  }
}
