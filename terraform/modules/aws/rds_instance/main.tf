# == Module: aws::rds_instance
#
# Create a RDS instance
#
# === Variables:
#
# subnet_ids
# security_group_ids
#
# === Outputs:
#
#

variable "name" {
  type        = "string"
  description = "The common name for all the resources created by this module"
}

variable "engine_name" {
  type        = "string"
  description = "RDS engine (eg mysql, postgresql)"
}

variable "engine_version" {
  type        = "string"
  description = "Which version of MySQL to use (eg 5.5.46)"
}

variable "default_tags" {
  type        = "map"
  description = "Additional resource tags"
  default     = {}
}

variable "subnet_ids" {
  type        = "list"
  description = "Subnet IDs to assign to the aws_elasticache_subnet_group"
}

variable "username" {
  type        = "string"
  description = "User to create on the database"
}

variable "password" {
  type        = "string"
  description = "Password for accessing the database."
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

# Resources
# --------------------------------------------------------------

resource "aws_db_subnet_group" "subnet_group" {
  name       = "${var.name}"
  subnet_ids = ["${var.subnet_ids}"]

  tags = "${merge(var.default_tags, map("Name", var.name))}"
}

resource "aws_db_instance" "db_instance_replica" {
  count                  = "${var.create_replicate_source_db}"
  name                   = "${var.name}"
  engine                 = "${var.engine_name}"
  engine_version         = "${var.engine_version}"
  username               = "${var.username}"
  password               = "${var.password}"
  allocated_storage      = "${var.allocated_storage}"
  instance_class         = "${var.instance_class}"
  storage_type           = "${var.storage_type}"
  db_subnet_group_name   = "${aws_db_subnet_group.subnet_group.name}"
  vpc_security_group_ids = ["${var.security_group_ids}"]
  replicate_source_db    = "${var.replicate_source_db}"

  tags = "${merge(var.default_tags, map("Name", var.name))}"
}

resource "aws_db_instance" "db_instance" {
  count                  = "${1 - var.create_replicate_source_db}"
  name                   = "${var.name}"
  engine                 = "${var.engine_name}"
  engine_version         = "${var.engine_version}"
  username               = "${var.username}"
  password               = "${var.password}"
  allocated_storage      = "${var.allocated_storage}"
  instance_class         = "${var.instance_class}"
  storage_type           = "${var.storage_type}"
  db_subnet_group_name   = "${aws_db_subnet_group.subnet_group.name}"
  vpc_security_group_ids = ["${var.security_group_ids}"]

  tags = "${merge(var.default_tags, map("Name", var.name))}"
}

# Outputs
#--------------------------------------------------------------

output "rds_instance_id" {
  value = "${var.create_replicate_source_db > 0 ? aws_db_instance.db_instance_replica.id : aws_db_instance.db_instance.id}"
}

output "rds_instance_resource_id" {
  value = "${var.create_replicate_source_db > 0 ? aws_db_instance.db_instance_replica.resource_id : aws_db_instance.db_instance.resource_id}"
}

output "rds_instance_endpoint" {
  value = "${var.create_replicate_source_db > 0 ? aws_db_instance.db_instance_replica.endpoint : aws_db_instance.db_instance.endpoint}"
}

output "rds_instance_address" {
  value = "${var.create_replicate_source_db > 0 ? aws_db_instance.db_instance_replica.address : aws_db_instance.db_instance.address}"
}
