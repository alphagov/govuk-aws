/**
* ## Project: infra-internal-services
*
* This project creates internal facing DNS entries that designate which stack
* is the current live service.
*
* For example, a CNAME is created for foo.integration.govuk-internal.digital
* that points to foo.blue.integration.govuk-internal.digital which denotes
* that the 'blue' stack is the live stack for this service.
*
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

variable "asset_master_internal_service_names" {
  type    = "list"
  default = []
}

variable "apt_internal_service_names" {
  type    = "list"
  default = []
}

variable "backend_redis_internal_service_names" {
  type    = "list"
  default = []
}

variable "backend_internal_service_names" {
  type    = "list"
  default = []
}

variable "backend_internal_service_cnames" {
  type    = "list"
  default = []
}

variable "bouncer_internal_service_names" {
  type    = "list"
  default = []
}

variable "cache_internal_service_names" {
  type    = "list"
  default = []
}

variable "cache_internal_service_cnames" {
  type    = "list"
  default = []
}

variable "calculators_frontend_internal_service_names" {
  type    = "list"
  default = []
}

variable "calculators_frontend_internal_service_cnames" {
  type    = "list"
  default = []
}

variable "content_store_internal_service_names" {
  type    = "list"
  default = []
}

variable "db_admin_internal_service_names" {
  type    = "list"
  default = []
}

variable "deploy_internal_service_names" {
  type    = "list"
  default = []
}

variable "docker_management_internal_service_names" {
  type    = "list"
  default = []
}

variable "draft_cache_internal_service_names" {
  type    = "list"
  default = []
}

variable "draft_cache_internal_service_cnames" {
  type    = "list"
  default = []
}

variable "draft_content_store_internal_service_names" {
  type    = "list"
  default = []
}

variable "draft_frontend_internal_service_names" {
  type    = "list"
  default = []
}

variable "draft_frontend_internal_service_cnames" {
  type    = "list"
  default = []
}

variable "frontend_internal_service_names" {
  type    = "list"
  default = []
}

variable "frontend_internal_service_cnames" {
  type    = "list"
  default = []
}

variable "graphite_internal_service_names" {
  type    = "list"
  default = []
}

variable "mapit_internal_service_names" {
  type    = "list"
  default = []
}

variable "mongo_internal_service_names" {
  type    = "list"
  default = []
}

variable "monitoring_internal_service_names" {
  type    = "list"
  default = []
}

variable "mysql_internal_service_names" {
  type    = "list"
  default = []
}

variable "postgresql_internal_service_names" {
  type    = "list"
  default = []
}

variable "publishing_api_internal_service_names" {
  type    = "list"
  default = []
}

variable "puppetmaster_internal_service_names" {
  type    = "list"
  default = []
}

variable "rabbitmq_internal_service_names" {
  type    = "list"
  default = []
}

variable "router_backend_internal_service_names" {
  type    = "list"
  default = []
}

variable "rummager_elasticsearch_internal_service_names" {
  type    = "list"
  default = []
}

variable "search_internal_service_names" {
  type    = "list"
  default = []
}

variable "search_internal_service_cnames" {
  type    = "list"
  default = []
}

variable "transition_db_admin_internal_service_names" {
  type    = "list"
  default = []
}

variable "transition_postgresql_internal_service_names" {
  type    = "list"
  default = []
}

variable "whitehall_backend_internal_service_names" {
  type    = "list"
  default = []
}

variable "whitehall_backend_internal_service_cnames" {
  type    = "list"
  default = []
}

variable "whitehall_frontend_internal_service_names" {
  type    = "list"
  default = []
}

# Resources
# --------------------------------------------------------------
terraform {
  backend          "s3"             {}
  required_version = "= 0.11.1"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "1.3.0"
}

#
# Apt
#

resource "aws_route53_record" "apt_internal_service_names" {
  count   = "${length(var.apt_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.apt_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.apt_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

#
# asset-master
#

resource "aws_route53_record" "asset_master_internal_service_names" {
  count   = "${length(var.asset_master_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.asset_master_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.asset_master_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

#
# Backend-redis
#

resource "aws_route53_record" "backend_redis_internal_service_names" {
  count   = "${length(var.backend_redis_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.backend_redis_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.backend_redis_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

#
# Backend
#

resource "aws_route53_record" "backend_internal_service_names" {
  count   = "${length(var.backend_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.backend_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.backend_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

resource "aws_route53_record" "backend_internal_service_cnames" {
  count   = "${length(var.backend_internal_service_cnames)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.backend_internal_service_cnames, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.backend_internal_service_names, 0)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

#
# Bouncer
#

resource "aws_route53_record" "bouncer_internal_service_names" {
  count   = "${length(var.bouncer_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.bouncer_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.bouncer_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

#
# Cache
#

resource "aws_route53_record" "cache_internal_service_names" {
  count   = "${length(var.cache_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.cache_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.cache_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

resource "aws_route53_record" "cache_internal_service_cnames" {
  count   = "${length(var.cache_internal_service_cnames)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.cache_internal_service_cnames, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.cache_internal_service_names, 0)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

# Calculators-frontend

resource "aws_route53_record" "calculators_frontend_internal_service_names" {
  count   = "${length(var.calculators_frontend_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.calculators_frontend_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.calculators_frontend_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

resource "aws_route53_record" "calculators_frontend_internal_service_cnames" {
  count   = "${length(var.calculators_frontend_internal_service_cnames)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.calculators_frontend_internal_service_cnames, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.calculators_frontend_internal_service_names, 0)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

# Content-store

resource "aws_route53_record" "content_store_internal_service_names" {
  count   = "${length(var.content_store_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.content_store_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.content_store_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

# Db-admin

resource "aws_route53_record" "db_admin_internal_service_names" {
  count   = "${length(var.db_admin_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.db_admin_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.db_admin_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

# Deploy

resource "aws_route53_record" "deploy_internal_service_names" {
  count   = "${length(var.deploy_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.deploy_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.deploy_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

#
# Docker-management
#

resource "aws_route53_record" "docker_management_internal_service_names" {
  count   = "${length(var.docker_management_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.docker_management_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.docker_management_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

#
# Draft-cache
#

resource "aws_route53_record" "draft_cache_internal_service_names" {
  count   = "${length(var.draft_cache_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.draft_cache_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.draft_cache_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

resource "aws_route53_record" "draft_cache_internal_service_cnames" {
  count   = "${length(var.draft_cache_internal_service_cnames)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.draft_cache_internal_service_cnames, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.draft_cache_internal_service_names, 0)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

#
# Draft-content-store
#

resource "aws_route53_record" "draft_content_store_internal_service_names" {
  count   = "${length(var.draft_content_store_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.draft_content_store_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.draft_content_store_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

#
# Draft-frontend
#

resource "aws_route53_record" "draft_frontend_internal_service_names" {
  count   = "${length(var.draft_frontend_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.draft_frontend_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.draft_frontend_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

resource "aws_route53_record" "draft_frontend_internal_service_cnames" {
  count   = "${length(var.draft_frontend_internal_service_cnames)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.draft_frontend_internal_service_cnames, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.draft_frontend_internal_service_names, 0)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

#
# frontend
#

resource "aws_route53_record" "frontend_internal_service_names" {
  count   = "${length(var.frontend_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.frontend_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.frontend_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

resource "aws_route53_record" "frontend_internal_service_cnames" {
  count   = "${length(var.frontend_internal_service_cnames)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.frontend_internal_service_cnames, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.frontend_internal_service_names, 0)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

#
# Graphite
#

resource "aws_route53_record" "graphite_internal_service_names" {
  count   = "${length(var.graphite_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.graphite_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.graphite_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

#
# Mapit
#

resource "aws_route53_record" "mapit_internal_service_names" {
  count   = "${length(var.mapit_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.mapit_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.mapit_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

#
# Mongo
#

resource "aws_route53_record" "mongo_internal_service_names" {
  count   = "${length(var.mongo_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.mongo_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.mongo_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

#
# Monitoring
#

resource "aws_route53_record" "monitoring_internal_service_names" {
  count   = "${length(var.monitoring_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.monitoring_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.monitoring_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

#
# Mysql
#

resource "aws_route53_record" "mysql_internal_service_names" {
  count   = "${length(var.mysql_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.mysql_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.mysql_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

#
# postgresql
#

resource "aws_route53_record" "postgresql_internal_service_names" {
  count   = "${length(var.postgresql_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.postgresql_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.postgresql_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

#
# publishing_api
#

resource "aws_route53_record" "publishing_api_internal_service_names" {
  count   = "${length(var.publishing_api_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.publishing_api_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.publishing_api_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

#
# puppetmaster
#

resource "aws_route53_record" "puppetmaster_internal_service_names" {
  count   = "${length(var.puppetmaster_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.puppetmaster_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.puppetmaster_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

#
# rabbitmq
#

resource "aws_route53_record" "rabbitmq_internal_service_names" {
  count   = "${length(var.rabbitmq_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.rabbitmq_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.rabbitmq_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

#
# router_backend
#

resource "aws_route53_record" "router_backend_internal_service_names" {
  count   = "${length(var.router_backend_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.router_backend_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.router_backend_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

#
# rummager_elasticsearch
#

resource "aws_route53_record" "rummager_elasticsearch_internal_service_names" {
  count   = "${length(var.rummager_elasticsearch_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.rummager_elasticsearch_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.rummager_elasticsearch_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

#
# search
#

resource "aws_route53_record" "search_internal_service_names" {
  count   = "${length(var.search_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.search_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.search_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

resource "aws_route53_record" "search_internal_service_cnames" {
  count   = "${length(var.search_internal_service_cnames)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.search_internal_service_cnames, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.search_internal_service_names, 0)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

#
# transition_db_admin
#

resource "aws_route53_record" "transition_db_admin_internal_service_names" {
  count   = "${length(var.transition_db_admin_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.transition_db_admin_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.transition_db_admin_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

#
# transition_postgresql
#

resource "aws_route53_record" "transition_postgresql_internal_service_names" {
  count   = "${length(var.transition_postgresql_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.transition_postgresql_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.transition_postgresql_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

#
# Whitehall-backend
#

resource "aws_route53_record" "whitehall_backend_internal_service_names" {
  count   = "${length(var.whitehall_backend_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.whitehall_backend_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.whitehall_backend_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

resource "aws_route53_record" "whitehall_backend_internal_service_cnames" {
  count   = "${length(var.whitehall_backend_internal_service_cnames)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.whitehall_backend_internal_service_cnames, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.whitehall_backend_internal_service_names, 0)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

#
# whitehall_frontend
#

resource "aws_route53_record" "whitehall_frontend_internal_service_names" {
  count   = "${length(var.whitehall_frontend_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.whitehall_frontend_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.whitehall_frontend_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}
