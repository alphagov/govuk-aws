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

variable "profiler" {
  type        = "string"
  description = "Whether to log slow queries to CloudWatch. Must be either 'enabled' or 'disabled'."
  default     = "enabled"
}

variable "profiler_threshold_ms" {
  type        = "string"
  description = "Queries which take longer than this number of milliseconds are logged to CloudWatch if profiler is enabled. Minimum is 50."
  default     = "300"
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
  backend "s3" {}
  required_version = "= 0.12.30"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "2.46.0"
}

resource "aws_docdb_subnet_group" "licensify_cluster_subnet" {
  name       = "licensify-documentdb-${var.aws_environment}"
  subnet_ids = data.terraform_remote_state.infra_networking.outputs.private_subnet_ids
}

resource "aws_docdb_cluster_parameter_group" "licensify_parameter_group" {
  family      = "docdb3.6"
  name        = "licensify-parameter-group"
  description = "Licensify DocumentDB cluster parameter group"

  parameter {
    name  = "tls"
    value = "${var.tls}"
  }

  parameter {
    name  = "profiler"
    value = "${var.profiler}"
  }

  parameter {
    name  = "profiler_threshold_ms"
    value = "${var.profiler_threshold_ms}"
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
  kms_key_id                      = "${data.terraform_remote_state.infra_security.outputs.licensify_documentdb_kms_key_arn}"
  vpc_security_group_ids          = ["${data.terraform_remote_state.infra_security_groups.outputs.sg_licensify_documentdb_id}"]

  # enabled_cloudwatch_logs_exports is ["profiler"] if profiling is enabled, otherwise [].
  enabled_cloudwatch_logs_exports = "${slice("${list("profiler")}", 0, var.profiler == "enabled" ? 1 : 0)}"

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
