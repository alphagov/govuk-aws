/**
* ## Project: app-backend-redis
*
* Backend VDC Redis Elasticache cluster
*/
variable "aws_region" {
  type        = "string"
  description = "AWS region"
  default     = "eu-west-1"
}

variable "stackname" {
  type        = "string"
  description = "Stackname"
}

variable "aws_environment" {
  type        = "string"
  description = "AWS Environment"
}

variable "enable_clustering" {
  type        = "string"
  description = "Enable clustering"
  default     = false
}

variable "internal_zone_name" {
  type        = "string"
  description = "The name of the Route53 zone that contains internal records"
}

variable "internal_domain_name" {
  type        = "string"
  description = "The domain name of the internal DNS records, it could be different from the zone name"
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
  source                = "../../modules/aws/elasticache_redis_cluster"
  enable_clustering     = "${var.enable_clustering}"
  name                  = "${var.stackname}-backend-redis"
  default_tags          = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "backend-redis")}"
  subnet_ids            = "${data.terraform_remote_state.infra_networking.private_subnet_elasticache_ids}"
  security_group_ids    = ["${data.terraform_remote_state.infra_security_groups.sg_backend-redis_id}"]
  elasticache_node_type = "cache.r4.large"
}

module "alarms-elasticache-backend-redis" {
  source           = "../../modules/aws/alarms/elasticache"
  name_prefix      = "${var.stackname}-backend-redis"
  alarm_actions    = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
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
