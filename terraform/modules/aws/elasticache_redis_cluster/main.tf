/**
* ## Module: aws/elasticache_redis_cluster
*
* Create a redis replication cluster and elasticache subnet group
*/

variable "name" {
  type        = string
  description = "The common name for all the resources created by this module"
}

variable "subnet_ids" {
  type        = list(any)
  description = "Subnet IDs to assign to the aws_elasticache_subnet_group"
}

variable "default_tags" {
  type        = map(any)
  description = "Additional resource tags"
  default     = {}
}

variable "elasticache_node_type" {
  type        = string
  description = "The node type to use. Must not be t.* in order to use failover."
  default     = "cache.m3.medium"
}

variable "elasticache_node_number" {
  type        = string
  description = "The number of nodes per cluster."
  default     = "2"
}

variable "security_group_ids" {
  type        = list(any)
  description = "Security group IDs to apply to this cluster"
}

variable "enable_clustering" {
  type        = bool
  description = "Set to true to enable clustering mode"
  default     = true
}

variable "redis_engine_version" {
  type        = string
  description = "The Elasticache Redis engine version."
}

variable "redis_parameter_group_name" {
  type        = string
  description = "The Elasticache Redis parameter group name."
}

locals {
  enable_clustering_count = var.enable_clustering ? 1 : 0
}

# Resources
# --------------------------------------------------------------

resource "aws_elasticache_subnet_group" "redis_cluster_subnet_group" {
  name       = var.name
  subnet_ids = var.subnet_ids
}

resource "aws_elasticache_replication_group" "redis_cluster" {
  count = local.enable_clustering_count

  # replication_group_id          = "${length(var.name) > 20 ? substr(var.name, 0, 20) : var.name}"
  replication_group_id          = var.name
  replication_group_description = "${var.name} redis cluster"
  node_type                     = var.elasticache_node_type
  port                          = 6379
  parameter_group_name          = "${var.redis_parameter_group_name}.cluster.on"
  automatic_failover_enabled    = true
  engine_version                = var.redis_engine_version
  subnet_group_name             = aws_elasticache_subnet_group.redis_cluster_subnet_group.name
  security_group_ids            = var.security_group_ids

  tags = merge(var.default_tags, tomap({ "Name" = var.name }))

  cluster_mode {
    replicas_per_node_group = 1
    num_node_groups         = 1
  }
}

resource "aws_elasticache_replication_group" "redis_master_with_replica" {
  count                         = 1 - local.enable_clustering_count
  replication_group_id          = var.name
  replication_group_description = "${var.name} redis master with replica"
  node_type                     = var.elasticache_node_type
  number_cache_clusters         = var.elasticache_node_number
  port                          = 6379
  parameter_group_name          = var.redis_parameter_group_name
  engine_version                = var.redis_engine_version
  automatic_failover_enabled    = true
  multi_az_enabled              = true

  subnet_group_name  = aws_elasticache_subnet_group.redis_cluster_subnet_group.name
  security_group_ids = var.security_group_ids

  tags = merge(var.default_tags, tomap({ "Name" = var.name }))
}

# Outputs
#--------------------------------------------------------------

// Configuration endpoint address of the redis cluster.
output "configuration_endpoint_address" {
  value       = var.enable_clustering ? join("", aws_elasticache_replication_group.redis_cluster.*.configuration_endpoint_address) : join("", aws_elasticache_replication_group.redis_master_with_replica.*.primary_endpoint_address)
  description = "Configuration endpoint address of the redis cluster."
}

// The ID of the ElastiCache Replication Group.
output "replication_group_id" {
  value       = var.enable_clustering ? join("", aws_elasticache_replication_group.redis_cluster.*.id) : join("", aws_elasticache_replication_group.redis_master_with_replica.*.id)
  description = "The ID of the ElastiCache Replication Group."
}
