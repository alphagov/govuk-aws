/**
* ## Project: app-draft-cache
*
* Draft Cache servers
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

variable "instance_ami_filter_name" {
  type        = string
  description = "Name to use to find AMI images"
  default     = ""
}

variable "elb_internal_certname" {
  type        = string
  description = "The ACM cert domain name to find the ARN of"
}

variable "elb_external_certname" {
  type        = string
  description = "The ACM cert domain name to find the ARN of"
}

variable "app_service_records" {
  type        = list(string)
  description = "List of application service names that get traffic via this loadbalancer"
  default     = []
}

variable "asg_size" {
  type        = string
  description = "The autoscaling groups desired/max/min capacity"
  default     = "2"
}

variable "instance_type" {
  type        = string
  description = "Instance type used for EC2 resources"
  default     = "t2.medium"
}

variable "external_zone_name" {
  type        = string
  description = "The name of the Route53 zone that contains external records"
}

variable "external_domain_name" {
  type        = string
  description = "The domain name of the external DNS records, it could be different from the zone name"
}

variable "internal_zone_name" {
  type        = string
  description = "The name of the Route53 zone that contains internal records"
}

variable "internal_domain_name" {
  type        = string
  description = "The domain name of the internal DNS records, it could be different from the zone name"
}

variable "create_external_elb" {
  description = "Create the external ELB"
  default     = true
}

# Resources
# --------------------------------------------------------------
terraform {
  backend "s3" {}
  required_version = "= 0.12.30"
}

provider "aws" {
  region  = var.aws_region
  version = "2.46.0"
}

data "aws_route53_zone" "external" {
  name         = var.external_zone_name
  private_zone = false
}

data "aws_route53_zone" "internal" {
  name         = var.internal_zone_name
  private_zone = true
}

data "aws_acm_certificate" "elb_internal_cert" {
  domain   = var.elb_internal_certname
  statuses = ["ISSUED"]
}

data "aws_acm_certificate" "elb_external_cert" {
  domain   = var.elb_external_certname
  statuses = ["ISSUED"]
}

resource "aws_elb" "draft-cache_elb" {
  name            = "${var.stackname}-draft-cache"
  subnets         = ["${data.terraform_remote_state.infra_networking.private_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_draft-cache_elb_id}"]
  internal        = "true"

  access_logs {
    bucket        = data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id
    bucket_prefix = "elb/${var.stackname}-draft-cache-internal-elb"
    interval      = 60
  }

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 443
    lb_protocol       = "https"

    ssl_certificate_id = data.aws_acm_certificate.elb_internal_cert.arn
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3

    target   = "TCP:80"
    interval = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = map("Name", "${var.stackname}-draft-cache", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "draft_cache")
}

resource "aws_route53_record" "draft-cache_service_record" {
  zone_id = data.aws_route53_zone.internal.zone_id
  name    = "draft-cache.${var.internal_domain_name}"
  type    = "A"

  alias {
    name                   = aws_elb.draft-cache_elb.dns_name
    zone_id                = aws_elb.draft-cache_elb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "authenticating-proxy_service_record" {
  zone_id = data.aws_route53_zone.internal.zone_id
  name    = "authenticating-proxy.${var.internal_domain_name}"
  type    = "A"

  alias {
    name                   = aws_elb.draft-cache_elb.dns_name
    zone_id                = aws_elb.draft-cache_elb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "draft-router-api_internal_record" {
  zone_id = data.aws_route53_zone.internal.zone_id
  name    = "draft-router-api.${var.internal_domain_name}"
  type    = "A"

  alias {
    name                   = aws_elb.draft-cache_elb.dns_name
    zone_id                = aws_elb.draft-cache_elb.zone_id
    evaluate_target_health = true
  }
}

# TODO publicapi is a special set of nginx config that routes /api requests to
# their relevant apps upstream.
resource "aws_route53_record" "draft-cache_publicapi_service_record" {
  zone_id = data.aws_route53_zone.internal.zone_id
  name    = "draft-publicapi.${var.internal_domain_name}"
  type    = "CNAME"
  records = ["draft-cache.${var.internal_domain_name}."]
  ttl     = 300
}

resource "aws_elb" "draft-cache_external_elb" {
  count = var.create_external_elb

  name            = "${var.stackname}-draft-cache-external"
  subnets         = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_draft-cache_external_elb_id}"]
  internal        = "false"

  access_logs {
    bucket        = data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id
    bucket_prefix = "elb/${var.stackname}-draft-cache-external-elb"
    interval      = 60
  }

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 443
    lb_protocol       = "https"

    ssl_certificate_id = data.aws_acm_certificate.elb_external_cert.arn
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3

    target   = "TCP:80"
    interval = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = map("Name", "${var.stackname}-draft-cache", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "draft-cache")
}

resource "aws_route53_record" "draft-cache_external_service_record" {
  count = var.create_external_elb

  zone_id = data.aws_route53_zone.external.zone_id
  name    = "draft-cache.${var.external_domain_name}"
  type    = "A"

  alias {
    name                   = aws_elb.draft-cache_external_elb.dns_name
    zone_id                = aws_elb.draft-cache_external_elb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "app_service_records" {
  count   = length(var.app_service_records)
  zone_id = data.aws_route53_zone.external.zone_id
  name    = "${element(var.app_service_records, count.index)}.${var.external_domain_name}"
  type    = "CNAME"
  records = ["draft-cache.${var.external_domain_name}."]
  ttl     = "300"
}

locals {
  instance_elb_ids_length = var.create_external_elb ? 2 : 1
  instance_elb_ids        = compact(list(aws_elb.draft-cache_elb.id, join("", aws_elb.draft-cache_external_elb.*.id)))
}

module "draft-cache" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-draft-cache"
  default_tags                  = map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "draft_cache", "aws_hostname", "draft-cache-1")
  instance_subnet_ids           = data.terraform_remote_state.infra_networking.private_subnet_ids
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_draft-cache_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = var.instance_type
  instance_additional_user_data = join("\n", null_resource.user_data.*.triggers.snippet)
  instance_elb_ids_length       = local.instance_elb_ids_length
  instance_elb_ids              = ["${local.instance_elb_ids}"]
  instance_ami_filter_name      = var.instance_ami_filter_name
  asg_max_size                  = var.asg_size
  asg_min_size                  = var.asg_size
  asg_desired_capacity          = var.asg_size
  asg_notification_topic_arn    = data.terraform_remote_state.infra_monitoring.sns_topic_autoscaling_group_events_arn
}

module "alarms-elb-draft-cache-internal" {
  source                         = "../../modules/aws/alarms/elb"
  name_prefix                    = "${var.stackname}-draft-cache-internal"
  alarm_actions                  = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  elb_name                       = aws_elb.draft-cache_elb.name
  httpcode_backend_4xx_threshold = "0"
  httpcode_backend_5xx_threshold = "100"
  httpcode_elb_4xx_threshold     = "100"
  httpcode_elb_5xx_threshold     = "100"
  surgequeuelength_threshold     = "0"
  healthyhostcount_threshold     = "0"
}

locals {
  elb_httpcode_backend_5xx_threshold = var.create_external_elb ? 100 : 0
  elb_httpcode_elb_4xx_threshold     = var.create_external_elb ? 100 : 0
  elb_httpcode_elb_5xx_threshold     = var.create_external_elb ? 100 : 0
}

module "alarms-elb-draft-cache-external" {
  source                         = "../../modules/aws/alarms/elb"
  name_prefix                    = "${var.stackname}-draft-cache-external"
  alarm_actions                  = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  elb_name                       = join("", aws_elb.draft-cache_external_elb.*.name)
  httpcode_backend_4xx_threshold = "0"
  httpcode_backend_5xx_threshold = local.elb_httpcode_backend_5xx_threshold
  httpcode_elb_4xx_threshold     = local.elb_httpcode_elb_4xx_threshold
  httpcode_elb_5xx_threshold     = local.elb_httpcode_elb_4xx_threshold
  surgequeuelength_threshold     = "0"
  healthyhostcount_threshold     = "0"
}

data "aws_security_group" "authenticating-proxy-rds" {
  name = "${var.stackname}_authenticating-proxy_rds_access"
}

resource "aws_security_group_rule" "authenticating-proxy-rds_ingress_draft_cache_postgres" {
  type      = "ingress"
  from_port = 5432
  to_port   = 5432
  protocol  = "tcp"

  security_group_id        = data.aws_security_group.authenticating-proxy-rds.0.id
  source_security_group_id = data.terraform_remote_state.infra_security_groups.sg_draft-cache_id
}

# Outputs
# --------------------------------------------------------------

output "draft-cache_elb_dns_name" {
  value       = aws_elb.draft-cache_elb.dns_name
  description = "DNS name to access the draft-cache service"
}

output "draft-cache_external_elb_dns_name" {
  value       = join("", aws_elb.draft-cache_external_elb.*.dns_name)
  description = "DNS name to access the draft-cache external service"
}

output "service_dns_name" {
  value       = aws_route53_record.draft-cache_service_record.fqdn
  description = "DNS name to access the service"
}

output "draft-router-api_internal_dns_name" {
  value       = aws_route53_record.draft-router-api_internal_record.fqdn
  description = "DNS name to access draft-router-api"
}

output "external_service_dns_name" {
  value       = join("", aws_route53_record.draft-cache_external_service_record.*.fqdn)
  description = "DNS name to access the external service"
}
