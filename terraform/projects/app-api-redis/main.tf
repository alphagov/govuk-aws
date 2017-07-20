# == Manifest: projects::app-api-redis
#
# API Redis Elasticache cluster
#
# === Variables:
#
# aws_region
# stackname
# aws_environment
#
# === Outputs:
#

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

# Resources
# --------------------------------------------------------------
terraform {
  backend          "s3"             {}
  required_version = "= 0.9.10"
}

provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_route53_record" "service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.internal_zone_id}"
  name    = "api-redis.${data.terraform_remote_state.infra_stack_dns_zones.internal_domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = ["${module.api_redis_cluster.configuration_endpoint_address}"]
}

module "api_redis_cluster" {
  source             = "../../modules/aws/elasticache_redis_cluster"
  name               = "${var.stackname}-api-redis"
  default_tags       = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "api-redis")}"
  subnet_ids         = "${data.terraform_remote_state.infra_networking.private_subnet_elasticache_ids}"
  security_group_ids = ["${data.terraform_remote_state.infra_security_groups.sg_api-redis_id}"]
}

# Outputs
# --------------------------------------------------------------

output "api_redis_configuration_endpoint_address" {
  value       = "${module.api_redis_cluster.configuration_endpoint_address}"
  description = "API redis configuration endpoint address"
}

output "service_dns_name" {
  value       = "${aws_route53_record.service_record.fqdn}"
  description = "DNS name to access the node service"
}
