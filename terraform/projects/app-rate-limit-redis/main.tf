/**
* ## Project: app-rate-limit-redis
*
* Rate Limit VDC Redis Elasticache cluster
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
  required_version = "~> 1.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.38"
    }

  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_route53_zone" "internal" {
  name         = var.internal_zone_name
  private_zone = true
}

resource "aws_route53_record" "service_record" {
  zone_id = data.aws_route53_zone.internal.zone_id
  name    = "rate-limit-redis.${var.internal_domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [module.rate_limit_redis_cluster.configuration_endpoint_address]
}

module "rate_limit_redis_cluster" {
  source                     = "../../modules/aws/elasticache_redis_cluster"
  enable_clustering          = var.enable_clustering
  name                       = "${var.stackname}-rate-limit-redis"
  default_tags               = tomap({ "Project" = var.stackname, "aws_stackname" = var.stackname, "aws_environment" = var.aws_environment, "aws_migration" = "rate-limit-redis" })
  subnet_ids                 = data.terraform_remote_state.infra_networking.outputs.private_subnet_elasticache_ids
  security_group_ids         = [data.terraform_remote_state.infra_security_groups.outputs.sg_rate-limit-redis_id]
  elasticache_node_type      = var.instance_type
  elasticache_node_number    = var.node_number
  redis_engine_version       = var.redis_engine_version
  redis_parameter_group_name = var.redis_parameter_group_name
}

module "alarms-elasticache-rate-limit-redis" {
  source           = "../../modules/aws/alarms/elasticache"
  name_prefix      = "${var.stackname}-rate-limit-redis"
  alarm_actions    = [data.terraform_remote_state.infra_monitoring.outputs.sns_topic_cloudwatch_alarms_arn]
  cache_cluster_id = module.rate_limit_redis_cluster.replication_group_id
}

# Outputs
# --------------------------------------------------------------

output "rate_limit_redis_configuration_endpoint_address" {
  value       = module.rate_limit_redis_cluster.configuration_endpoint_address
  description = "Rate Limit VDC redis configuration endpoint address"
}

output "service_dns_name" {
  value       = aws_route53_record.service_record.fqdn
  description = "DNS name to access the node service"
}
