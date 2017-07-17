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

variable "remote_state_bucket" {
  type        = "string"
  description = "S3 bucket we store our terraform state in"
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

data "terraform_remote_state" "infra_vpc" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket}"
    key    = "${var.stackname}/infra-vpc.tfstate"
    region = "eu-west-1"
  }
}

data "terraform_remote_state" "infra_networking" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket}"
    key    = "${var.stackname}/infra-networking.tfstate"
    region = "eu-west-1"
  }
}

data "terraform_remote_state" "infra_security_groups" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket}"
    key    = "${var.stackname}/infra-security-groups.tfstate"
    region = "eu-west-1"
  }
}

data "terraform_remote_state" "infra_internal_dns_zone" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket}"
    key    = "${var.stackname}/infra-internal-dns-zone.tfstate"
    region = "eu-west-1"
  }
}

resource "aws_route53_record" "service_record" {
  zone_id = "${data.terraform_remote_state.infra_internal_dns_zone.internal_service_zone_id}"
  name    = "logs-redis"
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
