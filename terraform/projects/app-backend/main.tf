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

variable "elb_external_certname" {
  type        = "string"
  description = "The ACM cert domain name to find the ARN of"
}

variable "app_service_records" {
  type        = "list"
  description = "List of application service names that get traffic via this loadbalancer"
  default     = []
}

variable "asg_size" {
  type        = "string"
  description = "The autoscaling groups desired/max/min capacity"
  default     = "2"
}

variable "external_zone_name" {
  type        = "string"
  description = "The name of the Route53 zone that contains external records"
}

variable "external_domain_name" {
  type        = "string"
  description = "The domain name of the external DNS records, it could be different from the zone name"
}

variable "internal_zone_name" {
  type        = "string"
  description = "The name of the Route53 zone that contains internal records"
}

variable "internal_domain_name" {
  type        = "string"
  description = "The domain name of the internal DNS records, it could be different from the zone name"
}

variable "create_external_elb" {
  description = "Create the external ELB"
  default     = true
}

variable "instance_type" {
  type        = "string"
  description = "Instance type used for EC2 resources"
  default     = "m5.2xlarge"
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

data "aws_route53_zone" "external" {
  name         = "${var.external_zone_name}"
  private_zone = false
}

data "aws_route53_zone" "internal" {
  name         = "${var.internal_zone_name}"
  private_zone = true
}

data "aws_acm_certificate" "elb_external_cert" {
  domain   = "${var.elb_external_certname}"
  statuses = ["ISSUED"]
}

data "aws_acm_certificate" "elb_internal_cert" {
  domain   = "${var.elb_internal_certname}"
  statuses = ["ISSUED"]
}

resource "aws_elb" "backend_elb_external" {
  count = "${var.create_external_elb}"

  name            = "${var.stackname}-backend-external"
  subnets         = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_backend_elb_external_id}"]
  internal        = "false"

  access_logs {
    bucket        = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    bucket_prefix = "elb/${var.stackname}-backend-external-elb"
    interval      = 60
  }

  listener {
    instance_port     = "80"
    instance_protocol = "http"
    lb_port           = "443"
    lb_protocol       = "https"

    ssl_certificate_id = "${data.aws_acm_certificate.elb_external_cert.arn}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:80"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = "${map("Name", "${var.stackname}-backend", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "backend")}"
}

resource "aws_route53_record" "service_record_external" {
  count = "${var.create_external_elb}"

  zone_id = "${data.aws_route53_zone.external.zone_id}"
  name    = "backend.${var.external_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.backend_elb_external.dns_name}"
    zone_id                = "${aws_elb.backend_elb_external.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "app_service_records_external" {
  count   = "${length(var.app_service_records)}"
  zone_id = "${data.aws_route53_zone.external.zone_id}"
  name    = "${element(var.app_service_records, count.index)}.${var.external_domain_name}"
  type    = "CNAME"
  records = ["backend.${var.external_domain_name}."]
  ttl     = "300"
}

resource "aws_elb" "backend_elb_internal" {
  name            = "${var.stackname}-backend-internal"
  subnets         = ["${data.terraform_remote_state.infra_networking.private_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_backend_elb_internal_id}"]
  internal        = "true"

  access_logs {
    bucket        = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    bucket_prefix = "elb/${var.stackname}-backend-internal-elb"
    interval      = 60
  }

  listener {
    instance_port     = "80"
    instance_protocol = "http"
    lb_port           = "443"
    lb_protocol       = "https"

    ssl_certificate_id = "${data.aws_acm_certificate.elb_internal_cert.arn}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:80"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = "${map("Name", "${var.stackname}-backend", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "backend")}"
}

resource "aws_route53_record" "service_record_internal" {
  zone_id = "${data.aws_route53_zone.internal.zone_id}"
  name    = "backend.${var.internal_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.backend_elb_internal.dns_name}"
    zone_id                = "${aws_elb.backend_elb_internal.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "app_service_records_internal" {
  count   = "${length(var.app_service_records)}"
  zone_id = "${data.aws_route53_zone.internal.zone_id}"
  name    = "${element(var.app_service_records, count.index)}.${var.internal_domain_name}"
  type    = "CNAME"
  records = ["backend.${var.internal_domain_name}."]
  ttl     = "300"
}

locals {
  instance_elb_ids_length = "${var.create_external_elb ? 2 : 1}"
  instance_elb_ids        = "${compact(list(join("", aws_elb.backend_elb_external.*.id), aws_elb.backend_elb_internal.id))}"
}

module "backend" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-backend"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "backend", "aws_hostname", "backend-1")}"
  instance_subnet_ids           = "${data.terraform_remote_state.infra_networking.private_subnet_ids}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_backend_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}", "${data.terraform_remote_state.infra_security_groups.sg_aws-vpn_id}"]
  instance_type                 = "${var.instance_type}"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids_length       = "${local.instance_elb_ids_length}"
  instance_elb_ids              = ["${local.instance_elb_ids}"]
  instance_ami_filter_name      = "${var.instance_ami_filter_name}"
  asg_max_size                  = "${var.asg_size}"
  asg_min_size                  = "${var.asg_size}"
  asg_desired_capacity          = "${var.asg_size}"
  asg_notification_topic_arn    = "${data.terraform_remote_state.infra_monitoring.sns_topic_autoscaling_group_events_arn}"
  root_block_device_volume_size = "60"
}

