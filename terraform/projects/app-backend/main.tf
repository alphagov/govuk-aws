/**
* ## Project: app-backend
*
* Backend node
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

variable "instance_ami_filter_name" {
  type        = "string"
  description = "Name to use to find AMI images"
  default     = ""
}

variable "elb_internal_certname" {
  type        = "string"
  description = "The ACM cert domain name to find the ARN of"
}

variable "app_service_records_alb" {
  type        = "list"
  description = "List of application service names that get traffic via internal alb"
  default     = []
}

variable "renamed_app_service_records_alb" {
  type        = "list"
  description = "List of renamed application service names that get traffic via internal alb"
  default     = []
}

variable "app_service_records_redirected_public_alb" {
  type        = "list"
  description = "List of internal application service names that get traffic via public alb"
  default     = []
}

variable "asg_size" {
  type        = "string"
  description = "The autoscaling groups desired/max/min capacity"
  default     = "2"
}

variable "internal_zone_name" {
  type        = "string"
  description = "The name of the Route53 zone that contains internal records"
}

variable "internal_domain_name" {
  type        = "string"
  description = "The domain name of the internal DNS records, it could be different from the zone name"
}

variable "instance_type" {
  type        = "string"
  description = "Instance type used for EC2 resources"
  default     = "m5.2xlarge"
}

variable "rules_for_existing_target_groups" {
  type        = "map"
  description = "create an additional rule for a target group already created via rules_host"
  default     = {}
}

# Resources
# --------------------------------------------------------------
terraform {
  backend          "s3"             {}
  required_version = "= 0.11.15"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "2.46.0"
}

data "aws_route53_zone" "internal" {
  name         = "${var.internal_zone_name}"
  private_zone = true
}

data "aws_acm_certificate" "elb_internal_cert" {
  domain   = "${var.elb_internal_certname}"
  statuses = ["ISSUED"]
}

module "backend" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-backend"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "backend", "aws_hostname", "backend-1")}"
  instance_subnet_ids           = "${data.terraform_remote_state.infra_networking.private_subnet_ids}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_backend_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}", "${data.terraform_remote_state.infra_security_groups.sg_aws-vpn_id}"]
  instance_type                 = "${var.instance_type}"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids_length       = 0
  instance_elb_ids              = []
  instance_ami_filter_name      = "${var.instance_ami_filter_name}"
  asg_max_size                  = "${var.asg_size}"
  asg_min_size                  = "${var.asg_size}"
  asg_desired_capacity          = "${var.asg_size}"
  asg_notification_topic_arn    = "${data.terraform_remote_state.infra_monitoring.sns_topic_autoscaling_group_events_arn}"
  root_block_device_volume_size = "60"
}

# Internal ALB for backend
module "backend_internal_alb" {
  source                           = "../../modules/aws/lb"
  name                             = "${var.stackname}-backend-internal"
  internal                         = true
  vpc_id                           = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  access_logs_bucket_name          = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  access_logs_bucket_prefix        = "elb/${var.stackname}-backend-internal-alb"
  listener_certificate_domain_name = "${var.elb_internal_certname}"
  listener_action                  = "${map("HTTPS:443", "HTTP:80")}"
  subnets                          = ["${data.terraform_remote_state.infra_networking.private_subnet_ids}"]

  #TODO: create new security group with alb name
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_backend_elb_internal_id}"]
  alarm_actions   = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  default_tags    = "${map("Project", var.stackname, "aws_migration", "backend", "aws_environment", var.aws_environment)}"
}

# listerner rules for backend internal ALB
module "backend_internal_alb_rules" {
  source                           = "../../modules/aws/lb_listener_rules"
  name                             = "backend-i"
  autoscaling_group_name           = "${module.backend.autoscaling_group_name}"
  rules_host_domain                = "*"
  vpc_id                           = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  listener_arn                     = "${module.backend_internal_alb.load_balancer_ssl_listeners[0]}"
  rules_host                       = ["${var.app_service_records_alb}"]
  rules_for_existing_target_groups = "${var.rules_for_existing_target_groups}"

  default_tags = {
    Project         = "${var.stackname}"
    aws_migration   = "backend"
    aws_environment = "${var.aws_environment}"
  }
}

resource "aws_route53_record" "service_record_internal" {
  zone_id = "${data.aws_route53_zone.internal.zone_id}"
  name    = "backend.${var.internal_domain_name}"
  type    = "A"

  alias {
    name                   = "${module.backend_internal_alb.lb_dns_name}"
    zone_id                = "${module.backend_internal_alb.lb_zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "app_service_records_internal" {
  count   = "${length(concat(var.app_service_records_alb, var.renamed_app_service_records_alb))}"
  zone_id = "${data.aws_route53_zone.internal.zone_id}"
  name    = "${element(concat(var.app_service_records_alb, var.renamed_app_service_records_alb), count.index)}.${var.internal_domain_name}"
  type    = "CNAME"
  records = ["backend.${var.internal_domain_name}."]
  ttl     = "300"
}

resource "aws_route53_record" "app_service_records_redirected_public_alb" {
  count   = "${length(var.app_service_records_redirected_public_alb)}"
  zone_id = "${data.aws_route53_zone.internal.zone_id}"
  name    = "${element(var.app_service_records_redirected_public_alb, count.index)}.${var.internal_domain_name}"
  type    = "CNAME"
  records = ["backend.${data.terraform_remote_state.infra_root_dns_zones.external_root_domain_name}"]
  ttl     = "300"
}

data "aws_security_group" "collections-publisher-rds" {
  name = "${var.stackname}_collections-publisher_rds_access"
}

resource "aws_security_group_rule" "collections-publisher-rds_ingress_backend_mysql" {
  type      = "ingress"
  from_port = 3306
  to_port   = 3306
  protocol  = "tcp"

  security_group_id        = "${data.aws_security_group.collections-publisher-rds.0.id}"
  source_security_group_id = "${data.terraform_remote_state.infra_security_groups.sg_backend_id}"
}

data "aws_security_group" "contacts-admin-rds" {
  name = "${var.stackname}_contacts-admin_rds_access"
}

resource "aws_security_group_rule" "contacts-admin-rds_ingress_backend_mysql" {
  type      = "ingress"
  from_port = 3306
  to_port   = 3306
  protocol  = "tcp"

  security_group_id        = "${data.aws_security_group.contacts-admin-rds.0.id}"
  source_security_group_id = "${data.terraform_remote_state.infra_security_groups.sg_backend_id}"
}

data "aws_security_group" "content-data-admin-rds" {
  name = "${var.stackname}_content-data-admin_rds_access"
}

resource "aws_security_group_rule" "content-data-admin-rds_ingress_backend_postgres" {
  type      = "ingress"
  from_port = 5432
  to_port   = 5432
  protocol  = "tcp"

  security_group_id        = "${data.aws_security_group.content-data-admin-rds.0.id}"
  source_security_group_id = "${data.terraform_remote_state.infra_security_groups.sg_backend_id}"
}

data "aws_security_group" "content-publisher-rds" {
  name = "${var.stackname}_content-publisher_rds_access"
}

resource "aws_security_group_rule" "content-publisher-rds_ingress_backend_postgres" {
  type      = "ingress"
  from_port = 5432
  to_port   = 5432
  protocol  = "tcp"

  security_group_id        = "${data.aws_security_group.content-publisher-rds.0.id}"
  source_security_group_id = "${data.terraform_remote_state.infra_security_groups.sg_backend_id}"
}

data "aws_security_group" "content-tagger-rds" {
  name = "${var.stackname}_content-tagger_rds_access"
}

resource "aws_security_group_rule" "content-tagger-rds_ingress_backend_postgres" {
  type      = "ingress"
  from_port = 5432
  to_port   = 5432
  protocol  = "tcp"

  security_group_id        = "${data.aws_security_group.content-tagger-rds.0.id}"
  source_security_group_id = "${data.terraform_remote_state.infra_security_groups.sg_backend_id}"
}

data "aws_security_group" "imminence-rds" {
  name = "${var.stackname}_imminence_rds_access"
}

resource "aws_security_group_rule" "imminence-rds_ingress_backend_postgres" {
  type      = "ingress"
  from_port = 5432
  to_port   = 5432
  protocol  = "tcp"

  security_group_id        = "${data.aws_security_group.imminence-rds.0.id}"
  source_security_group_id = "${data.terraform_remote_state.infra_security_groups.sg_backend_id}"
}

data "aws_security_group" "link-checker-api-rds" {
  name = "${var.stackname}_link-checker-api_rds_access"
}

resource "aws_security_group_rule" "link-checker-api-rds_ingress_backend_postgres" {
  type      = "ingress"
  from_port = 5432
  to_port   = 5432
  protocol  = "tcp"

  security_group_id        = "${data.aws_security_group.link-checker-api-rds.0.id}"
  source_security_group_id = "${data.terraform_remote_state.infra_security_groups.sg_backend_id}"
}

data "aws_security_group" "local-links-manager-rds" {
  name = "${var.stackname}_local-links-manager_rds_access"
}

resource "aws_security_group_rule" "local-links-manager-rds_ingress_backend_postgres" {
  type      = "ingress"
  from_port = 5432
  to_port   = 5432
  protocol  = "tcp"

  security_group_id        = "${data.aws_security_group.local-links-manager-rds.0.id}"
  source_security_group_id = "${data.terraform_remote_state.infra_security_groups.sg_backend_id}"
}

data "aws_security_group" "release-rds" {
  name = "${var.stackname}_release_rds_access"
}

resource "aws_security_group_rule" "release-rds_ingress_backend_mysql" {
  type      = "ingress"
  from_port = 3306
  to_port   = 3306
  protocol  = "tcp"

  security_group_id        = "${data.aws_security_group.release-rds.0.id}"
  source_security_group_id = "${data.terraform_remote_state.infra_security_groups.sg_backend_id}"
}

data "aws_security_group" "search-admin-rds" {
  name = "${var.stackname}_search-admin_rds_access"
}

resource "aws_security_group_rule" "search-admin-rds_ingress_backend_mysql" {
  type      = "ingress"
  from_port = 3306
  to_port   = 3306
  protocol  = "tcp"

  security_group_id        = "${data.aws_security_group.search-admin-rds.0.id}"
  source_security_group_id = "${data.terraform_remote_state.infra_security_groups.sg_backend_id}"
}

data "aws_security_group" "service-manual-publisher-rds" {
  name = "${var.stackname}_service-manual-publisher_rds_access"
}

resource "aws_security_group_rule" "service-manual-publisher-rds_ingress_backend_postgres" {
  type      = "ingress"
  from_port = 5432
  to_port   = 5432
  protocol  = "tcp"

  security_group_id        = "${data.aws_security_group.service-manual-publisher-rds.0.id}"
  source_security_group_id = "${data.terraform_remote_state.infra_security_groups.sg_backend_id}"
}

data "aws_security_group" "signon-rds" {
  name = "${var.stackname}_signon_rds_access"
}

resource "aws_security_group_rule" "signon-rds_ingress_backend_mysql" {
  type      = "ingress"
  from_port = 3306
  to_port   = 3306
  protocol  = "tcp"

  security_group_id        = "${data.aws_security_group.signon-rds.0.id}"
  source_security_group_id = "${data.terraform_remote_state.infra_security_groups.sg_backend_id}"
}

data "aws_security_group" "support-api-rds" {
  name = "${var.stackname}_support-api_rds_access"
}

resource "aws_security_group_rule" "support-api-rds_ingress_backend_postgres" {
  type      = "ingress"
  from_port = 5432
  to_port   = 5432
  protocol  = "tcp"

  security_group_id        = "${data.aws_security_group.support-api-rds.0.id}"
  source_security_group_id = "${data.terraform_remote_state.infra_security_groups.sg_backend_id}"
}

# Outputs
# --------------------------------------------------------------

output "backend_alb_internal_address" {
  value       = "${module.backend_internal_alb.lb_dns_name}"
  description = "AWS' internal DNS name for the backend ELB"
}

output "service_dns_name_internal" {
  value       = "${aws_route53_record.service_record_internal.name}"
  description = "DNS name to access the node service"
}

output "app_service_records_internal_dns_name" {
  value       = "${concat(aws_route53_record.app_service_records_internal.*.name, aws_route53_record.app_service_records_redirected_public_alb.*.name)}"
  description = "DNS name to access the app service records"
}
