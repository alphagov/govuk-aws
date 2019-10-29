/**
* ## Module: aws::rds_instance
*
* Create an RDS instance
*/
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

variable "max_allocated_storage" {
  type        = "string"
  description = "current maximum storage in GB that AWS can autoscale the RDS storage to, 0 means disabled autoscaling"
  default     = "0"
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

variable "instance_name" {
  type        = "string"
  description = "The RDS Instance Name."
  default     = ""
}

variable "security_group_ids" {
  type        = "list"
  description = "Security group IDs to apply to this cluster"
}

variable "multi_az" {
  type        = "string"
  description = "Specifies if the RDS instance is multi-AZ"
  default     = true
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
  description = "Set to true to NOT create a final snapshot when the cluster is deleted."
  default     = "false"
}

variable "maintenance_window" {
  type        = "string"
  description = "The window to perform maintenance in."
  default     = "Mon:04:00-Mon:06:00"
}

variable "backup_retention_period" {
  type        = "string"
  description = "The days to retain backups for."
  default     = "7"
}

variable "backup_window" {
  type        = "string"
  description = "The daily time range during which automated backups are created if automated backups are enabled."
  default     = "01:00-03:00"
}

variable "create_rds_notifications" {
  type        = "string"
  description = "Enable RDS events notifications"
  default     = true
}

variable "event_categories" {
  type        = "list"
  description = "A list of event categories for a SourceType that you want to subscribe to. See http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide//USER_Events.html"

  default = [
    "availability",
    "deletion",
    "failure",
    "low storage",
  ]
}

variable "event_sns_topic_arn" {
  type        = "string"
  description = "The SNS topic to send events to."
  default     = ""
}

variable "copy_tags_to_snapshot" {
  type        = "string"
  description = "Whether to copy the instance tags to the snapshot."
  default     = "true"
}

variable "snapshot_identifier" {
  type        = "string"
  description = "Specifies whether or not to create this database from a snapshot."
  default     = ""
}

variable "terraform_create_rds_timeout" {
  type        = "string"
  description = "Set the timeout time for AWS RDS creation."
  default     = "2h"
}

variable "terraform_update_rds_timeout" {
  type        = "string"
  description = "Set the timeout time for AWS RDS modification."
  default     = "2h"
}

variable "terraform_delete_rds_timeout" {
  type        = "string"
  description = "Set the timeout time for AWS RDS deletion."
  default     = "2h"
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
  identifier             = "${var.instance_name}"
  storage_type           = "${var.storage_type}"
  vpc_security_group_ids = ["${var.security_group_ids}"]
  replicate_source_db    = "${var.replicate_source_db}"
  parameter_group_name   = "${var.parameter_group_name}"

  timeouts {
    create = "${var.terraform_create_rds_timeout}"
    delete = "${var.terraform_delete_rds_timeout}"
    update = "${var.terraform_update_rds_timeout}"
  }

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
  max_allocated_storage   = "${var.max_allocated_storage}"
  instance_class          = "${var.instance_class}"
  identifier              = "${var.instance_name}"
  storage_type            = "${var.storage_type}"
  db_subnet_group_name    = "${aws_db_subnet_group.subnet_group.name}"
  vpc_security_group_ids  = ["${var.security_group_ids}"]
  multi_az                = "${var.multi_az}"
  parameter_group_name    = "${var.parameter_group_name}"
  maintenance_window      = "${var.maintenance_window}"
  backup_retention_period = "${var.backup_retention_period}"
  backup_window           = "${var.backup_window}"
  copy_tags_to_snapshot   = "${var.copy_tags_to_snapshot}"
  snapshot_identifier     = "${var.snapshot_identifier}"

  timeouts {
    create = "${var.terraform_create_rds_timeout}"
    delete = "${var.terraform_delete_rds_timeout}"
    update = "${var.terraform_update_rds_timeout}"
  }

  final_snapshot_identifier = "${var.name}-final-snapshot"
  skip_final_snapshot       = "${var.skip_final_snapshot}"

  tags = "${merge(var.default_tags, map("Name", var.name))}"
}

resource "aws_db_event_subscription" "event_subscription" {
  count     = "${(1 - var.create_replicate_source_db) * var.create_rds_notifications}"
  name      = "${var.name}-event-subscription"
  sns_topic = "${var.event_sns_topic_arn}"

  source_type      = "db-instance"
  source_ids       = ["${aws_db_instance.db_instance.id}"]
  event_categories = ["${var.event_categories}"]
}

resource "aws_db_event_subscription" "event_subscription_replica" {
  count     = "${var.create_replicate_source_db * var.create_rds_notifications}"
  name      = "${var.name}-event-subscription"
  sns_topic = "${var.event_sns_topic_arn}"

  source_type      = "db-instance"
  source_ids       = ["${aws_db_instance.db_instance_replica.id}"]
  event_categories = ["${var.event_categories}"]
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
  value = "${join("", aws_db_instance.db_instance.*.id)}"
}

output "rds_replica_id" {
  value = "${join("", aws_db_instance.db_instance_replica.*.id)}"
}

output "rds_instance_resource_id" {
  value = "${join("", aws_db_instance.db_instance.*.resource_id)}"
}

output "rds_replica_resource_id" {
  value = "${join("", aws_db_instance.db_instance_replica.*.resource_id)}"
}

output "rds_instance_endpoint" {
  value = "${join("", aws_db_instance.db_instance.*.endpoint)}"
}

output "rds_replica_endpoint" {
  value = "${join("", aws_db_instance.db_instance_replica.*.endpoint)}"
}

output "rds_instance_address" {
  value = "${join("", aws_db_instance.db_instance.*.address)}"
}

output "rds_replica_address" {
  value = "${join("", aws_db_instance.db_instance_replica.*.address)}"
}
