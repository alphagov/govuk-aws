/**
* ## Project: infra-public-services
*
* This project adds public facing LBs and DNS entries
* for the app components of the infrastructure
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

variable "remote_state_infra_root_dns_zones_key_stack" {
  type        = "string"
  description = "Override stackname path to infra_root_dns_zones remote state "
  default     = ""
}

variable "elb_public_certname" {
  type        = "string"
  description = "The ACM cert domain name to find the ARN of"
}

variable "apt_public_service_names" {
  type        = "list"
  description = "List of application service names that get traffic via this loadbalancer"
  default     = []
}

variable "apt_public_service_cnames" {
  type        = "list"
  description = "List of application service names that get traffic via this loadbalancer"
  default     = []
}

variable "backend_public_service_names" {
  type        = "list"
  description = "List of application service names that get traffic via this loadbalancer"
  default     = []
}

variable "backend_public_service_cnames" {
  type        = "list"
  description = "List of application service names that get traffic via this loadbalancer"
  default     = []
}

variable "bouncer_public_service_names" {
  type        = "list"
  description = "List of application service names that get traffic via this loadbalancer"
  default     = []
}

variable "cache_public_service_names" {
  type        = "list"
  description = "List of application service names that get traffic via this loadbalancer"
  default     = []
}

variable "cache_public_service_cnames" {
  type        = "list"
  description = "List of application service names that get traffic via this loadbalancer"
  default     = []
}

variable "content_store_public_service_names" {
  type        = "list"
  description = "List of application service names that get traffic via this loadbalancer"
  default     = []
}

variable "deploy_public_service_names" {
  type        = "list"
  description = "List of application service names that get traffic via this loadbalancer"
  default     = []
}

variable "draft_content_store_public_service_names" {
  type        = "list"
  description = "List of application service names that get traffic via this loadbalancer"
  default     = []
}

variable "graphite_public_service_names" {
  type        = "list"
  description = "List of application service names that get traffic via this loadbalancer"
  default     = []
}

variable "jumpbox_public_service_names" {
  type        = "list"
  description = "List of application service names that get traffic via this loadbalancer"
  default     = []
}

variable "logs_cdn_public_service_names" {
  type        = "list"
  description = "List of application service names that get traffic via this loadbalancer"
  default     = []
}

variable "monitoring_public_service_names" {
  type        = "list"
  description = "List of application service names that get traffic via this loadbalancer"
  default     = []
}

variable "publishing_api_public_service_names" {
  type        = "list"
  description = "List of application service names that get traffic via this loadbalancer"
  default     = []
}

variable "whitehall_backend_public_service_names" {
  type        = "list"
  description = "List of application service names that get traffic via this loadbalancer"
  default     = []
}

variable "whitehall_backend_public_service_cnames" {
  type        = "list"
  description = "List of application service names that get traffic via this loadbalancer"
  default     = []
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

data "terraform_remote_state" "infra_root_dns_zones" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket}"
    key    = "${coalesce(var.remote_state_infra_root_dns_zones_key_stack, var.stackname)}/infra-root-dns-zones.tfstate"
    region = "eu-west-1"
  }
}

#
# Apt: TODO
#

#
# Backend
#

module "backend_public_lb" {
  source                           = "../../modules/aws/lb"
  name                             = "${var.stackname}-backend-public"
  internal                         = false
  vpc_id                           = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  access_logs_bucket_name          = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  access_logs_bucket_prefix        = "elb/${var.stackname}-backend-public-elb"
  listener_certificate_domain_name = "${var.elb_public_certname}"
  listener_action                  = "${map("HTTPS:443", "HTTP:80")}"
  subnets                          = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups                  = ["${data.terraform_remote_state.infra_security_groups.sg_backend_elb_external_id}"]
  alarm_actions                    = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  default_tags                     = "${map("Project", var.stackname, "aws_migration", "backend", "aws_environment", var.aws_environment)}"
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

data "aws_autoscaling_groups" "backend" {
  filter {
    name   = "key"
    values = ["Name"]
  }

  filter {
    name   = "value"
    values = ["blue-backend"]
  }
}

resource "aws_autoscaling_attachment" "backend_asg_attachment_alb" {
  autoscaling_group_name = "${element(data.aws_autoscaling_groups.backend.names, 0)}"
  alb_target_group_arn   = "${element(module.backend_public_lb.target_group_arns, 0)}"
}

#
# Bouncer
#

module "bouncer_public_lb" {
  source                           = "../../modules/aws/lb"
  name                             = "${var.stackname}-bouncer-public"
  internal                         = false
  vpc_id                           = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  access_logs_bucket_name          = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  access_logs_bucket_prefix        = "elb/${var.stackname}-bouncer-public-elb"
  listener_certificate_domain_name = "${var.elb_public_certname}"
  listener_action                  = "${map("HTTPS:443", "HTTP:80")}"
  subnets                          = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups                  = ["${data.terraform_remote_state.infra_security_groups.sg_bouncer_elb_id}"]
  alarm_actions                    = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  default_tags                     = "${map("Project", var.stackname, "aws_migration", "bouncer", "aws_environment", var.aws_environment)}"
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
  autoscaling_group_name = "${element(data.aws_autoscaling_groups.bouncer.names, 0)}"
  alb_target_group_arn   = "${element(module.bouncer_public_lb.target_group_arns, 0)}"
}

#
# Cache
#

module "cache_public_lb" {
  source                           = "../../modules/aws/lb"
  name                             = "${var.stackname}-cache-public"
  internal                         = false
  vpc_id                           = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  access_logs_bucket_name          = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  access_logs_bucket_prefix        = "elb/${var.stackname}-cache-public-elb"
  listener_certificate_domain_name = "${var.elb_public_certname}"
  listener_action                  = "${map("HTTPS:443", "HTTP:80")}"
  subnets                          = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups                  = ["${data.terraform_remote_state.infra_security_groups.sg_cache_external_elb_id}"]
  alarm_actions                    = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  default_tags                     = "${map("Project", var.stackname, "aws_migration", "cache", "aws_environment", var.aws_environment)}"
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

data "aws_autoscaling_groups" "cache" {
  filter {
    name   = "key"
    values = ["Name"]
  }

  filter {
    name   = "value"
    values = ["blue-cache"]
  }
}

resource "aws_autoscaling_attachment" "cache_asg_attachment_alb" {
  autoscaling_group_name = "${element(data.aws_autoscaling_groups.cache.names, 0)}"
  alb_target_group_arn   = "${element(module.cache_public_lb.target_group_arns, 0)}"
}

#
# Content-store
#

module "content_store_public_lb" {
  source                           = "../../modules/aws/lb"
  name                             = "${var.stackname}-content-store-pub"
  internal                         = false
  vpc_id                           = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  access_logs_bucket_name          = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  access_logs_bucket_prefix        = "elb/${var.stackname}-content-store-public-elb"
  listener_certificate_domain_name = "${var.elb_public_certname}"
  listener_action                  = "${map("HTTPS:443", "HTTP:80")}"
  subnets                          = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups                  = ["${data.terraform_remote_state.infra_security_groups.sg_content-store_external_elb_id}"]
  alarm_actions                    = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  default_tags                     = "${map("Project", var.stackname, "aws_migration", "content-store", "aws_environment", var.aws_environment)}"
}

resource "aws_route53_record" "content_store_public_service_names" {
  count   = "${length(var.content_store_public_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.external_root_zone_id}"
  name    = "${element(var.content_store_public_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.external_root_domain_name}"
  type    = "A"

  alias {
    name                   = "${module.content_store_public_lb.lb_dns_name}"
    zone_id                = "${module.content_store_public_lb.lb_zone_id}"
    evaluate_target_health = true
  }
}

data "aws_autoscaling_groups" "content_store" {
  filter {
    name   = "key"
    values = ["Name"]
  }

  filter {
    name   = "value"
    values = ["blue-content-store"]
  }
}

resource "aws_autoscaling_attachment" "content_store_asg_attachment_alb" {
  autoscaling_group_name = "${element(data.aws_autoscaling_groups.content_store.names, 0)}"
  alb_target_group_arn   = "${element(module.content_store_public_lb.target_group_arns, 0)}"
}

# Deploy

module "deploy_public_lb" {
  source                           = "../../modules/aws/lb"
  name                             = "${var.stackname}-deploy-public"
  internal                         = false
  vpc_id                           = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  access_logs_bucket_name          = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  access_logs_bucket_prefix        = "elb/${var.stackname}-deploy-public-elb"
  listener_certificate_domain_name = "${var.elb_public_certname}"
  listener_action                  = "${map("HTTPS:443", "HTTP:80")}"
  subnets                          = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups                  = ["${data.terraform_remote_state.infra_security_groups.sg_deploy_elb_id}"]
  alarm_actions                    = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  default_tags                     = "${map("Project", var.stackname, "aws_migration", "deploy", "aws_environment", var.aws_environment)}"
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
    values = ["blue-deploy"]
  }
}

resource "aws_autoscaling_attachment" "deploy_asg_attachment_alb" {
  autoscaling_group_name = "${element(data.aws_autoscaling_groups.deploy.names, 0)}"
  alb_target_group_arn   = "${element(module.deploy_public_lb.target_group_arns, 0)}"
}

#
# Draft-cache ?????
#

#
# Draft-content-store
#

module "draft_content_store_public_lb" {
  source                           = "../../modules/aws/lb"
  name                             = "${var.stackname}-draft-content-pub"
  internal                         = false
  vpc_id                           = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  access_logs_bucket_name          = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  access_logs_bucket_prefix        = "elb/${var.stackname}-draft-content-store-public-elb"
  listener_certificate_domain_name = "${var.elb_public_certname}"
  listener_action                  = "${map("HTTPS:443", "HTTP:80")}"
  subnets                          = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups                  = ["${data.terraform_remote_state.infra_security_groups.sg_draft-content-store_external_elb_id}"]
  alarm_actions                    = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  default_tags                     = "${map("Project", var.stackname, "aws_migration", "draft-content-store", "aws_environment", var.aws_environment)}"
}

resource "aws_route53_record" "draft_content_store_public_service_names" {
  count   = "${length(var.draft_content_store_public_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.external_root_zone_id}"
  name    = "${element(var.draft_content_store_public_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.external_root_domain_name}"
  type    = "A"

  alias {
    name                   = "${module.draft_content_store_public_lb.lb_dns_name}"
    zone_id                = "${module.draft_content_store_public_lb.lb_zone_id}"
    evaluate_target_health = true
  }
}

data "aws_autoscaling_groups" "draft_content_store" {
  filter {
    name   = "key"
    values = ["Name"]
  }

  filter {
    name   = "value"
    values = ["blue-draft-content-store"]
  }
}

resource "aws_autoscaling_attachment" "draft_content_store_asg_attachment_alb" {
  autoscaling_group_name = "${element(data.aws_autoscaling_groups.draft_content_store.names, 0)}"
  alb_target_group_arn   = "${element(module.draft_content_store_public_lb.target_group_arns, 0)}"
}

#
# Graphite
#

module "graphite_public_lb" {
  source                           = "../../modules/aws/lb"
  name                             = "${var.stackname}-graphite-public"
  internal                         = false
  vpc_id                           = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  access_logs_bucket_name          = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  access_logs_bucket_prefix        = "elb/${var.stackname}-graphite-public-elb"
  listener_certificate_domain_name = "${var.elb_public_certname}"
  listener_action                  = "${map("HTTPS:443", "HTTP:80")}"
  subnets                          = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups                  = ["${data.terraform_remote_state.infra_security_groups.sg_graphite_external_elb_id}"]
  alarm_actions                    = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  default_tags                     = "${map("Project", var.stackname, "aws_migration", "graphite", "aws_environment", var.aws_environment)}"
}

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
    values = ["blue-graphite-1"]
  }
}

resource "aws_autoscaling_attachment" "graphite_asg_attachment_alb" {
  autoscaling_group_name = "${element(data.aws_autoscaling_groups.graphite.names, 0)}"
  alb_target_group_arn   = "${element(module.graphite_public_lb.target_group_arns, 0)}"
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
    values = ["blue-jumpbox"]
  }
}

resource "aws_autoscaling_attachment" "jumpbox_asg_attachment_elb" {
  autoscaling_group_name = "${element(data.aws_autoscaling_groups.jumpbox.names, 0)}"
  elb                    = "${aws_elb.jumpbox_public_elb.id}"
}

#
# Logs-cdn
#

module "logs_cdn_public_lb" {
  source                           = "../../modules/aws/lb"
  name                             = "${var.stackname}-logs-cdn-public"
  internal                         = false
  vpc_id                           = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  access_logs_bucket_name          = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  access_logs_bucket_prefix        = "elb/${var.stackname}-logs-cdn-public-elb"
  listener_certificate_domain_name = "${var.elb_public_certname}"
  listener_action                  = "${map("HTTPS:443", "HTTP:80")}"
  subnets                          = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups                  = ["${data.terraform_remote_state.infra_security_groups.sg_logs-cdn_elb_id}"]
  alarm_actions                    = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  default_tags                     = "${map("Project", var.stackname, "aws_migration", "logs-cdn", "aws_environment", var.aws_environment)}"
}

resource "aws_route53_record" "logs_cdn_public_service_names" {
  count   = "${length(var.logs_cdn_public_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.external_root_zone_id}"
  name    = "${element(var.logs_cdn_public_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.external_root_domain_name}"
  type    = "A"

  alias {
    name                   = "${module.logs_cdn_public_lb.lb_dns_name}"
    zone_id                = "${module.logs_cdn_public_lb.lb_zone_id}"
    evaluate_target_health = true
  }
}

data "aws_autoscaling_groups" "logs_cdn" {
  filter {
    name   = "key"
    values = ["Name"]
  }

  filter {
    name   = "value"
    values = ["blue-logs-cdn"]
  }
}

resource "aws_autoscaling_attachment" "logs_cdn_asg_attachment_alb" {
  autoscaling_group_name = "${element(data.aws_autoscaling_groups.logs_cdn.names, 0)}"
  alb_target_group_arn   = "${element(module.logs_cdn_public_lb.target_group_arns, 0)}"
}

#
# Monitoring
#

module "monitoring_public_lb" {
  source                           = "../../modules/aws/lb"
  name                             = "${var.stackname}-monitoring-public"
  internal                         = false
  vpc_id                           = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  access_logs_bucket_name          = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  access_logs_bucket_prefix        = "elb/${var.stackname}-monitoring-public-elb"
  listener_certificate_domain_name = "${var.elb_public_certname}"
  listener_action                  = "${map("HTTPS:443", "HTTP:80")}"
  subnets                          = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups                  = ["${data.terraform_remote_state.infra_security_groups.sg_monitoring_external_elb_id}"]
  alarm_actions                    = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  default_tags                     = "${map("Project", var.stackname, "aws_migration", "monitoring", "aws_environment", var.aws_environment)}"
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
    values = ["blue-monitoring"]
  }
}

resource "aws_autoscaling_attachment" "monitoring_asg_attachment_alb" {
  autoscaling_group_name = "${element(data.aws_autoscaling_groups.monitoring.names, 0)}"
  alb_target_group_arn   = "${element(module.monitoring_public_lb.target_group_arns, 0)}"
}

#
# Publishing-api
#

module "publishing_api_public_lb" {
  source                           = "../../modules/aws/lb"
  name                             = "${var.stackname}-publishing-api-pub"
  internal                         = false
  vpc_id                           = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  access_logs_bucket_name          = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  access_logs_bucket_prefix        = "elb/${var.stackname}-graphite-public-elb"
  listener_certificate_domain_name = "${var.elb_public_certname}"
  listener_action                  = "${map("HTTPS:443", "HTTP:80")}"
  subnets                          = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups                  = ["${data.terraform_remote_state.infra_security_groups.sg_publishing-api_elb_external_id}"]
  alarm_actions                    = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  default_tags                     = "${map("Project", var.stackname, "aws_migration", "publishing_api", "aws_environment", var.aws_environment)}"
}

resource "aws_route53_record" "publishing_api_public_service_names" {
  count   = "${length(var.publishing_api_public_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.external_root_zone_id}"
  name    = "${element(var.publishing_api_public_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.external_root_domain_name}"
  type    = "A"

  alias {
    name                   = "${module.publishing_api_public_lb.lb_dns_name}"
    zone_id                = "${module.publishing_api_public_lb.lb_zone_id}"
    evaluate_target_health = true
  }
}

data "aws_autoscaling_groups" "publishing_api" {
  filter {
    name   = "key"
    values = ["Name"]
  }

  filter {
    name   = "value"
    values = ["blue-publishing-api"]
  }
}

resource "aws_autoscaling_attachment" "publishing_api_asg_attachment_alb" {
  autoscaling_group_name = "${element(data.aws_autoscaling_groups.publishing_api.names, 0)}"
  alb_target_group_arn   = "${element(module.publishing_api_public_lb.target_group_arns, 0)}"
}

#
# Whitehall-backend
#

module "whitehall_backend_public_lb" {
  source                           = "../../modules/aws/lb"
  name                             = "${var.stackname}-whitehall-public"
  internal                         = false
  vpc_id                           = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  access_logs_bucket_name          = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  access_logs_bucket_prefix        = "elb/${var.stackname}-whitehall-backend-public-elb"
  listener_certificate_domain_name = "${var.elb_public_certname}"
  listener_action                  = "${map("HTTPS:443", "HTTP:80")}"
  subnets                          = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups                  = ["${data.terraform_remote_state.infra_security_groups.sg_whitehall-backend_external_elb_id}"]
  alarm_actions                    = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  default_tags                     = "${map("Project", var.stackname, "aws_migration", "whitehall_backend", "aws_environment", var.aws_environment)}"
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
  autoscaling_group_name = "${element(data.aws_autoscaling_groups.whitehall_backend.names, 0)}"
  alb_target_group_arn   = "${element(module.whitehall_backend_public_lb.target_group_arns, 0)}"
}
