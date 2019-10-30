/**
* ## Project: app-licensify-frontend
*
* Licensify Frontend nodes
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

variable "asg_size" {
  type        = "string"
  description = "The autoscaling groups desired/max/min capacity"
  default     = "2"
}

variable "elb_internal_certname" {
  type        = "string"
  description = "The ACM cert domain name to find the ARN of"
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

variable "app_service_records" {
  type        = "list"
  description = "List of application service names that get traffic via this loadbalancer"
  default     = []
}

variable "external_domain_name" {
  type        = "string"
  description = "The domain name of the external DNS records, it could be different from the zone name"
}

variable "external_zone_name" {
  type        = "string"
  description = "The name of the Route53 zone that contains external records"
}

# Resources
# --------------------------------------------------------------
terraform {
  backend          "s3"             {}
  required_version = "= 0.11.14"
}

data "aws_route53_zone" "internal" {
  name         = "${var.internal_zone_name}"
  private_zone = true
}

data "aws_route53_zone" "external" {
  name         = "${var.external_zone_name}"
  private_zone = false
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "2.33.0"
}

data "aws_acm_certificate" "elb_cert" {
  domain   = "${var.elb_internal_certname}"
  statuses = ["ISSUED"]
}

module "internal_lb" {
  source                           = "../../modules/aws/lb"
  name                             = "${var.stackname}-licensify-frontend-internal"
  internal                         = true
  vpc_id                           = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  access_logs_bucket_name          = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  access_logs_bucket_prefix        = "elb/licensify-frontend-internal-lb"
  listener_certificate_domain_name = "${var.elb_internal_certname}"
  target_group_health_check_path   = "/api/licences"

  listener_action = {
    "HTTPS:443" = "HTTP:80"
  }

  subnets         = ["${data.terraform_remote_state.infra_networking.private_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_licensify-frontend_internal_lb_id}"]
  alarm_actions   = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]

  default_tags = {
    Project         = "${var.stackname}"
    aws_migration   = "licensing_frontend"
    aws_stackname   = "${var.stackname}"
    aws_environment = "${var.aws_environment}"
  }
}

resource "aws_route53_record" "service_record" {
  zone_id = "${data.aws_route53_zone.internal.zone_id}"
  name    = "licensify.${var.internal_domain_name}"
  type    = "A"

  alias {
    name                   = "${module.internal_lb.lb_dns_name}"
    zone_id                = "${module.internal_lb.lb_zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "app_service_records" {
  count   = "${length(var.app_service_records)}"
  zone_id = "${data.aws_route53_zone.external.zone_id}"
  name    = "${element(var.app_service_records, count.index)}.${var.external_domain_name}"
  type    = "CNAME"
  records = ["licensify.${var.external_domain_name}"]
  ttl     = "300"
}

module "licensify-frontend" {
  source = "../../modules/aws/node_group"
  name   = "${var.stackname}-licensify-frontend"

  default_tags = {
    Project         = "${var.stackname}"
    aws_stackname   = "${var.stackname}"
    aws_environment = "${var.aws_environment}"
    aws_migration   = "licensing_frontend"
    aws_hostname    = "licensify-frontend-1"
  }

  instance_subnet_ids               = "${data.terraform_remote_state.infra_networking.private_subnet_ids}"
  instance_security_group_ids       = ["${data.terraform_remote_state.infra_security_groups.sg_licensify-frontend_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                     = "${var.instance_type}"
  instance_additional_user_data     = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_target_group_arns_length = "1"
  instance_target_group_arns        = ["${module.internal_lb.target_group_arns[0]}"]
  instance_ami_filter_name          = "${var.instance_ami_filter_name}"
  asg_max_size                      = "${var.asg_size}"
  asg_min_size                      = "${var.asg_size}"
  asg_desired_capacity              = "${var.asg_size}"
  asg_notification_topic_arn        = "${data.terraform_remote_state.infra_monitoring.sns_topic_autoscaling_group_events_arn}"
  root_block_device_volume_size     = "50"
}

# Outputs
# --------------------------------------------------------------

output "service_dns_name" {
  value       = "${aws_route53_record.service_record.name}"
  description = "DNS name to access the node service"
}
