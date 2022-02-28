/**
* ## Project: app-locations-api
*
* Locations API node
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
  default     = "m5.large"
}

# Resources
# --------------------------------------------------------------
terraform {
  locations_api    "s3"             {}
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

data "aws_acm_certificate" "alb_internal_cert" {
  domain   = "${var.elb_internal_certname}"
  statuses = ["ISSUED"]
}

module "locations-api" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-locations-api"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "locations_api", "aws_hostname", "locations-api-1")}"
  instance_subnet_ids           = "${data.terraform_remote_state.infra_networking.private_subnet_ids}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_locations-api_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}", "${data.terraform_remote_state.infra_security_groups.sg_aws-vpn_id}"]
  instance_type                 = "${var.instance_type}"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_ami_filter_name      = "${var.instance_ami_filter_name}"
  asg_max_size                  = "${var.asg_size}"
  asg_min_size                  = "${var.asg_size}"
  asg_desired_capacity          = "${var.asg_size}"
  asg_notification_topic_arn    = "${data.terraform_remote_state.infra_monitoring.sns_topic_autoscaling_group_events_arn}"
  root_block_device_volume_size = "50"
}

# Internal ALB for locations api
module "locations-api_alb_internal" {
  source                           = "../../modules/aws/lb"
  name                             = "${var.stackname}-locations-api-internal"
  internal                         = true
  vpc_id                           = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  access_logs_bucket_name          = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  access_logs_bucket_prefix        = "alb/${var.stackname}-locations-api-internal-alb"
  listener_certificate_domain_name = "${var.elb_internal_certname}"

  listener_action = {
    "HTTPS:443" = "HTTP:80"
  }

  subnets = ["${data.terraform_remote_state.infra_networking.private_subnet_ids}"]

  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_locations-api_alb_internal}"]
  alarm_actions   = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]

  default_tags = {
    Project         = "${var.stackname}"
    aws_migration   = "locations-api"
    aws_stackname   = "${var.stackname}"
    aws_environment = "${var.aws_environment}"
  }
}

# listerner rules for locations api internal ALB
module "locations-api_alb_internal_rules" {
  source                 = "../../modules/aws/lb_listener_rules"
  name                   = "locations-api"
  autoscaling_group_name = "${module.locations-api.autoscaling_group_name}"
  rules_host_domain      = "*"
  vpc_id                 = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  listener_arn           = "${module.locations-api_alb_internal.load_balancer_ssl_listeners[0]}"

  default_tags = {
    Project         = "${var.stackname}"
    aws_migration   = "locations-api"
    aws_environment = "${var.aws_environment}"
  }
}

resource "aws_route53_record" "service_record_internal" {
  zone_id = "${data.aws_route53_zone.internal.zone_id}"
  name    = "locations-api.${var.internal_domain_name}"
  type    = "A"

  alias {
    name                   = "${module.locations-api_alb_internal.lb_dns_name}"
    zone_id                = "${module.locations-api_alb_internal.lb_zone_id}"
    evaluate_target_health = true
  }
}

data "aws_security_group" "locations-api-rds" {
  name = "${var.stackname}_locations-api_rds_access"
}

resource "aws_security_group_rule" "locations-api-rds_ingress_locations-api_postgres" {
  type      = "ingress"
  from_port = 5432
  to_port   = 5432
  protocol  = "tcp"

  security_group_id        = "${data.aws_security_group.locations-api-rds.0.id}"
  source_security_group_id = "${data.terraform_remote_state.infra_security_groups.sg_locations-api_id}"
}

# Outputs
# --------------------------------------------------------------

output "locations_api_alb_internal_address" {
  value       = "${module.locations-api_alb_internal.lb_dns_name}"
  description = "AWS' internal DNS name for the locations api ALB"
}

output "service_dns_name_internal" {
  value       = "${aws_route53_record.service_record_internal.name}"
  description = "DNS name to access the node service"
}
