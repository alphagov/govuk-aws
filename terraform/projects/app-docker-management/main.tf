/**
* ## Project: app-docker_management
*
* Docker management node, used to run run adhoc containers.
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
  default     = "t2.medium"
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
  version = "2.33.0"
}

resource "aws_elb" "docker_management_etcd_elb" {
  name            = "${var.stackname}-docker-management-etcd"
  subnets         = ["${data.terraform_remote_state.infra_networking.private_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_docker_management_etcd_elb_id}"]
  internal        = "true"

  access_logs {
    bucket        = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    bucket_prefix = "elb/${var.stackname}-docker-management-etcd-internal-elb"
    interval      = 60
  }

  listener {
    instance_port     = 2379
    instance_protocol = "tcp"
    lb_port           = 2379
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3

    target   = "TCP:2379"
    interval = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = "${map("Name", "${var.stackname}-docker_management_etcd", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "docker_management_etcd")}"
}

resource "aws_route53_record" "docker_management_etcd_service_record" {
  zone_id = "${data.aws_route53_zone.internal.zone_id}"
  name    = "etcd.${var.internal_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.docker_management_etcd_elb.dns_name}"
    zone_id                = "${aws_elb.docker_management_etcd_elb.zone_id}"
    evaluate_target_health = true
  }
}

# TODO: Add external record when we have the external zones working

module "docker_management" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-docker_management"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "docker_management", "aws_hostname", "docker-management-1")}"
  instance_subnet_ids           = "${data.terraform_remote_state.infra_networking.private_subnet_ids}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_docker_management_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "${var.instance_type}"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids_length       = "1"
  instance_elb_ids              = ["${aws_elb.docker_management_etcd_elb.id}"]
  instance_ami_filter_name      = "${var.instance_ami_filter_name}"
  asg_notification_topic_arn    = "${data.terraform_remote_state.infra_monitoring.sns_topic_autoscaling_group_events_arn}"
}

module "alarms-elb-docker-management-internal" {
  source                         = "../../modules/aws/alarms/elb"
  name_prefix                    = "${var.stackname}-docker-management-internal"
  alarm_actions                  = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  elb_name                       = "${aws_elb.docker_management_etcd_elb.name}"
  httpcode_backend_4xx_threshold = "0"
  httpcode_backend_5xx_threshold = "50"
  httpcode_elb_4xx_threshold     = "0"
  httpcode_elb_5xx_threshold     = "50"
  surgequeuelength_threshold     = "0"
  healthyhostcount_threshold     = "0"
}

# Outputs
# --------------------------------------------------------------

output "docker_management_etcd_elb_dns_name" {
  value       = "${aws_elb.docker_management_etcd_elb.dns_name}"
  description = "DNS name to access the docker_management service"
}

output "etcd_service_dns_name" {
  value       = "${aws_route53_record.docker_management_etcd_service_record.fqdn}"
  description = "DNS name to access the node service"
}
