# == Manifest: projects::app-logs-redis
#
# Logs Redis Elasticache cluster
#
# === Variables:
#
# aws_region
# remote_state_bucket
# stackname
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
  name    = "logs-redis.${data.terraform_remote_state.infra_stack_dns_zones.internal_domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = ["${module.logs_redis_cluster.configuration_endpoint_address}"]
}

module "logs_redis_cluster" {
  source             = "../../modules/aws/elasticache_redis_cluster"
  name               = "${var.stackname}-logs-redis"
  default_tags       = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_migration", "logs-redis")}"
  subnet_ids         = "${data.terraform_remote_state.infra_networking.private_subnet_elasticache_ids}"
  security_group_ids = ["${data.terraform_remote_state.infra_security_groups.sg_logs-redis_id}"]
}

# Outputs
# --------------------------------------------------------------

output "logs_redis_configuration_endpoint_address" {
  value       = "${module.logs_redis_cluster.configuration_endpoint_address}"
  description = "Logs redis configuration endpoint address"
}

output "service_dns_name" {
  value       = "${aws_route53_record.service_record.fqdn}"
  description = "DNS name to access the node service"
}
