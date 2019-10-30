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

variable "backend_alb_blocked_host_headers" {
  type    = "list"
  default = []
}

variable "backend_public_service_names" {
  type    = "list"
  default = []
}

variable "backend_public_service_cnames" {
  type    = "list"
  default = []
}

variable "bouncer_public_service_names" {
  type    = "list"
  default = []
}

variable "cache_public_service_names" {
  type    = "list"
  default = []
}

variable "cache_public_service_cnames" {
  type    = "list"
  default = []
}

variable "calendars_public_service_names" {
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

variable "content_store_public_service_names" {
  type    = "list"
  default = []
}

variable "deploy_public_service_names" {
  type    = "list"
  default = []
}

variable "draft_cache_public_service_names" {
  type    = "list"
  default = []
}

variable "draft_cache_public_service_cnames" {
  type    = "list"
  default = []
}

variable "email_alert_api_public_service_names" {
  type    = "list"
  default = []
}

variable "feedback_public_service_names" {
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

variable "ubuntutest_public_service_names" {
  type    = "list"
  default = []
}

variable "licensify_backend_public_service_names" {
  type    = "list"
  default = []
}

variable "mapit_public_service_names" {
  type    = "list"
  default = []
}

variable "monitoring_public_service_names" {
  type    = "list"
  default = []
}

variable "static_public_service_names" {
  type    = "list"
  default = []
}

variable "support_api_public_service_names" {
  type    = "list"
  default = []
}

variable "whitehall_backend_public_service_names" {
  type    = "list"
  default = []
}

variable "whitehall_backend_public_service_cnames" {
  type    = "list"
  default = []
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

variable "ckan_internal_service_names" {
  type    = "list"
  default = []
}

variable "ckan_internal_service_cnames" {
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

variable "draft_whitehall_frontend_internal_service_names" {
  type    = "list"
  default = []
}

variable "elasticsearch6_internal_service_names" {
  type    = "list"
  default = []
}

variable "email_alert_api_internal_service_names" {
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

variable "prometheus_internal_service_names" {
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

variable "monitoring_internal_service_names_cname_dest" {
  description = "This variable specifies the CNAME record destination to be associated with the service names defined in monitoring_internal_service_names"
  type        = "string"
  default     = "alert"
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

variable "search_internal_service_names" {
  type    = "list"
  default = []
}

variable "search_internal_service_cnames" {
  type    = "list"
  default = []
}

variable "search_api_public_service_names" {
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

variable "draft_content_store_public_service_names" {
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
  backend          "s3"             {}
  required_version = "= 0.11.14"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "2.33.0"
}

#
# Apt: TODO EXTERNAL
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

module "backend_public_lb" {
  source                                     = "../../modules/aws/lb"
  name                                       = "${var.stackname}-backend-public"
  internal                                   = false
  vpc_id                                     = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  access_logs_bucket_name                    = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  access_logs_bucket_prefix                  = "elb/${var.stackname}-backend-public-elb"
  listener_certificate_domain_name           = "${var.elb_public_certname}"
  listener_secondary_certificate_domain_name = "${var.elb_public_secondary_certname}"
  listener_action                            = "${map("HTTPS:443", "HTTP:80")}"
  subnets                                    = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups                            = ["${data.terraform_remote_state.infra_security_groups.sg_backend_elb_external_id}"]
  alarm_actions                              = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  default_tags                               = "${map("Project", var.stackname, "aws_migration", "backend", "aws_environment", var.aws_environment)}"
}

resource "aws_wafregional_web_acl_association" "backend_public_lb" {
  resource_arn = "${module.backend_public_lb.lb_id}"
  web_acl_id   = "${aws_wafregional_web_acl.default.id}"
}

resource "aws_lb_listener_rule" "backend_alb_blocked_host_headers" {
  count        = "${length(var.backend_alb_blocked_host_headers)}"
  listener_arn = "${element(module.backend_public_lb.load_balancer_ssl_listeners, 0)}"
  priority     = "${count.index + 1}"

  action {
    type             = "fixed-response"
    target_group_arn = "${element(module.backend_public_lb.target_group_arns, 0)}"

    fixed_response = {
      content_type = "text/html"
      status_code  = "403"
    }
  }

  condition {
    field  = "host-header"
    values = ["${element(var.backend_alb_blocked_host_headers, count.index)}"]
  }
}

module "backend_public_lb_rules" {
  source                 = "../../modules/aws/lb_listener_rules"
  name                   = "backend"
  autoscaling_group_name = "${data.aws_autoscaling_group.backend.name}"
  rules_host_domain      = "*"
  vpc_id                 = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  listener_arn           = "${module.backend_public_lb.load_balancer_ssl_listeners[0]}"
  rules_host             = ["${compact(split(",", var.enable_lb_app_healthchecks ? join(",", var.backend_public_service_cnames) : ""))}"]
  priority_offset        = "${length(var.backend_alb_blocked_host_headers) + 1}"
  default_tags           = "${map("Project", var.stackname, "aws_migration", "backend", "aws_environment", var.aws_environment)}"
}

resource "aws_route53_record" "backend_public_service_names" {
  count   = "${length(var.backend_public_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.external_root_zone_id}"
  name    = "${element(var.backend_public_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.external_root_domain_name}"
  type    = "A"

  alias {
    name                   = "${module.backend_public_lb.lb_dns_name}"
    zone_id                = "${module.backend_public_lb.lb_zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "backend_public_service_cnames" {
  count   = "${length(var.backend_public_service_cnames)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.external_root_zone_id}"
  name    = "${element(var.backend_public_service_cnames, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.external_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.backend_public_service_names, 0)}.${data.terraform_remote_state.infra_root_dns_zones.external_root_domain_name}"]
  ttl     = "300"
}

data "aws_autoscaling_group" "backend" {
  name = "${var.app_stackname}-backend"
}

resource "aws_autoscaling_attachment" "backend_asg_attachment_alb" {
  count                  = "${data.aws_autoscaling_group.backend.name != "" ? 1 : 0}"
  autoscaling_group_name = "${data.aws_autoscaling_group.backend.name}"
  alb_target_group_arn   = "${element(module.backend_public_lb.target_group_arns, 0)}"
}

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

module "bouncer_public_lb" {
  source                                     = "../../modules/aws/lb"
  name                                       = "${var.stackname}-bouncer-public"
  internal                                   = false
  vpc_id                                     = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  access_logs_bucket_name                    = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  access_logs_bucket_prefix                  = "elb/${var.stackname}-bouncer-public-elb"
  listener_certificate_domain_name           = "${var.elb_public_certname}"
  listener_secondary_certificate_domain_name = "${var.elb_public_secondary_certname}"

  listener_action = {
    "HTTP:80"   = "HTTP:80"
    "HTTPS:443" = "HTTP:80"
  }

  target_group_health_check_path = "/healthcheck"
  subnets                        = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups                = ["${data.terraform_remote_state.infra_security_groups.sg_bouncer_elb_id}"]
  alarm_actions                  = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  default_tags                   = "${map("Project", var.stackname, "aws_migration", "bouncer", "aws_environment", var.aws_environment)}"
}

resource "aws_route53_record" "bouncer_public_service_names" {
  count   = "${length(var.bouncer_public_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.external_root_zone_id}"
  name    = "${element(var.bouncer_public_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.external_root_domain_name}"
  type    = "A"

  alias {
    name                   = "${module.bouncer_public_lb.lb_dns_name}"
    zone_id                = "${module.bouncer_public_lb.lb_zone_id}"
    evaluate_target_health = true
  }
}

data "aws_autoscaling_groups" "bouncer" {
  filter {
    name   = "key"
    values = ["Name"]
  }

  filter {
    name   = "value"
    values = ["blue-bouncer"]
  }
}

resource "aws_autoscaling_attachment" "bouncer_asg_attachment_alb" {
  count                  = "${length(data.aws_autoscaling_groups.bouncer.names) > 0 ? 1 : 0}"
  autoscaling_group_name = "${element(data.aws_autoscaling_groups.bouncer.names, 0)}"
  alb_target_group_arn   = "${element(module.bouncer_public_lb.target_group_arns, 0)}"
}

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

module "cache_public_lb" {
  source                                     = "../../modules/aws/lb"
  name                                       = "${var.stackname}-cache-public"
  internal                                   = false
  vpc_id                                     = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  access_logs_bucket_name                    = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  access_logs_bucket_prefix                  = "elb/${var.stackname}-cache-public-elb"
  listener_certificate_domain_name           = "${var.elb_public_certname}"
  listener_secondary_certificate_domain_name = "${var.elb_public_secondary_certname}"
  listener_action                            = "${map("HTTPS:443", "HTTP:80")}"
  subnets                                    = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups                            = ["${data.terraform_remote_state.infra_security_groups.sg_cache_external_elb_id}"]
  alarm_actions                              = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  default_tags                               = "${map("Project", var.stackname, "aws_migration", "cache", "aws_environment", var.aws_environment)}"
}

resource "aws_wafregional_web_acl_association" "cache_public_web_acl" {
  resource_arn = "${module.cache_public_lb.lb_id}"
  web_acl_id   = "${aws_wafregional_web_acl.default.id}"
}

resource "aws_shield_protection" "cache_public_web_acl" {
  name         = "${var.stackname}-cache-public"
  resource_arn = "${module.cache_public_lb.lb_id}"
}

resource "aws_route53_record" "cache_public_service_names" {
  count   = "${length(var.cache_public_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.external_root_zone_id}"
  name    = "${element(var.cache_public_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.external_root_domain_name}"
  type    = "A"

  alias {
    name                   = "${module.cache_public_lb.lb_dns_name}"
    zone_id                = "${module.cache_public_lb.lb_zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cache_public_service_cnames" {
  count   = "${length(var.cache_public_service_cnames)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.external_root_zone_id}"
  name    = "${element(var.cache_public_service_cnames, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.external_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.cache_public_service_names, 0)}.${data.terraform_remote_state.infra_root_dns_zones.external_root_domain_name}"]
  ttl     = "300"
}

module "cache_public_lb_rules" {
  source                 = "../../modules/aws/lb_listener_rules"
  name                   = "cache"
  autoscaling_group_name = "${data.aws_autoscaling_group.cache.name}"
  rules_host_domain      = "*"
  vpc_id                 = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  listener_arn           = "${module.cache_public_lb.load_balancer_ssl_listeners[0]}"
  rules_host             = ["${compact(split(",", var.enable_lb_app_healthchecks ? join(",", var.cache_public_service_cnames) : ""))}"]
  default_tags           = "${map("Project", var.stackname, "aws_migration", "cache", "aws_environment", var.aws_environment)}"
}

data "aws_autoscaling_group" "cache" {
  name = "${var.app_stackname}-cache"
}

resource "aws_autoscaling_attachment" "cache_asg_attachment_alb" {
  count                  = "${data.aws_autoscaling_group.cache.name != "" ? 1 : 0}"
  autoscaling_group_name = "${data.aws_autoscaling_group.cache.name}"
  alb_target_group_arn   = "${element(module.cache_public_lb.target_group_arns, 0)}"
}

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

#
# Calendars
#

module "calendars_public_lb" {
  source                                     = "../../modules/aws/lb"
  name                                       = "${var.stackname}-calendars-public"
  internal                                   = false
  vpc_id                                     = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  access_logs_bucket_name                    = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  access_logs_bucket_prefix                  = "elb/${var.stackname}-calendars-public-elb"
  listener_certificate_domain_name           = "${var.elb_public_certname}"
  listener_secondary_certificate_domain_name = "${var.elb_public_secondary_certname}"

  listener_action = {
    "HTTPS:443" = "HTTP:80"
  }

  target_group_health_check_path = "/_healthcheck"
  subnets                        = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups                = ["${data.terraform_remote_state.infra_security_groups.sg_calendars_carrenza_alb_id}"]
  alarm_actions                  = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  default_tags                   = "${map("Project", var.stackname, "aws_migration", "calendars", "aws_environment", var.aws_environment)}"
}

resource "aws_route53_record" "calendars_public_service_names" {
  count   = "${length(var.calendars_public_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.external_root_zone_id}"
  name    = "${element(var.calendars_public_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.external_root_domain_name}"
  type    = "A"

  alias {
    name                   = "${module.calendars_public_lb.lb_dns_name}"
    zone_id                = "${module.calendars_public_lb.lb_zone_id}"
    evaluate_target_health = true
  }
}

data "aws_autoscaling_groups" "calendars" {
  filter {
    name   = "key"
    values = ["Name"]
  }

  filter {
    name   = "value"
    values = ["blue-calculators-frontend"]
  }
}

resource "aws_autoscaling_attachment" "calendars_asg_attachment_alb" {
  count                  = "${length(data.aws_autoscaling_groups.calendars.names) > 0 ? 1 : 0}"
  autoscaling_group_name = "${element(data.aws_autoscaling_groups.calendars.names, 0)}"
  alb_target_group_arn   = "${element(module.calendars_public_lb.target_group_arns, 0)}"
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

#
# CKAN
#

module "ckan_public_lb" {
  source                                     = "../../modules/aws/lb"
  name                                       = "${var.stackname}-ckan-public"
  internal                                   = false
  vpc_id                                     = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  access_logs_bucket_name                    = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  access_logs_bucket_prefix                  = "elb/${var.stackname}-ckan-public-elb"
  listener_certificate_domain_name           = "${var.elb_public_certname}"
  listener_secondary_certificate_domain_name = "${var.elb_public_secondary_certname}"
  listener_action                            = "${map("HTTPS:443", "HTTP:80")}"
  subnets                                    = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups                            = ["${data.terraform_remote_state.infra_security_groups.sg_ckan_elb_external_id}"]
  alarm_actions                              = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  default_tags                               = "${map("Project", var.stackname, "aws_migration", "ckan", "aws_environment", var.aws_environment)}"
}

resource "aws_route53_record" "ckan_public_service_names" {
  count   = "${length(var.ckan_public_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.external_root_zone_id}"
  name    = "${element(var.ckan_public_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.external_root_domain_name}"
  type    = "A"

  alias {
    name                   = "${module.ckan_public_lb.lb_dns_name}"
    zone_id                = "${module.ckan_public_lb.lb_zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "ckan_public_service_cnames" {
  count   = "${length(var.ckan_public_service_cnames)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.external_root_zone_id}"
  name    = "${element(var.ckan_public_service_cnames, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.external_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.ckan_public_service_names, 0)}.${data.terraform_remote_state.infra_root_dns_zones.external_root_domain_name}"]
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
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.ckan_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.ckan_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

resource "aws_route53_record" "ckan_internal_service_cnames" {
  count   = "${length(var.ckan_internal_service_cnames)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.ckan_internal_service_cnames, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.ckan_internal_service_names, 0)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

#
# Content Data API: DB Admin
#

resource "aws_route53_record" "content_data_api_db_admin_internal_service_names" {
  count   = "${length(var.content_data_api_db_admin_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.content_data_api_db_admin_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.content_data_api_db_admin_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

#
# Content Data API: Postgresql
#

resource "aws_route53_record" "content_data_api_postgresql_internal_service_names" {
  count   = "${length(var.content_data_api_postgresql_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.content_data_api_postgresql_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.content_data_api_postgresql_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

# Content-store

module "content-store_public_lb" {
  source                                     = "../../modules/aws/lb"
  name                                       = "${var.stackname}-content-store-public"
  internal                                   = false
  vpc_id                                     = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  access_logs_bucket_name                    = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  access_logs_bucket_prefix                  = "elb/${var.stackname}-content-store-public-elb"
  listener_certificate_domain_name           = "${var.elb_public_certname}"
  listener_secondary_certificate_domain_name = "${var.elb_public_secondary_certname}"

  listener_action = {
    "HTTPS:443" = "HTTP:80"
  }

  target_group_health_check_path = "/_healthcheck"
  subnets                        = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups                = ["${data.terraform_remote_state.infra_security_groups.sg_content-store_external_elb_id}"]
  alarm_actions                  = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  default_tags                   = "${map("Project", var.stackname, "aws_migration", "content-store", "aws_environment", var.aws_environment)}"
}

resource "aws_route53_record" "content-store_public_service_names" {
  count   = "${length(var.content_store_public_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.external_root_zone_id}"
  name    = "${element(var.content_store_public_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.external_root_domain_name}"
  type    = "A"

  alias {
    name                   = "${module.content-store_public_lb.lb_dns_name}"
    zone_id                = "${module.content-store_public_lb.lb_zone_id}"
    evaluate_target_health = true
  }
}

data "aws_autoscaling_groups" "content-store" {
  filter {
    name   = "key"
    values = ["Name"]
  }

  filter {
    name   = "value"
    values = ["blue-content-store"]
  }
}

resource "aws_autoscaling_attachment" "content-store_asg_attachment_alb" {
  count                  = "${length(data.aws_autoscaling_groups.content-store.names) > 0 ? 1 : 0}"
  autoscaling_group_name = "${element(data.aws_autoscaling_groups.content-store.names, 0)}"
  alb_target_group_arn   = "${element(module.content-store_public_lb.target_group_arns, 0)}"
}

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

module "deploy_public_lb" {
  source                                     = "../../modules/aws/lb"
  name                                       = "${var.stackname}-deploy-public"
  internal                                   = false
  vpc_id                                     = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  access_logs_bucket_name                    = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  access_logs_bucket_prefix                  = "elb/${var.stackname}-deploy-public-elb"
  listener_certificate_domain_name           = "${var.elb_public_certname}"
  listener_secondary_certificate_domain_name = "${var.elb_public_secondary_certname}"
  listener_action                            = "${map("HTTPS:443", "HTTP:80")}"
  subnets                                    = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups                            = ["${data.terraform_remote_state.infra_security_groups.sg_deploy_elb_id}"]
  alarm_actions                              = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  default_tags                               = "${map("Project", var.stackname, "aws_migration", "deploy", "aws_environment", var.aws_environment)}"
}

resource "aws_route53_record" "deploy_public_service_names" {
  count   = "${length(var.deploy_public_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.external_root_zone_id}"
  name    = "${element(var.deploy_public_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.external_root_domain_name}"
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
module "draft_cache_public_lb" {
  source                                     = "../../modules/aws/lb"
  name                                       = "${var.stackname}-draft-cache-public"
  internal                                   = false
  vpc_id                                     = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  access_logs_bucket_name                    = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  access_logs_bucket_prefix                  = "elb/${var.stackname}-draft-cache-public-elb"
  listener_certificate_domain_name           = "${var.elb_public_certname}"
  listener_secondary_certificate_domain_name = "${var.elb_public_secondary_certname}"
  listener_action                            = "${map("HTTPS:443", "HTTP:80")}"
  subnets                                    = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups                            = ["${data.terraform_remote_state.infra_security_groups.sg_draft-cache_external_elb_id}"]
  alarm_actions                              = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  default_tags                               = "${map("Project", var.stackname, "aws_migration", "draft_cache", "aws_environment", var.aws_environment)}"
}

resource "aws_route53_record" "draft_cache_public_service_names" {
  count   = "${length(var.draft_cache_public_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.external_root_zone_id}"
  name    = "${element(var.draft_cache_public_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.external_root_domain_name}"
  type    = "A"

  alias {
    name                   = "${module.draft_cache_public_lb.lb_dns_name}"
    zone_id                = "${module.draft_cache_public_lb.lb_zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "draft_cache_public_service_cnames" {
  count   = "${length(var.draft_cache_public_service_cnames)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.external_root_zone_id}"
  name    = "${element(var.draft_cache_public_service_cnames, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.external_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.draft_cache_public_service_names, 0)}.${data.terraform_remote_state.infra_root_dns_zones.external_root_domain_name}"]
  ttl     = "300"
}

data "aws_autoscaling_groups" "draft_cache" {
  filter {
    name   = "key"
    values = ["Name"]
  }

  filter {
    name   = "value"
    values = ["blue-draft-cache"]
  }
}

resource "aws_autoscaling_attachment" "draft_cache_asg_attachment_alb" {
  count                  = "${length(data.aws_autoscaling_groups.draft_cache.names) > 0 ? 1 : 0}"
  autoscaling_group_name = "${element(data.aws_autoscaling_groups.draft_cache.names, 0)}"
  alb_target_group_arn   = "${element(module.draft_cache_public_lb.target_group_arns, 0)}"
}

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
# elasticsearch6
#

resource "aws_route53_record" "elasticsearch6_internal_service_names" {
  count   = "${length(var.elasticsearch6_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.elasticsearch6_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.elasticsearch6_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

#
# email_alert_api
#

module "email_alert_api_public_lb" {
  source                                     = "../../modules/aws/lb"
  name                                       = "${var.stackname}-email-alert-api-public"
  internal                                   = false
  vpc_id                                     = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  access_logs_bucket_name                    = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  access_logs_bucket_prefix                  = "elb/${var.stackname}-email-alert-api-public-elb"
  listener_certificate_domain_name           = "${var.elb_public_certname}"
  listener_secondary_certificate_domain_name = "${var.elb_public_secondary_certname}"
  listener_action                            = "${map("HTTPS:443", "HTTP:80")}"
  target_group_health_check_path             = "/_healthcheck_email-alert-api"
  subnets                                    = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups                            = ["${data.terraform_remote_state.infra_security_groups.sg_email-alert-api_elb_external_id}"]
  alarm_actions                              = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  default_tags                               = "${map("Project", var.stackname, "aws_migration", "email_alert_api", "aws_environment", var.aws_environment)}"
}

resource "aws_route53_record" "email_alert_api_public_service_names" {
  count   = "${length(var.email_alert_api_public_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.external_root_zone_id}"
  name    = "${element(var.email_alert_api_public_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.external_root_domain_name}"
  type    = "A"

  alias {
    name                   = "${module.email_alert_api_public_lb.lb_dns_name}"
    zone_id                = "${module.email_alert_api_public_lb.lb_zone_id}"
    evaluate_target_health = true
  }
}

data "aws_autoscaling_groups" "email_alert_api" {
  filter {
    name   = "key"
    values = ["Name"]
  }

  filter {
    name   = "value"
    values = ["blue-email-alert-api"]
  }
}

resource "aws_autoscaling_attachment" "email_alert_api_asg_attachment_alb" {
  count                  = "${length(data.aws_autoscaling_groups.email_alert_api.names) > 0 ? 1 : 0}"
  autoscaling_group_name = "${element(data.aws_autoscaling_groups.email_alert_api.names, 0)}"
  alb_target_group_arn   = "${element(module.email_alert_api_public_lb.target_group_arns, 0)}"
}

resource "aws_route53_record" "email_alert_api_internal_service_names" {
  count   = "${length(var.email_alert_api_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.email_alert_api_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.email_alert_api_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

#
# feedback
#

module "feedback_public_lb" {
  source                                     = "../../modules/aws/lb"
  name                                       = "${var.stackname}-feedback-public"
  internal                                   = true
  vpc_id                                     = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  access_logs_bucket_name                    = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  access_logs_bucket_prefix                  = "elb/${var.stackname}-feedback-public-elb"
  listener_certificate_domain_name           = "${var.elb_public_certname}"
  listener_secondary_certificate_domain_name = "${var.elb_public_secondary_certname}"

  listener_action = {
    "HTTPS:443" = "HTTP:80"
  }

  target_group_health_check_path = "/healthcheck"
  subnets                        = ["${data.terraform_remote_state.infra_networking.private_subnet_ids}"]
  security_groups                = ["${data.terraform_remote_state.infra_security_groups.sg_feedback_elb_id}"]
  alarm_actions                  = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  default_tags                   = "${map("Project", var.stackname, "aws_migration", "feedback", "aws_environment", var.aws_environment)}"
}

resource "aws_route53_record" "feedback_public_service_names" {
  count   = "${length(var.feedback_public_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.external_root_zone_id}"
  name    = "${element(var.feedback_public_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.external_root_domain_name}"
  type    = "A"

  alias {
    name                   = "${module.feedback_public_lb.lb_dns_name}"
    zone_id                = "${module.feedback_public_lb.lb_zone_id}"
    evaluate_target_health = true
  }
}

data "aws_autoscaling_groups" "frontend" {
  filter {
    name   = "key"
    values = ["Name"]
  }

  filter {
    name   = "value"
    values = ["blue-frontend"]
  }
}

resource "aws_autoscaling_attachment" "frontend_asg_attachment_alb" {
  count                  = "${length(data.aws_autoscaling_groups.frontend.names) > 0 ? 1 : 0}"
  autoscaling_group_name = "${element(data.aws_autoscaling_groups.frontend.names, 0)}"
  alb_target_group_arn   = "${element(module.feedback_public_lb.target_group_arns, 0)}"
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

module "graphite_public_lb" {
  source                                     = "../../modules/aws/lb"
  name                                       = "${var.stackname}-graphite-public"
  internal                                   = false
  vpc_id                                     = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  access_logs_bucket_name                    = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  access_logs_bucket_prefix                  = "elb/${var.stackname}-graphite-public-elb"
  listener_certificate_domain_name           = "${var.elb_public_certname}"
  listener_secondary_certificate_domain_name = "${var.elb_public_secondary_certname}"
  listener_action                            = "${map("HTTPS:443", "HTTP:80")}"
  subnets                                    = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups                            = ["${data.terraform_remote_state.infra_security_groups.sg_graphite_external_elb_id}"]
  alarm_actions                              = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
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
  vpc_id                                     = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  access_logs_bucket_name                    = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  access_logs_bucket_prefix                  = "elb/${var.stackname}-prometheus-public-elb"
  listener_certificate_domain_name           = "${var.elb_public_certname}"
  listener_secondary_certificate_domain_name = "${var.elb_public_secondary_certname}"
  listener_action                            = "${map("HTTPS:443", "HTTP:80")}"
  subnets                                    = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups                            = ["${data.terraform_remote_state.infra_security_groups.sg_prometheus_external_elb_id}"]
  alarm_actions                              = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  default_tags                               = "${map("Project", var.stackname, "aws_migration", "prometheus", "aws_environment", var.aws_environment)}"
  target_group_health_check_path             = "/metrics"
}

resource "aws_route53_record" "prometheus_public_service_names" {
  count   = "${length(var.prometheus_public_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.external_root_zone_id}"
  name    = "${element(var.prometheus_public_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.external_root_domain_name}"
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
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.prometheus_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.prometheus_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

#
# Graphite
#

resource "aws_route53_record" "graphite_public_service_names" {
  count   = "${length(var.graphite_public_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.external_root_zone_id}"
  name    = "${element(var.graphite_public_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.external_root_domain_name}"
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
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.graphite_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.graphite_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

#
# Jumpbox
#

resource "aws_elb" "jumpbox_public_elb" {
  name            = "${var.stackname}-jumpbox"
  subnets         = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_offsite_ssh_id}"]
  internal        = "false"

  access_logs {
    bucket        = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
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
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.external_root_zone_id}"
  name    = "${element(var.jumpbox_public_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.external_root_domain_name}"
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
  alarm_actions                  = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
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

module "licensify_frontend_public_lb" {
  source                                     = "../../modules/aws/lb"
  name                                       = "${var.stackname}-licensify-frontend-public"
  internal                                   = false
  vpc_id                                     = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  access_logs_bucket_name                    = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  access_logs_bucket_prefix                  = "elb/${var.stackname}-licensify-frontend-public-elb"
  listener_certificate_domain_name           = "${var.elb_public_certname}"
  listener_secondary_certificate_domain_name = "${var.elb_public_secondary_certname}"
  target_group_health_check_path             = "/api/licences"

  listener_action = {
    "HTTPS:443" = "HTTP:80"
  }

  subnets         = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_licensify-frontend_external_elb_id}"]
  alarm_actions   = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]

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

resource "aws_wafregional_web_acl_association" "licensify_frontend_public_lb" {
  resource_arn = "${module.licensify_frontend_public_lb.lb_id}"
  web_acl_id   = "${aws_wafregional_web_acl.default.id}"
}

resource "aws_route53_record" "licensify_frontend_public_service_names" {
  count   = "${length(var.licensify_frontend_public_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.external_root_zone_id}"
  name    = "${element(var.licensify_frontend_public_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.external_root_domain_name}"
  type    = "A"

  alias {
    name                   = "${module.licensify_frontend_public_lb.lb_dns_name}"
    zone_id                = "${module.licensify_frontend_public_lb.lb_zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "licensify_frontend_public_service_cnames" {
  count   = "${length(var.licensify_frontend_public_service_cnames)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.external_root_zone_id}"
  name    = "${element(var.licensify_frontend_public_service_cnames, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.external_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.licensify_frontend_public_service_names, 0)}.${data.terraform_remote_state.infra_root_dns_zones.external_root_domain_name}"]
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
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.licensify_frontend_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.licensify_frontend_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

resource "aws_route53_record" "licensify_frontend_internal_service_cnames" {
  count   = "${length(var.licensify_frontend_internal_service_cnames)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.licensify_frontend_internal_service_cnames, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.licensify_frontend_internal_service_names, 0)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

#
# Ubuntu Test
#

resource "aws_elb" "ubuntutest_public_elb" {
  name            = "${var.stackname}-ubuntutest"
  subnets         = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_offsite_ssh_id}"]
  internal        = "false"

  access_logs {
    bucket        = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    bucket_prefix = "elb/${var.stackname}-ubuntutest-public-elb"
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

  tags = "${map("Name", "${var.stackname}-ubuntutest", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "ubuntutest")}"
}

resource "aws_route53_record" "ubuntutest_public_service_names" {
  count   = "${length(var.ubuntutest_public_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.external_root_zone_id}"
  name    = "${element(var.ubuntutest_public_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.external_root_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.ubuntutest_public_elb.dns_name}"
    zone_id                = "${aws_elb.ubuntutest_public_elb.zone_id}"
    evaluate_target_health = true
  }
}

data "aws_autoscaling_groups" "ubuntutest" {
  filter {
    name   = "key"
    values = ["Name"]
  }

  filter {
    name   = "value"
    values = ["blue-ubuntutest"]
  }
}

resource "aws_autoscaling_attachment" "ubuntutest_asg_attachment_elb" {
  count                  = "${length(data.aws_autoscaling_groups.ubuntutest.names) > 0 ? 1 : 0}"
  autoscaling_group_name = "${element(data.aws_autoscaling_groups.ubuntutest.names, 0)}"
  elb                    = "${aws_elb.ubuntutest_public_elb.id}"
}

#
# Licensing (Licensify) backend
#

module "licensify_backend_public_lb" {
  source                                     = "../../modules/aws/lb"
  name                                       = "licensify-backend-public"
  internal                                   = false
  vpc_id                                     = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  access_logs_bucket_name                    = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  access_logs_bucket_prefix                  = "elb/licensify-backend-public-elb"
  listener_certificate_domain_name           = "${var.elb_public_certname}"
  listener_secondary_certificate_domain_name = "${var.elb_public_secondary_certname}"
  target_group_health_check_path             = "/healthcheck"

  listener_action = {
    "HTTPS:443" = "HTTP:80"
  }

  subnets         = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_licensify-backend_external_elb_id}"]
  alarm_actions   = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]

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

resource "aws_wafregional_web_acl_association" "licensify_backend_public_lb" {
  resource_arn = "${module.licensify_backend_public_lb.lb_id}"
  web_acl_id   = "${aws_wafregional_web_acl.default.id}"
}

resource "aws_route53_record" "licensify_backend_public_service_names" {
  count   = "${length(var.licensify_backend_public_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.external_root_zone_id}"
  name    = "${element(var.licensify_backend_public_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.external_root_domain_name}"
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
# Mapit
#

module "mapit_public_lb" {
  source                                     = "../../modules/aws/lb"
  name                                       = "${var.stackname}-mapit-public"
  internal                                   = false
  vpc_id                                     = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  access_logs_bucket_name                    = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  access_logs_bucket_prefix                  = "elb/${var.stackname}-mapit-public-elb"
  listener_certificate_domain_name           = "${var.elb_public_certname}"
  listener_secondary_certificate_domain_name = "${var.elb_public_secondary_certname}"

  listener_action = {
    "HTTPS:443" = "HTTP:80"
  }

  target_group_health_check_path = "/postcode/W54XA"
  subnets                        = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups                = ["${data.terraform_remote_state.infra_security_groups.sg_mapit_carrenza_alb_id}"]
  alarm_actions                  = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  default_tags                   = "${map("Project", var.stackname, "aws_migration", "mapit", "aws_environment", var.aws_environment)}"
}

data "aws_autoscaling_groups" "mapit-1" {
  filter {
    name   = "key"
    values = ["Name"]
  }

  filter {
    name   = "value"
    values = ["blue-mapit-1"]
  }
}

resource "aws_autoscaling_attachment" "mapit-1_asg_attachment_alb" {
  count                  = "${length(data.aws_autoscaling_groups.mapit-1.names) > 0 ? 1 : 0}"
  autoscaling_group_name = "${element(data.aws_autoscaling_groups.mapit-1.names, 0)}"
  alb_target_group_arn   = "${element(module.mapit_public_lb.target_group_arns, 0)}"
}

data "aws_autoscaling_groups" "mapit-2" {
  filter {
    name   = "key"
    values = ["Name"]
  }

  filter {
    name   = "value"
    values = ["blue-mapit-2"]
  }
}

resource "aws_autoscaling_attachment" "mapit-2_asg_attachment_alb" {
  count                  = "${length(data.aws_autoscaling_groups.mapit-2.names) > 0 ? 1 : 0}"
  autoscaling_group_name = "${element(data.aws_autoscaling_groups.mapit-2.names, 0)}"
  alb_target_group_arn   = "${element(module.mapit_public_lb.target_group_arns, 0)}"
}

resource "aws_route53_record" "mapit_internal_service_names" {
  count   = "${length(var.mapit_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.mapit_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.mapit_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

resource "aws_route53_record" "mapit_public_service_names" {
  count   = "${length(var.mapit_public_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.external_root_zone_id}"
  name    = "${element(var.mapit_public_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.external_root_domain_name}"
  type    = "A"

  alias {
    name                   = "${module.mapit_public_lb.lb_dns_name}"
    zone_id                = "${module.mapit_public_lb.lb_zone_id}"
    evaluate_target_health = true
  }
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

module "monitoring_public_lb" {
  source                                     = "../../modules/aws/lb"
  name                                       = "${var.stackname}-monitoring-public"
  internal                                   = false
  vpc_id                                     = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  access_logs_bucket_name                    = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  access_logs_bucket_prefix                  = "elb/${var.stackname}-monitoring-public-elb"
  listener_certificate_domain_name           = "${var.elb_public_certname}"
  listener_secondary_certificate_domain_name = "${var.elb_public_secondary_certname}"
  listener_action                            = "${map("HTTPS:443", "HTTP:80")}"
  subnets                                    = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups                            = ["${data.terraform_remote_state.infra_security_groups.sg_monitoring_external_elb_id}"]
  alarm_actions                              = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  default_tags                               = "${map("Project", var.stackname, "aws_migration", "monitoring", "aws_environment", var.aws_environment)}"
}

resource "aws_route53_record" "monitoring_public_service_names" {
  count   = "${length(var.monitoring_public_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.external_root_zone_id}"
  name    = "${element(var.monitoring_public_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.external_root_domain_name}"
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
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.monitoring_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${var.monitoring_internal_service_names_cname_dest}.blue.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
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
# search-api
#

module "search_api_public_lb" {
  source                                     = "../../modules/aws/lb"
  name                                       = "${var.stackname}-search-api-public"
  internal                                   = false
  vpc_id                                     = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  access_logs_bucket_name                    = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  access_logs_bucket_prefix                  = "elb/${var.stackname}-search-api-public-elb"
  listener_certificate_domain_name           = "${var.elb_public_certname}"
  listener_secondary_certificate_domain_name = "${var.elb_public_secondary_certname}"

  listener_action = {
    "HTTPS:443" = "HTTP:80"
  }

  target_group_health_check_path = "/_healthcheck"
  subnets                        = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups                = ["${data.terraform_remote_state.infra_security_groups.sg_search-api_external_elb_id}"]
  alarm_actions                  = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  default_tags                   = "${map("Project", var.stackname, "aws_migration", "search-api", "aws_environment", var.aws_environment)}"
}

resource "aws_route53_record" "search_api_public_service_names" {
  count   = "${length(var.search_api_public_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.external_root_zone_id}"
  name    = "${element(var.search_api_public_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.external_root_domain_name}"
  type    = "A"

  alias {
    name                   = "${module.search_api_public_lb.lb_dns_name}"
    zone_id                = "${module.search_api_public_lb.lb_zone_id}"
    evaluate_target_health = true
  }
}

module "search_api_public_lb_rules" {
  source                 = "../../modules/aws/lb_listener_rules"
  name                   = "search-api"
  autoscaling_group_name = "${data.aws_autoscaling_groups.search.names[0]}"
  rules_host_domain      = "${var.aws_environment}.*"
  vpc_id                 = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  listener_arn           = "${module.search_api_public_lb.load_balancer_ssl_listeners[0]}"
  rules_host             = ["${compact(split(",", var.enable_lb_app_healthchecks ? join(",", var.search_api_public_service_names) : ""))}"]
  priority_offset        = "1"
  default_tags           = "${map("Project", var.stackname, "aws_migration", "search-api", "aws_environment", var.aws_environment)}"
}

resource "aws_autoscaling_attachment" "search_api_backend_asg_attachment_alb" {
  count                  = "${length(data.aws_autoscaling_groups.search.names) > 0 ? 1 : 0}"
  autoscaling_group_name = "${element(data.aws_autoscaling_groups.search.names, 0)}"
  alb_target_group_arn   = "${element(module.search_api_public_lb.target_group_arns, 0)}"
}

#
# Static
#

module "static_public_lb" {
  source                                     = "../../modules/aws/lb"
  name                                       = "${var.stackname}-static-public"
  internal                                   = false
  vpc_id                                     = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  access_logs_bucket_name                    = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  access_logs_bucket_prefix                  = "elb/${var.stackname}-static-public-elb"
  listener_certificate_domain_name           = "${var.elb_public_certname}"
  listener_secondary_certificate_domain_name = "${var.elb_public_secondary_certname}"

  listener_action = {
    "HTTPS:443" = "HTTP:80"
  }

  target_group_health_check_path = "/_healthcheck"
  subnets                        = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups                = ["${data.terraform_remote_state.infra_security_groups.sg_static_carrenza_alb_id}"]
  alarm_actions                  = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  default_tags                   = "${map("Project", var.stackname, "aws_migration", "static", "aws_environment", var.aws_environment)}"
}

resource "aws_route53_record" "static_public_service_names" {
  count   = "${length(var.static_public_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.external_root_zone_id}"
  name    = "${element(var.static_public_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.external_root_domain_name}"
  type    = "A"

  alias {
    name                   = "${module.static_public_lb.lb_dns_name}"
    zone_id                = "${module.static_public_lb.lb_zone_id}"
    evaluate_target_health = true
  }
}

data "aws_autoscaling_groups" "static" {
  filter {
    name   = "key"
    values = ["Name"]
  }

  filter {
    name   = "value"
    values = ["blue-frontend"]
  }
}

resource "aws_autoscaling_attachment" "static_asg_attachment_alb" {
  count                  = "${length(data.aws_autoscaling_groups.static.names) > 0 ? 1 : 0}"
  autoscaling_group_name = "${element(data.aws_autoscaling_groups.static.names, 0)}"
  alb_target_group_arn   = "${element(module.static_public_lb.target_group_arns, 0)}"
}

# support-api

module "support_api_public_lb" {
  source                                     = "../../modules/aws/lb"
  name                                       = "${var.stackname}-support-api-public"
  internal                                   = false
  vpc_id                                     = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  access_logs_bucket_name                    = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  access_logs_bucket_prefix                  = "elb/${var.stackname}-support-api-public-elb"
  listener_certificate_domain_name           = "${var.elb_public_certname}"
  listener_secondary_certificate_domain_name = "${var.elb_public_secondary_certname}"

  listener_action = {
    "HTTPS:443" = "HTTP:80"
  }

  target_group_health_check_path = "/_healthcheck"
  subnets                        = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups                = ["${data.terraform_remote_state.infra_security_groups.sg_support-api_external_elb_id}"]
  alarm_actions                  = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  default_tags                   = "${map("Project", var.stackname, "aws_migration", "support-api", "aws_environment", var.aws_environment)}"
}

resource "aws_route53_record" "support_api_public_service_names" {
  count   = "${length(var.support_api_public_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.external_root_zone_id}"
  name    = "${element(var.support_api_public_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.external_root_domain_name}"
  type    = "A"

  alias {
    name                   = "${module.support_api_public_lb.lb_dns_name}"
    zone_id                = "${module.support_api_public_lb.lb_zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_autoscaling_attachment" "support_api_backend_asg_attachment_alb" {
  count                  = "${data.aws_autoscaling_group.backend.name != "" ? 1 : 0}"
  autoscaling_group_name = "${data.aws_autoscaling_group.backend.name}"
  alb_target_group_arn   = "${element(module.support_api_public_lb.target_group_arns, 0)}"
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

module "whitehall_backend_public_lb" {
  source                                     = "../../modules/aws/lb"
  name                                       = "${var.stackname}-whitehall-public"
  internal                                   = false
  vpc_id                                     = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  access_logs_bucket_name                    = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  access_logs_bucket_prefix                  = "elb/${var.stackname}-whitehall-backend-public-elb"
  listener_certificate_domain_name           = "${var.elb_public_certname}"
  listener_secondary_certificate_domain_name = "${var.elb_public_secondary_certname}"

  listener_action = {
    "HTTPS:443" = "HTTP:80"
  }

  target_group_health_check_path = "/_healthcheck_whitehall-admin"
  subnets                        = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups                = ["${data.terraform_remote_state.infra_security_groups.sg_whitehall-backend_external_elb_id}"]
  alarm_actions                  = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]

  default_tags = {
    Project         = "${var.stackname}"
    aws_migration   = "whitehall_backend"
    aws_environment = "${var.aws_environment}"
  }
}

resource "aws_wafregional_web_acl_association" "whitehall_backend_public_lb" {
  resource_arn = "${module.whitehall_backend_public_lb.lb_id}"
  web_acl_id   = "${aws_wafregional_web_acl.default.id}"
}

resource "aws_route53_record" "whitehall_backend_public_service_names" {
  count   = "${length(var.whitehall_backend_public_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.external_root_zone_id}"
  name    = "${element(var.whitehall_backend_public_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.external_root_domain_name}"
  type    = "A"

  alias {
    name                   = "${module.whitehall_backend_public_lb.lb_dns_name}"
    zone_id                = "${module.whitehall_backend_public_lb.lb_zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "whitehall_backend_public_service_cnames" {
  count   = "${length(var.whitehall_backend_public_service_cnames)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.external_root_zone_id}"
  name    = "${element(var.whitehall_backend_public_service_cnames, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.external_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.whitehall_backend_public_service_names, 0)}.${data.terraform_remote_state.infra_root_dns_zones.external_root_domain_name}"]
  ttl     = "300"
}

data "aws_autoscaling_groups" "whitehall_backend" {
  filter {
    name   = "key"
    values = ["Name"]
  }

  filter {
    name   = "value"
    values = ["blue-whitehall-backend"]
  }
}

resource "aws_autoscaling_attachment" "whitehall_backend_asg_attachment_alb" {
  count                  = "${length(data.aws_autoscaling_groups.whitehall_backend.names) > 0 ? 1 : 0}"
  autoscaling_group_name = "${element(data.aws_autoscaling_groups.whitehall_backend.names, 0)}"
  alb_target_group_arn   = "${element(module.whitehall_backend_public_lb.target_group_arns, 0)}"
}

#
# whitehall_frontend
#

# draft_whitehall internal names are actually alias for whitehall internal names
resource "aws_route53_record" "draft_whitehall_frontend_internal_service_names" {
  count   = "${length(var.draft_whitehall_frontend_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.draft_whitehall_frontend_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.whitehall_frontend_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

resource "aws_route53_record" "whitehall_frontend_internal_service_names" {
  count   = "${length(var.whitehall_frontend_internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.whitehall_frontend_internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.whitehall_frontend_internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

resource "aws_route53_record" "draft_content_store_public_service_names" {
  count   = "${length(var.draft_content_store_public_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.external_root_zone_id}"
  name    = "${element(var.draft_content_store_public_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.external_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.draft_content_store_public_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.external_root_domain_name}"]
  ttl     = "300"
}
