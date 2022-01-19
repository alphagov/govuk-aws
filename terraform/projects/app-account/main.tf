/**
* ## Project: app-account
*
* account node
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
  default     = "m5.xlarge"
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

provider "aws" {
  region  = "${var.aws_region}"
  version = "2.46.0"
}

data "aws_acm_certificate" "elb_internal_cert" {
  domain   = "${var.elb_internal_certname}"
  statuses = ["ISSUED"]
}

resource "aws_elb" "account_elb_internal" {
  name            = "${var.stackname}-account-internal"
  subnets         = ["${data.terraform_remote_state.infra_networking.private_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_account_elb_internal_id}"]
  internal        = "true"

  access_logs {
    bucket        = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    bucket_prefix = "elb/${var.stackname}-account-internal-elb"
    interval      = 60
  }

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = "443"
    lb_protocol       = "https"

    ssl_certificate_id = "${data.aws_acm_certificate.elb_internal_cert.arn}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/_healthcheck-live_account-api"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = "${map("Name", "${var.stackname}-account", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "account")}"
}

resource "aws_route53_record" "service_record_internal" {
  zone_id = "${data.aws_route53_zone.internal.zone_id}"
  name    = "account.${var.internal_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.account_elb_internal.dns_name}"
    zone_id                = "${aws_elb.account_elb_internal.zone_id}"
    evaluate_target_health = true
  }
}

module "account" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-account"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "account", "aws_hostname", "account-1")}"
  instance_subnet_ids           = "${data.terraform_remote_state.infra_networking.private_subnet_ids}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_account_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "${var.instance_type}"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids_length       = "1"
  instance_elb_ids              = ["${aws_elb.account_elb_internal.id}"]
  instance_ami_filter_name      = "${var.instance_ami_filter_name}"
  asg_max_size                  = "${var.asg_size}"
  asg_min_size                  = "${var.asg_size}"
  asg_desired_capacity          = "${var.asg_size}"
  asg_notification_topic_arn    = "${data.terraform_remote_state.infra_monitoring.sns_topic_autoscaling_group_events_arn}"
  root_block_device_volume_size = "50"
}

module "alarms-elb-account-internal" {
  source                         = "../../modules/aws/alarms/elb"
  name_prefix                    = "${var.stackname}-account-internal"
  alarm_actions                  = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  elb_name                       = "${aws_elb.account_elb_internal.name}"
  httpcode_backend_4xx_threshold = "0"
  httpcode_backend_5xx_threshold = "100"
  httpcode_elb_4xx_threshold     = "100"
  httpcode_elb_5xx_threshold     = "100"
  surgequeuelength_threshold     = "0"
  healthyhostcount_threshold     = "0"
}

data "aws_security_group" "account-api-rds" {
  name = "${var.stackname}_account-api_rds_access"
}

resource "aws_security_group_rule" "account-api-rds_ingress_account_postgres" {
  type      = "ingress"
  from_port = 5432
  to_port   = 5432
  protocol  = "tcp"

  security_group_id        = "${data.aws_security_group.account-api-rds.0.id}"
  source_security_group_id = "${data.terraform_remote_state.infra_security_groups.sg_account_id}"
}

# Outputs
# --------------------------------------------------------------

output "account_elb_address_internal" {
  value       = "${aws_elb.account_elb_internal.dns_name}"
  description = "AWS' internal DNS name for the account ELB"
}

output "service_dns_name_internal" {
  value       = "${aws_route53_record.service_record_internal.name}"
  description = "DNS name to access the internal node service"
}
