/**
* ## Project: infra-public-services
*
* This project adds global resources for app components:
*   - public facing LBs and DNS entries
*   - internal DNS entries
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

variable "elb_public_certname" {
  type        = "string"
  description = "The ACM cert domain name to find the ARN of"
}

variable "elb_public_secondary_certname" {
  type        = "string"
  description = "The ACM secondary cert domain name to find the ARN of"
  default     = ""
}

variable "elb_public_internal_certname" {
  type        = "string"
  description = "The ACM secondary cert domain name to find the ARN of"
}

variable "app_stackname" {
  type        = "string"
  description = "Stackname of the app projects in this environment"
  default     = "blue"
}

variable "enable_lb_app_healthchecks" {
  type        = "string"
  description = "Use application specific target groups and healthchecks based on the list of services in the cname variable."
  default     = false
}

variable "apt_public_service_names" {
  type    = "list"
  default = []
}

variable "apt_public_service_cnames" {
  type    = "list"
  default = []
}

variable "ckan_public_service_names" {
  type    = "list"
  default = []
}

variable "ckan_public_service_cnames" {
  type    = "list"
  default = []
}

variable "content_data_api_db_admin_internal_service_names" {
  type    = "list"
  default = []
}

variable "content_data_api_postgresql_internal_service_names" {
  type    = "list"
  default = []
}

variable "deploy_public_service_names" {
  type    = "list"
  default = []
}

variable "graphite_public_service_names" {
  type    = "list"
  default = []
}

variable "prometheus_public_service_names" {
  type    = "list"
  default = []
}

variable "jumpbox_public_service_names" {
  type    = "list"
  default = []
}

variable "licensify_frontend_internal_service_cnames" {
  type    = "list"
  default = []
}

variable "licensify_frontend_internal_service_names" {
  type    = "list"
  default = []
}

variable "licensify_frontend_public_service_names" {
  type    = "list"
  default = []
}

variable "licensify_frontend_public_service_cnames" {
  type    = "list"
  default = []
}

variable "licensify_backend_public_service_names" {
  type    = "list"
  default = []
}

variable "licensify_backend_elb_public_certname" {
  type        = "string"
  description = "Domain name (CN) of the ACM cert to use for licensify_backend."
}

variable "monitoring_public_service_names" {
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

variable "ckan_internal_service_names" {
  type    = "list"
  default = []
}

variable "ckan_internal_service_cnames" {
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

variable "elasticsearch6_internal_service_names" {
  type    = "list"
  default = []
}

variable "graphite_internal_service_names" {
  type    = "list"
  default = []
}

variable "prometheus_internal_service_names" {
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

variable "monitoring_internal_service_names_cname_dest" {
  description = "This variable specifies the CNAME record destination to be associated with the service names defined in monitoring_internal_service_names"
  type        = "string"
  default     = "alert"
}

variable "puppetmaster_internal_service_names" {
  type    = "list"
  default = []
}

variable "rabbitmq_internal_service_names" {
  type    = "list"
  default = []
}

variable "rate_limit_redis_internal_service_names" {
  type    = "list"
  default = []
}

variable "router_backend_internal_service_names" {
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

variable "waf_logs_hec_endpoint" {
  description = "Splunk endpoint for shipping application firewall logs"
  type        = "string"
}

variable "waf_logs_hec_token" {
  description = "Splunk token for shipping application firewall logs"
  type        = "string"
}

# Resources
# --------------------------------------------------------------
terraform {
  backend "s3" {}
  required_version = "= 0.13.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.76"
    }
  }
}

provider "aws" {
  region = "${var.aws_region}"
}

provider "archive" {
  # Versions >= 2.0 don't work because TF 0.11 doesn't trust the signing cert.
  version = "~> 1.3"
}

#
# Apt: TODO EXTERNAL
#

resource "aws_route53_record" "apt_internal_service_names" {
  count   = "${length(var.apt_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_zone_id}"
  name    = "${element(var.apt_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.apt_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"]
  ttl     = "300"
}

#
# Backend-redis
#

resource "aws_route53_record" "backend_redis_internal_service_names" {
  count   = "${length(var.backend_redis_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_zone_id}"
  name    = "${element(var.backend_redis_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.backend_redis_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"]
  ttl     = "300"
}

#
# CKAN
#

module "ckan_public_lb" {
  source                                     = "../../modules/aws/lb"
  name                                       = "${var.stackname}-ckan-public"
  internal                                   = false
  vpc_id                                     = "${data.terraform_remote_state.infra_vpc.outputs.vpc_id}"
  access_logs_bucket_name                    = "${data.terraform_remote_state.infra_monitoring.outputs.aws_logging_bucket_id}"
  access_logs_bucket_prefix                  = "elb/${var.stackname}-ckan-public-elb"
  listener_certificate_domain_name           = "${var.elb_public_certname}"
  listener_secondary_certificate_domain_name = "${var.elb_public_secondary_certname}"
  listener_action                            = "${map("HTTPS:443", "HTTP:80")}"
  subnets                                    = data.terraform_remote_state.infra_networking.outputs.public_subnet_ids
  security_groups                            = ["${data.terraform_remote_state.infra_security_groups.outputs.sg_ckan_elb_external_id}"]
  alarm_actions                              = ["${data.terraform_remote_state.infra_monitoring.outputs.sns_topic_cloudwatch_alarms_arn}"]
  default_tags                               = "${map("Project", var.stackname, "aws_migration", "ckan", "aws_environment", var.aws_environment)}"
}

resource "aws_route53_record" "ckan_public_service_names" {
  count   = "${length(var.ckan_public_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.outputs.external_root_zone_id}"
  name    = "${element(var.ckan_public_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.outputs.external_root_domain_name}"
  type    = "A"

  alias {
    name                   = "${module.ckan_public_lb.lb_dns_name}"
    zone_id                = "${module.ckan_public_lb.lb_zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "ckan_public_service_cnames" {
  count   = "${length(var.ckan_public_service_cnames)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.outputs.external_root_zone_id}"
  name    = "${element(var.ckan_public_service_cnames, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.outputs.external_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.ckan_public_service_names, 0)}.${data.terraform_remote_state.infra_root_dns_zones.outputs.external_root_domain_name}"]
  ttl     = "300"
}

data "aws_autoscaling_groups" "ckan" {
  filter {
    name   = "key"
    values = ["Name"]
  }

  filter {
    name   = "value"
    values = ["blue-ckan"]
  }
}

resource "aws_autoscaling_attachment" "ckan_asg_attachment_alb" {
  count                  = "${length(data.aws_autoscaling_groups.ckan.names) > 0 ? 1 : 0}"
  autoscaling_group_name = "${element(data.aws_autoscaling_groups.ckan.names, 0)}"
  alb_target_group_arn   = "${element(module.ckan_public_lb.target_group_arns, 0)}"
}

resource "aws_route53_record" "ckan_internal_service_names" {
  count   = "${length(var.ckan_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_zone_id}"
  name    = "${element(var.ckan_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.ckan_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"]
  ttl     = "300"
}

resource "aws_route53_record" "ckan_internal_service_cnames" {
  count   = "${length(var.ckan_internal_service_cnames)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_zone_id}"
  name    = "${element(var.ckan_internal_service_cnames, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.ckan_internal_service_names, 0)}.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"]
  ttl     = "300"
}

#
# Content Data API: DB Admin
#

resource "aws_route53_record" "content_data_api_db_admin_internal_service_names" {
  count   = "${length(var.content_data_api_db_admin_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_zone_id}"
  name    = "${element(var.content_data_api_db_admin_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.content_data_api_db_admin_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"]
  ttl     = "300"
}

#
# Content Data API: Postgresql
#

resource "aws_route53_record" "content_data_api_postgresql_internal_service_names" {
  count   = "${length(var.content_data_api_postgresql_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_zone_id}"
  name    = "${element(var.content_data_api_postgresql_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.content_data_api_postgresql_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"]
  ttl     = "300"
}

# Db-admin

resource "aws_route53_record" "db_admin_internal_service_names" {
  count   = "${length(var.db_admin_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_zone_id}"
  name    = "${element(var.db_admin_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.db_admin_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"]
  ttl     = "300"
}

# Deploy

module "deploy_public_lb" {
  source                                     = "../../modules/aws/lb"
  name                                       = "${var.stackname}-deploy-public"
  internal                                   = false
  vpc_id                                     = "${data.terraform_remote_state.infra_vpc.outputs.vpc_id}"
  access_logs_bucket_name                    = "${data.terraform_remote_state.infra_monitoring.outputs.aws_logging_bucket_id}"
  access_logs_bucket_prefix                  = "elb/${var.stackname}-deploy-public-elb"
  listener_certificate_domain_name           = "${var.elb_public_certname}"
  listener_secondary_certificate_domain_name = "${var.elb_public_secondary_certname}"
  listener_action                            = "${map("HTTPS:443", "HTTP:80")}"
  subnets                                    = data.terraform_remote_state.infra_networking.outputs.public_subnet_ids
  security_groups                            = ["${data.terraform_remote_state.infra_security_groups.outputs.sg_deploy_elb_id}"]
  alarm_actions                              = ["${data.terraform_remote_state.infra_monitoring.outputs.sns_topic_cloudwatch_alarms_arn}"]
  default_tags                               = "${map("Project", var.stackname, "aws_migration", "deploy", "aws_environment", var.aws_environment)}"
}

resource "aws_route53_record" "deploy_public_service_names" {
  count   = "${length(var.deploy_public_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.outputs.external_root_zone_id}"
  name    = "${element(var.deploy_public_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.outputs.external_root_domain_name}"
  type    = "A"

  alias {
    name                   = "${module.deploy_public_lb.lb_dns_name}"
    zone_id                = "${module.deploy_public_lb.lb_zone_id}"
    evaluate_target_health = true
  }
}

data "aws_autoscaling_groups" "deploy" {
  filter {
    name   = "key"
    values = ["Name"]
  }

  filter {
    name   = "value"
    values = ["${var.app_stackname}-deploy"]
  }
}

resource "aws_autoscaling_attachment" "deploy_asg_attachment_alb" {
  count                  = "${length(data.aws_autoscaling_groups.deploy.names) > 0 ? 1 : 0}"
  autoscaling_group_name = "${element(data.aws_autoscaling_groups.deploy.names, 0)}"
  alb_target_group_arn   = "${element(module.deploy_public_lb.target_group_arns, 0)}"
}

resource "aws_route53_record" "deploy_internal_service_names" {
  count   = "${length(var.deploy_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_zone_id}"
  name    = "${element(var.deploy_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.deploy_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"]
  ttl     = "300"
}

#
# Docker-management
#

resource "aws_route53_record" "docker_management_internal_service_names" {
  count   = "${length(var.docker_management_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_zone_id}"
  name    = "${element(var.docker_management_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.docker_management_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"]
  ttl     = "300"
}

#
# elasticsearch6
#

resource "aws_route53_record" "elasticsearch6_internal_service_names" {
  count   = "${length(var.elasticsearch6_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_zone_id}"
  name    = "${element(var.elasticsearch6_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.elasticsearch6_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"]
  ttl     = "300"
}

#
# Graphite
#

module "graphite_public_lb" {
  source                                     = "../../modules/aws/lb"
  name                                       = "${var.stackname}-graphite-public"
  internal                                   = false
  vpc_id                                     = "${data.terraform_remote_state.infra_vpc.outputs.vpc_id}"
  access_logs_bucket_name                    = "${data.terraform_remote_state.infra_monitoring.outputs.aws_logging_bucket_id}"
  access_logs_bucket_prefix                  = "elb/${var.stackname}-graphite-public-elb"
  listener_certificate_domain_name           = "${var.elb_public_certname}"
  listener_secondary_certificate_domain_name = "${var.elb_public_secondary_certname}"
  listener_action                            = "${map("HTTPS:443", "HTTP:80")}"
  subnets                                    = data.terraform_remote_state.infra_networking.outputs.public_subnet_ids
  security_groups                            = ["${data.terraform_remote_state.infra_security_groups.outputs.sg_graphite_external_elb_id}"]
  alarm_actions                              = ["${data.terraform_remote_state.infra_monitoring.outputs.sns_topic_cloudwatch_alarms_arn}"]
  default_tags                               = "${map("Project", var.stackname, "aws_migration", "graphite", "aws_environment", var.aws_environment)}"
}

#
# Prometheus
#

data "aws_autoscaling_groups" "prometheus" {
  filter {
    name   = "key"
    values = ["Name"]
  }

  filter {
    name   = "value"
    values = ["blue-prometheus-1"]
  }
}

module "prometheus_public_lb" {
  source                                     = "../../modules/aws/lb"
  name                                       = "${var.stackname}-prometheus-public"
  internal                                   = false
  vpc_id                                     = "${data.terraform_remote_state.infra_vpc.outputs.vpc_id}"
  access_logs_bucket_name                    = "${data.terraform_remote_state.infra_monitoring.outputs.aws_logging_bucket_id}"
  access_logs_bucket_prefix                  = "elb/${var.stackname}-prometheus-public-elb"
  listener_certificate_domain_name           = "${var.elb_public_certname}"
  listener_secondary_certificate_domain_name = "${var.elb_public_secondary_certname}"
  listener_action                            = "${map("HTTPS:443", "HTTP:80")}"
  subnets                                    = data.terraform_remote_state.infra_networking.outputs.public_subnet_ids
  security_groups                            = ["${data.terraform_remote_state.infra_security_groups.outputs.sg_prometheus_external_elb_id}"]
  alarm_actions                              = ["${data.terraform_remote_state.infra_monitoring.outputs.sns_topic_cloudwatch_alarms_arn}"]
  default_tags                               = "${map("Project", var.stackname, "aws_migration", "prometheus", "aws_environment", var.aws_environment)}"
  target_group_health_check_path             = "/-/ready"
}

resource "aws_route53_record" "prometheus_public_service_names" {
  count   = "${length(var.prometheus_public_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.outputs.external_root_zone_id}"
  name    = "${element(var.prometheus_public_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.outputs.external_root_domain_name}"
  type    = "A"

  alias {
    name                   = "${module.prometheus_public_lb.lb_dns_name}"
    zone_id                = "${module.prometheus_public_lb.lb_zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_autoscaling_attachment" "prometheus_asg_attachment_alb" {
  count                  = "${length(data.aws_autoscaling_groups.prometheus.names) > 0 ? 1 : 0}"
  autoscaling_group_name = "${element(data.aws_autoscaling_groups.prometheus.names, 0)}"
  alb_target_group_arn   = "${element(module.prometheus_public_lb.target_group_arns, 0)}"
}

resource "aws_route53_record" "prometheus_internal_service_names" {
  count   = "${length(var.prometheus_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_zone_id}"
  name    = "${element(var.prometheus_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.prometheus_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"]
  ttl     = "300"
}

#
# Graphite
#

resource "aws_route53_record" "graphite_public_service_names" {
  count   = "${length(var.graphite_public_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.outputs.external_root_zone_id}"
  name    = "${element(var.graphite_public_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.outputs.external_root_domain_name}"
  type    = "A"

  alias {
    name                   = "${module.graphite_public_lb.lb_dns_name}"
    zone_id                = "${module.graphite_public_lb.lb_zone_id}"
    evaluate_target_health = true
  }
}

data "aws_autoscaling_groups" "graphite" {
  filter {
    name   = "key"
    values = ["Name"]
  }

  filter {
    name   = "value"
    values = ["${var.app_stackname}-graphite-1"]
  }
}

resource "aws_autoscaling_attachment" "graphite_asg_attachment_alb" {
  count                  = "${length(data.aws_autoscaling_groups.graphite.names) > 0 ? 1 : 0}"
  autoscaling_group_name = "${element(data.aws_autoscaling_groups.graphite.names, 0)}"
  alb_target_group_arn   = "${element(module.graphite_public_lb.target_group_arns, 0)}"
}

resource "aws_route53_record" "graphite_internal_service_names" {
  count   = "${length(var.graphite_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_zone_id}"
  name    = "${element(var.graphite_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.graphite_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"]
  ttl     = "300"
}

#
# Jumpbox
#

resource "aws_elb" "jumpbox_public_elb" {
  name            = "${var.stackname}-jumpbox"
  subnets         = data.terraform_remote_state.infra_networking.outputs.public_subnet_ids
  security_groups = ["${data.terraform_remote_state.infra_security_groups.outputs.sg_offsite_ssh_id}"]
  internal        = "false"

  access_logs {
    bucket        = "${data.terraform_remote_state.infra_monitoring.outputs.aws_logging_bucket_id}"
    bucket_prefix = "elb/${var.stackname}-jumpbox-public-elb"
    interval      = 60
  }

  listener {
    instance_port     = "22"
    instance_protocol = "tcp"
    lb_port           = "22"
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:22"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = "${map("Name", "${var.stackname}-jumpbox", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "jumpbox")}"
}

resource "aws_route53_record" "jumpbox_public_service_names" {
  count   = "${length(var.jumpbox_public_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.outputs.external_root_zone_id}"
  name    = "${element(var.jumpbox_public_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.outputs.external_root_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.jumpbox_public_elb.dns_name}"
    zone_id                = "${aws_elb.jumpbox_public_elb.zone_id}"
    evaluate_target_health = true
  }
}

data "aws_autoscaling_groups" "jumpbox" {
  filter {
    name   = "key"
    values = ["Name"]
  }

  filter {
    name   = "value"
    values = ["${var.app_stackname}-jumpbox"]
  }
}

resource "aws_autoscaling_attachment" "jumpbox_asg_attachment_elb" {
  count                  = "${length(data.aws_autoscaling_groups.jumpbox.names) > 0 ? 1 : 0}"
  autoscaling_group_name = "${element(data.aws_autoscaling_groups.jumpbox.names, 0)}"
  elb                    = "${aws_elb.jumpbox_public_elb.id}"
}

module "alarms-elb-jumpbox-public" {
  source                         = "../../modules/aws/alarms/elb"
  name_prefix                    = "${var.stackname}-jumpbox"
  alarm_actions                  = ["${data.terraform_remote_state.infra_monitoring.outputs.sns_topic_cloudwatch_alarms_arn}"]
  elb_name                       = "${aws_elb.jumpbox_public_elb.name}"
  httpcode_backend_4xx_threshold = "0"
  httpcode_backend_5xx_threshold = "0"
  httpcode_elb_4xx_threshold     = "0"
  httpcode_elb_5xx_threshold     = "0"
  surgequeuelength_threshold     = "200"
  healthyhostcount_threshold     = "1"
}

#
# Licensify
#
# uploadlicence.publishing.service.gov.uk uses the licensify-frontend public lb
# and is still in use

module "licensify_frontend_public_lb" {
  source                                     = "../../modules/aws/lb"
  name                                       = "${var.stackname}-licensify-frontend-public"
  internal                                   = false
  vpc_id                                     = "${data.terraform_remote_state.infra_vpc.outputs.vpc_id}"
  access_logs_bucket_name                    = "${data.terraform_remote_state.infra_monitoring.outputs.aws_logging_bucket_id}"
  access_logs_bucket_prefix                  = "elb/${var.stackname}-licensify-frontend-public-elb"
  listener_certificate_domain_name           = "${var.elb_public_certname}"
  listener_secondary_certificate_domain_name = "${var.elb_public_secondary_certname}"
  target_group_health_check_path             = "/api/licences"

  listener_action = {
    "HTTPS:443" = "HTTP:80"
  }

  subnets         = data.terraform_remote_state.infra_networking.outputs.public_subnet_ids
  security_groups = ["${data.terraform_remote_state.infra_security_groups.outputs.sg_licensify-frontend_external_elb_id}"]
  alarm_actions   = ["${data.terraform_remote_state.infra_monitoring.outputs.sns_topic_cloudwatch_alarms_arn}"]

  default_tags = {
    Project         = "${var.stackname}"
    aws_migration   = "licensify-frontend"
    aws_environment = "${var.aws_environment}"
  }
}

resource "aws_lb_listener" "licensify_frontend_public_http_80" {
  load_balancer_arn = "${module.licensify_frontend_public_lb.lb_id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_route53_record" "licensify_frontend_public_service_names" {
  count   = "${length(var.licensify_frontend_public_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.outputs.external_root_zone_id}"
  name    = "${element(var.licensify_frontend_public_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.outputs.external_root_domain_name}"
  type    = "A"

  alias {
    name                   = "${module.licensify_frontend_public_lb.lb_dns_name}"
    zone_id                = "${module.licensify_frontend_public_lb.lb_zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "licensify_frontend_public_service_cnames" {
  count   = "${length(var.licensify_frontend_public_service_cnames)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.outputs.external_root_zone_id}"
  name    = "${element(var.licensify_frontend_public_service_cnames, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.outputs.external_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.licensify_frontend_public_service_names, 0)}.${data.terraform_remote_state.infra_root_dns_zones.outputs.external_root_domain_name}"]
  ttl     = "300"
}

data "aws_autoscaling_groups" "licensify_frontend" {
  filter {
    name   = "key"
    values = ["Name"]
  }

  filter {
    name   = "value"
    values = ["blue-licensify-frontend"]
  }
}

resource "aws_autoscaling_attachment" "licensify_frontend_asg_attachment_alb" {
  count                  = "${length(data.aws_autoscaling_groups.licensify_frontend.names) > 0 ? 1 : 0}"
  autoscaling_group_name = "${element(data.aws_autoscaling_groups.licensify_frontend.names, 0)}"
  alb_target_group_arn   = "${element(module.licensify_frontend_public_lb.target_group_arns, 0)}"
}

resource "aws_route53_record" "licensify_frontend_internal_service_names" {
  count   = "${length(var.licensify_frontend_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_zone_id}"
  name    = "${element(var.licensify_frontend_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.licensify_frontend_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"]
  ttl     = "300"
}

resource "aws_route53_record" "licensify_frontend_internal_service_cnames" {
  count   = "${length(var.licensify_frontend_internal_service_cnames)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_zone_id}"
  name    = "${element(var.licensify_frontend_internal_service_cnames, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.licensify_frontend_internal_service_names, 0)}.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"]
  ttl     = "300"
}

#
# Licensing (Licensify) backend
#

module "licensify_backend_public_lb" {
  source                           = "../../modules/aws/lb"
  name                             = "licensify-backend-public"
  internal                         = false
  vpc_id                           = "${data.terraform_remote_state.infra_vpc.outputs.vpc_id}"
  access_logs_bucket_name          = "${data.terraform_remote_state.infra_monitoring.outputs.aws_logging_bucket_id}"
  access_logs_bucket_prefix        = "elb/licensify-backend-public-elb"
  listener_certificate_domain_name = "${var.licensify_backend_elb_public_certname}"
  target_group_health_check_path   = "/healthcheck"

  listener_action = {
    "HTTPS:443" = "HTTP:80"
  }

  subnets         = data.terraform_remote_state.infra_networking.outputs.public_subnet_ids
  security_groups = ["${data.terraform_remote_state.infra_security_groups.outputs.sg_licensify-backend_external_elb_id}"]
  alarm_actions   = ["${data.terraform_remote_state.infra_monitoring.outputs.sns_topic_cloudwatch_alarms_arn}"]

  default_tags = {
    Project         = "${var.stackname}"
    aws_migration   = "licensify_backend"
    aws_environment = "${var.aws_environment}"
  }
}

# Listener for licensify-admin HTTP-to-HTTPS redirect. Does not forward any
# traffic, only serves redirects directly from the ALB.
resource "aws_lb_listener" "licensify_backend_http_80" {
  load_balancer_arn = "${module.licensify_backend_public_lb.lb_id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_route53_record" "licensify_backend_public_service_names" {
  count   = "${length(var.licensify_backend_public_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.outputs.external_root_zone_id}"
  name    = "${element(var.licensify_backend_public_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.outputs.external_root_domain_name}"
  type    = "A"

  alias {
    name                   = "${module.licensify_backend_public_lb.lb_dns_name}"
    zone_id                = "${module.licensify_backend_public_lb.lb_zone_id}"
    evaluate_target_health = true
  }
}

data "aws_autoscaling_groups" "licensify_backend" {
  filter {
    name   = "key"
    values = ["Name"]
  }

  filter {
    name   = "value"
    values = ["licensify-backend"]
  }
}

resource "aws_autoscaling_attachment" "licensify_backend_asg_attachment_alb" {
  count                  = "${length(data.aws_autoscaling_groups.licensify_backend.names) > 0 ? 1 : 0}"
  autoscaling_group_name = "${element(data.aws_autoscaling_groups.licensify_backend.names, 0)}"
  alb_target_group_arn   = "${element(module.licensify_backend_public_lb.target_group_arns, 0)}"
}

#
# Mongo
#

resource "aws_route53_record" "mongo_internal_service_names" {
  count   = "${length(var.mongo_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_zone_id}"
  name    = "${element(var.mongo_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.mongo_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"]
  ttl     = "300"
}

#
# Monitoring
#

module "monitoring_public_lb" {
  source                                     = "../../modules/aws/lb"
  name                                       = "${var.stackname}-monitoring-public"
  internal                                   = false
  vpc_id                                     = "${data.terraform_remote_state.infra_vpc.outputs.vpc_id}"
  access_logs_bucket_name                    = "${data.terraform_remote_state.infra_monitoring.outputs.aws_logging_bucket_id}"
  access_logs_bucket_prefix                  = "elb/${var.stackname}-monitoring-public-elb"
  listener_certificate_domain_name           = "${var.elb_public_certname}"
  listener_secondary_certificate_domain_name = "${var.elb_public_secondary_certname}"
  listener_action                            = "${map("HTTPS:443", "HTTP:80")}"
  subnets                                    = data.terraform_remote_state.infra_networking.outputs.public_subnet_ids
  security_groups                            = ["${data.terraform_remote_state.infra_security_groups.outputs.sg_monitoring_external_elb_id}"]
  alarm_actions                              = ["${data.terraform_remote_state.infra_monitoring.outputs.sns_topic_cloudwatch_alarms_arn}"]
  default_tags                               = "${map("Project", var.stackname, "aws_migration", "monitoring", "aws_environment", var.aws_environment)}"
}

resource "aws_route53_record" "monitoring_public_service_names" {
  count   = "${length(var.monitoring_public_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.outputs.external_root_zone_id}"
  name    = "${element(var.monitoring_public_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.outputs.external_root_domain_name}"
  type    = "A"

  alias {
    name                   = "${module.monitoring_public_lb.lb_dns_name}"
    zone_id                = "${module.monitoring_public_lb.lb_zone_id}"
    evaluate_target_health = true
  }
}

data "aws_autoscaling_groups" "monitoring" {
  filter {
    name   = "key"
    values = ["Name"]
  }

  filter {
    name   = "value"
    values = ["${var.app_stackname}-monitoring"]
  }
}

resource "aws_autoscaling_attachment" "monitoring_asg_attachment_alb" {
  count                  = "${length(data.aws_autoscaling_groups.monitoring.names) > 0 ? 1 : 0}"
  autoscaling_group_name = "${element(data.aws_autoscaling_groups.monitoring.names, 0)}"
  alb_target_group_arn   = "${element(module.monitoring_public_lb.target_group_arns, 0)}"
}

resource "aws_route53_record" "monitoring_internal_service_names" {
  count   = "${length(var.monitoring_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_zone_id}"
  name    = "${element(var.monitoring_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${var.monitoring_internal_service_names_cname_dest}.blue.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"]
  ttl     = "300"
}

#
# puppetmaster
#

resource "aws_route53_record" "puppetmaster_internal_service_names" {
  count   = "${length(var.puppetmaster_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_zone_id}"
  name    = "${element(var.puppetmaster_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.puppetmaster_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"]
  ttl     = "300"
}

#
# rabbitmq
#

resource "aws_route53_record" "rabbitmq_internal_service_names" {
  count   = "${length(var.rabbitmq_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_zone_id}"
  name    = "${element(var.rabbitmq_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.rabbitmq_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"]
  ttl     = "300"
}

#
# rate-limit-redis
#

resource "aws_route53_record" "rate_limit_redis_internal_service_names" {
  count   = "${length(var.rate_limit_redis_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_zone_id}"
  name    = "${element(var.rate_limit_redis_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.rate_limit_redis_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"]
  ttl     = "300"
}

#
# router_backend
#

resource "aws_route53_record" "router_backend_internal_service_names" {
  count   = "${length(var.router_backend_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_zone_id}"
  name    = "${element(var.router_backend_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.router_backend_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"]
  ttl     = "300"
}

#
# search
#

data "aws_autoscaling_groups" "search" {
  filter {
    name   = "key"
    values = ["Name"]
  }

  filter {
    name   = "value"
    values = ["blue-search"]
  }
}

resource "aws_route53_record" "search_internal_service_names" {
  count   = "${length(var.search_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_zone_id}"
  name    = "${element(var.search_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.search_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"]
  ttl     = "300"
}

resource "aws_route53_record" "search_internal_service_cnames" {
  count   = "${length(var.search_internal_service_cnames)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_zone_id}"
  name    = "${element(var.search_internal_service_cnames, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.search_internal_service_names, 0)}.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"]
  ttl     = "300"
}

#
# transition_db_admin
#

resource "aws_route53_record" "transition_db_admin_internal_service_names" {
  count   = "${length(var.transition_db_admin_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_zone_id}"
  name    = "${element(var.transition_db_admin_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.transition_db_admin_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"]
  ttl     = "300"
}

#
# transition_postgresql
#

resource "aws_route53_record" "transition_postgresql_internal_service_names" {
  count   = "${length(var.transition_postgresql_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_zone_id}"
  name    = "${element(var.transition_postgresql_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.transition_postgresql_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"]
  ttl     = "300"
}

# Outputs
# ---------------------

output "kinesis_firehose_splunk_arn" {
  value       = "${aws_kinesis_firehose_delivery_stream.splunk.arn}"
  description = "The ARN of the splunk endpoint of the kinesis firehose stream"
}

output "ckan_public_lb_id" {
  value       = "${module.ckan_public_lb.lb_id}"
  description = "The ID of the ckan_public load balancer"
}

output "deploy_public_lb_id" {
  value       = "${module.deploy_public_lb.lb_id}"
  description = "The ID of the deploy_public load balancer"
}

output "graphite_public_lb_id" {
  value       = "${module.graphite_public_lb.lb_id}"
  description = "The ID of the graphite_public load balancer"
}

output "prometheus_public_lb_id" {
  value       = "${module.prometheus_public_lb.lb_id}"
  description = "The ID of the prometheus_public load balancer"
}

output "licensify_frontend_public_lb_id" {
  value       = "${module.licensify_frontend_public_lb.lb_id}"
  description = "The ID of the licensify_frontend_public_lb load balancer"
}

output "licensify_backend_public_lb_id" {
  value       = "${module.licensify_backend_public_lb.lb_id}"
  description = "The ID of the licensify_backend_public load balancer"
}

output "monitoring_public_lb_id" {
  value       = "${module.monitoring_public_lb.lb_id}"
  description = "The ID of the monitoring_public load balancer"
}
