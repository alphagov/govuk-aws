# == Module: aws::rds_instance
#
# Create a RDS instance
#
# === Variables:
#
# name
# engine_name
# engine_version
# default_tags
# subnet_ids
# username
# password
# allocated_storage
# storage_type
# instance_class
# security_group_ids
# multi_az
# create_replicate_source_db
# replicate_source_db
#
# === Outputs:
#
# rds_instance_id
# rds_instance_resource_id
# rds_instance_endpoint
# rds_instance_address

variable "name" {
  type        = "string"
  description = "The common name for all the resources created by this module"
}

variable "engine_name" {
  type        = "string"
  description = "RDS engine (eg mysql, postgresql)"
  default     = ""
}

variable "engine_version" {
  type        = "string"
  description = "Which version of MySQL to use (eg 5.5.46)"
  default     = ""
}

variable "default_tags" {
  type        = "map"
  description = "Additional resource tags"
  default     = {}
}

variable "subnet_ids" {
  type        = "list"
  description = "Subnet IDs to assign to the aws_elasticache_subnet_group"
  default     = []
}

variable "username" {
  type        = "string"
  description = "User to create on the database"
  default     = ""
}

variable "password" {
  type        = "string"
  description = "Password for accessing the database."
  default     = ""
}

variable "allocated_storage" {
  type        = "string"
  description = "The allocated storage in gigabytes."
  default     = "10"
}

variable "storage_type" {
  type        = "string"
  description = "One of standard (magnetic), gp2 (general purpose SSD), or io1 (provisioned IOPS SSD). The default is gp2"
  default     = "gp2"
}

variable "instance_class" {
  type        = "string"
  description = "The instance type of the RDS instance."
  default     = "db.t1.micro"
}

variable "security_group_ids" {
  type        = "list"
  description = "Security group IDs to apply to this cluster"
}

variable "multi_az" {
  type        = "string"
  description = "Specifies if the RDS instance is multi-AZ"
  default     = false
}

variable "create_replicate_source_db" {
  type        = "string"
  description = "Specifies that this resource is a Replicate database, and to use this value as the source database. This correlates to the identifier of another Amazon RDS Database to replicate"
  default     = "0"
}

variable "replicate_source_db" {
  type        = "string"
  description = "Specifies that this resource is a Replicate database, and to use this value as the source database. This correlates to the identifier of another Amazon RDS Database to replicate"
  default     = "false"
}

variable "parameter_group_name" {
  type        = "string"
  description = "Name of the parameter group to make the instance a member of."
  default     = ""
}

variable "skip_final_snapshot" {
  type        = "string"
  description = "Set to false to create a final snapshot when the cluster is deleted."
  default     = "true"
}

variable "maintenance_window" {
  type        = "string"
  description = "The window to perform maintenance in."
  default     = "Mon:01:00-Mon:03:00"
}

variable "backup_retention_period" {
  type        = "string"
  description = "The days to retain backups for."
  default     = "7"
}

variable "backup_window" {
  type        = "string"
  description = "The daily time range during which automated backups are created if automated backups are enabled."
  default     = "04:00-06:00"
}

# Resources
# --------------------------------------------------------------

resource "aws_db_subnet_group" "subnet_group" {
  count      = "${1 - var.create_replicate_source_db}"
  name       = "${var.name}"
  subnet_ids = ["${var.subnet_ids}"]

  tags = "${merge(var.default_tags, map("Name", var.name))}"
}

resource "aws_db_instance" "db_instance_replica" {
  # the 'name' parameter is not set as that creates a default database
  # of that name in the instance. Which we don't want.
  count = "${var.create_replicate_source_db}"

  instance_class         = "${var.instance_class}"
  storage_type           = "${var.storage_type}"
  vpc_security_group_ids = ["${var.security_group_ids}"]
  replicate_source_db    = "${var.replicate_source_db}"
  parameter_group_name   = "${var.parameter_group_name}"

  # TODO this should be enabled in a Production environment:
  final_snapshot_identifier = "${var.name}-final-snapshot"
  skip_final_snapshot       = "${var.skip_final_snapshot}"

  tags = "${merge(var.default_tags, map("Name", var.name))}"
}

resource "aws_db_instance" "db_instance" {
  # the 'name' parameter is not set as that creates a default database
  # of that name in the instance. Which we don't want.
  count = "${1 - var.create_replicate_source_db}"

  engine                  = "${var.engine_name}"
  engine_version          = "${var.engine_version}"
  username                = "${var.username}"
  password                = "${var.password}"
  allocated_storage       = "${var.allocated_storage}"
  instance_class          = "${var.instance_class}"
  storage_type            = "${var.storage_type}"
  db_subnet_group_name    = "${aws_db_subnet_group.subnet_group.name}"
  vpc_security_group_ids  = ["${var.security_group_ids}"]
  multi_az                = "${var.multi_az}"
  parameter_group_name    = "${var.parameter_group_name}"
  maintenance_window      = "${var.maintenance_window}"
  backup_retention_period = "${var.backup_retention_period}"
  backup_window           = "${var.backup_window}"

  # TODO this should be enabled in a Production environment:
  final_snapshot_identifier = "${var.name}-final-snapshot"
  skip_final_snapshot       = "${var.skip_final_snapshot}"

  tags = "${merge(var.default_tags, map("Name", var.name))}"
}

# Outputs
#--------------------------------------------------------------

#
# There's a (known) problem with using conditionals in output resources where
# one branch of the conditional cannot resolve. This is why each of these has
# the weird `join("", aws_db_instance.db_instance_replica.*.id)`. It works
# by creating an empty array then string if there's no value. For more detail
# see:
#
# https://github.com/hashicorp/terraform/issues/11566#issuecomment-289417805
# https://github.com/coreos/tectonic-installer/blob/4c7c26d7fe57dfad8b7168a9cca06f2226e7c1f7/modules/aws/vpc/vpc.tf
#

output "rds_instance_id" {
  value = "${var.create_replicate_source_db > 0 ? join("", aws_db_instance.db_instance_replica.*.id) : aws_db_instance.db_instance.id}"
}

output "rds_instance_resource_id" {
  value = "${var.create_replicate_source_db > 0 ? join("", aws_db_instance.db_instance_replica.*.resource_id) : aws_db_instance.db_instance.resource_id}"
}

output "rds_instance_endpoint" {
  value = "${var.create_replicate_source_db > 0 ? join("", aws_db_instance.db_instance_replica.*.endpoint) : aws_db_instance.db_instance.endpoint}"
}

output "rds_instance_address" {
  value = "${var.create_replicate_source_db > 0 ? join("", aws_db_instance.db_instance_replica.*.address) : aws_db_instance.db_instance.address}"
}