locals {
  elb_httpcode_backend_5xx_threshold = "${var.create_external_elb ? 100 : 0}"
  elb_httpcode_elb_4xx_threshold     = "${var.create_external_elb ? 100 : 0}"
  elb_httpcode_elb_5xx_threshold     = "${var.create_external_elb ? 100 : 0}"
}

module "alarms-elb-backend-internal" {
  source                         = "../../modules/aws/alarms/elb"
  name_prefix                    = "${var.stackname}-backend-internal"
  alarm_actions                  = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  elb_name                       = "${aws_elb.backend_elb_internal.name}"
  httpcode_backend_4xx_threshold = "0"
  httpcode_backend_5xx_threshold = "${local.elb_httpcode_backend_5xx_threshold}"
  httpcode_elb_4xx_threshold     = "${local.elb_httpcode_elb_4xx_threshold}"
  httpcode_elb_5xx_threshold     = "${local.elb_httpcode_elb_5xx_threshold}"
  surgequeuelength_threshold     = "0"
  healthyhostcount_threshold     = "0"
}

module "alarms-elb-backend-external" {
  source                         = "../../modules/aws/alarms/elb"
  name_prefix                    = "${var.stackname}-backend-external"
  alarm_actions                  = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  elb_name                       = "${aws_elb.backend_elb_external.name}"
  httpcode_backend_4xx_threshold = "0"
  httpcode_backend_5xx_threshold = "100"
  httpcode_elb_4xx_threshold     = "100"
  httpcode_elb_5xx_threshold     = "100"
  surgequeuelength_threshold     = "0"
  healthyhostcount_threshold     = "0"
}

# Outputs
# --------------------------------------------------------------

output "backend_elb_internal_address" {
  value       = "${aws_elb.backend_elb_internal.dns_name}"
  description = "AWS' internal DNS name for the backend ELB"
}

output "service_dns_name_internal" {
  value       = "${aws_route53_record.service_record_internal.name}"
  description = "DNS name to access the node service"
}

output "app_service_records_internal_dns_name" {
  value       = "${aws_route53_record.app_service_records_internal.*.name}"
  description = "DNS name to access the app service records"
}

output "backend_elb_external_address" {
  value       = "${join("", aws_elb.backend_elb_external.*.dns_name)}"
  description = "AWS' external DNS name for the backend ELB"
}

output "service_dns_name_external" {
  value       = "${join("", aws_route53_record.service_record_external.*.name)}"
  description = "DNS name to access the node service"
}

output "app_service_records_external_dns_name" {
  value       = "${aws_route53_record.app_service_records_external.*.name}"
  description = "DNS name to access the app service records"
}
