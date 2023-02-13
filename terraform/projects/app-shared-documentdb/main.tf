/**
* ## Project: app-shared-documentdb
*
* Shared DocumentDB to support the following apps:
*   1. asset-manager
*/
variable "aws_environment" {
  type        = "string"
  description = "AWS environment"
}

data "aws_route53_zone" "internal" {
  name         = "${var.internal_zone_name}"
  private_zone = true
}

variable "internal_zone_name" {
  type        = "string"
  description = "The name of the Route53 zone that contains internal records"
}

variable "internal_domain_name" {
  type        = "string"
  description = "The domain name of the internal DNS records, it could be different from the zone name"
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

variable "tls" {
  type        = "string"
  description = "Whether to enable or disable TLS for the DocumentDB cluster. Must be either 'enabled' or 'disabled'."
  default     = "disabled"
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

# Resources
# --------------------------------------------------------------
terraform {
  backend "s3" {}
  required_version = "= 0.11.15"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "2.46.0"
}

resource "aws_docdb_cluster_instance" "cluster_instances" {
  count              = "${var.instance_count}"
  identifier         = "shared-documentdb-${count.index}"
  cluster_identifier = "${aws_docdb_cluster.cluster.id}"
  instance_class     = "${var.instance_type}"
  tags               = "${aws_docdb_cluster.cluster.tags}"
}

resource "aws_docdb_subnet_group" "cluster_subnet" {
  name       = "shared-documentdb-${var.aws_environment}"
  subnet_ids = ["${data.terraform_remote_state.infra_networking.private_subnet_ids}"]
}

resource "aws_docdb_cluster_parameter_group" "parameter_group" {
  family      = "docdb3.6"
  name        = "shared-documentdb-parameter-group"
  description = "Shared DocumentDB cluster parameter group"

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

resource "aws_docdb_cluster" "cluster" {
  cluster_identifier              = "shared-documentdb-${var.aws_environment}"
  availability_zones              = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  db_subnet_group_name            = "${aws_docdb_subnet_group.cluster_subnet.name}"
  master_username                 = "${var.master_username}"
  master_password                 = "${var.master_password}"
  storage_encrypted               = true
  backup_retention_period         = "${var.backup_retention_period}"
  db_cluster_parameter_group_name = "${aws_docdb_cluster_parameter_group.parameter_group.name}"
  kms_key_id                      = "${data.terraform_remote_state.infra_security.shared_documentdb_kms_key_arn}"
  vpc_security_group_ids          = ["${data.terraform_remote_state.infra_security_groups.sg_shared_documentdb_id}"]

  # enabled_cloudwatch_logs_exports is ["profiler"] if profiling is enabled, otherwise [].
  enabled_cloudwatch_logs_exports = ["${slice("${list("profiler")}", 0, var.profiler == "enabled" ? 1 : 0)}"]

  tags = {
    Service  = "shared documentdb"
    Customer = "asset-manager"
    Name     = "shared-documentdb"
    Source   = "app-shared-documentdb"
  }
}

resource "aws_route53_record" "share-documentdb_internal_service_cname" {
  zone_id = "${data.aws_route53_zone.internal.zone_id}"
  name    = "shared-documentdb.${var.internal_domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = ["${aws_docdb_cluster.cluster.endpoint}"]
}

# Outputs
# --------------------------------------------------------------
output "shared_documentdb_endpoint" {
  value       = "${aws_docdb_cluster.cluster.endpoint}"
  description = "The endpoint of the shared DocumentDB"
}
