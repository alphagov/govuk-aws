/**
* ## Project: app-backend-redis
*
* Backend VDC Redis Elasticache cluster
*/
variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-1"
}

variable "stackname" {
  type        = string
  description = "Stackname"
}

variable "aws_environment" {
  type        = string
  description = "AWS Environment"
}

variable "enable_clustering" {
  type        = bool
  description = "Enable clustering"
  default     = false
}

variable "instance_type" {
  type        = string
  description = "Instance type used for Elasticache nodes"
  default     = "cache.r4.large"
}

variable "internal_zone_name" {
  type        = string
  description = "The name of the Route53 zone that contains internal records"
}

variable "internal_domain_name" {
  type        = string
  description = "The domain name of the internal DNS records, it could be different from the zone name"
}

variable "node_number" {
  type        = string
  description = "Override the number of nodes per cluster specified by the module."
  default     = "2"
}

variable "redis_engine_version" {
  type        = string
  description = "The Elasticache Redis engine version."
  default     = "3.2.10"
}

variable "redis_parameter_group_name" {
  type        = string
  description = "The Elasticache Redis parameter group name."
  default     = "default.redis3.2"
}

# Resources
# --------------------------------------------------------------
terraform {
  backend "s3" {}
  required_version = "= 0.12.30"
}

provider "aws" {
  region  = var.aws_region
  version = "= 3.37.0"
}

data "aws_route53_zone" "internal" {
  name         = "${var.internal_zone_name}"
  private_zone = true
}

resource "aws_route53_record" "service_record" {
  zone_id = "${data.aws_route53_zone.internal.zone_id}"
  name    = "backend-redis.${var.internal_domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = ["${module.backend_redis_cluster.configuration_endpoint_address}"]
}

module "backend_redis_cluster" {
  source                     = "../../modules/aws/elasticache_redis_cluster"
  enable_clustering          = var.enable_clustering
  name                       = "${var.stackname}-backend-redis"
  default_tags               = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "backend-redis")}"
  subnet_ids                 = data.terraform_remote_state.infra_networking.outputs.private_subnet_elasticache_ids
  security_group_ids         = [data.terraform_remote_state.infra_security_groups.outputs.sg_backend-redis_id]
  elasticache_node_type      = "${var.instance_type}"
  elasticache_node_number    = "${var.node_number}"
  redis_engine_version       = "${var.redis_engine_version}"
  redis_parameter_group_name = "${var.redis_parameter_group_name}"
}

module "alarms-elasticache-backend-redis" {
  source           = "../../modules/aws/alarms/elasticache"
  name_prefix      = "${var.stackname}-backend-redis"
  alarm_actions    = [data.terraform_remote_state.infra_monitoring.outputs.sns_topic_cloudwatch_alarms_arn]
  cache_cluster_id = "${module.backend_redis_cluster.replication_group_id}"
}

# Outputs
# --------------------------------------------------------------

output "backend_redis_configuration_endpoint_address" {
  value       = "${module.backend_redis_cluster.configuration_endpoint_address}"
  description = "Backend VDC redis configuration endpoint address"
}

output "service_dns_name" {
  value       = "${aws_route53_record.service_record.fqdn}"
  description = "DNS name to access the node service"
}
