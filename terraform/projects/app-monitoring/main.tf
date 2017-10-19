# == Manifest: projects::app-monitoring
#
# Monitoring node
#
# === Variables:
#
# aws_region
# stackname
# aws_environment
# ssh_public_key
# instance_ami_filter_name
# elb_external_certname
#
# === Outputs:
#

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

variable "ssh_public_key" {
  type        = "string"
  description = "Default public key material"
}

variable "instance_ami_filter_name" {
  type        = "string"
  description = "Name to use to find AMI images"
  default     = ""
}

variable "elb_external_certname" {
  type        = "string"
  description = "The ACM cert domain name to find the ARN of"
}

# Resources
# --------------------------------------------------------------
terraform {
  backend          "s3"             {}
  required_version = "= 0.10.7"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "1.0.0"
}

data "aws_acm_certificate" "elb_external_cert" {
  domain   = "${var.elb_external_certname}"
  statuses = ["ISSUED"]
}

resource "aws_elb" "monitoring_external_elb" {
  name            = "${var.stackname}-monitoring-external"
  subnets         = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_monitoring_external_elb_id}"]
  internal        = "false"

  access_logs {
    bucket        = "${data.terraform_remote_state.infra_aws_logging.aws_logging_bucket_id}"
    bucket_prefix = "${var.stackname}-monitoring-external-elb"
    interval      = 60
  }

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 443
    lb_protocol       = "https"

    ssl_certificate_id = "${data.aws_acm_certificate.elb_external_cert.arn}"
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

  tags = "${map("Name", "${var.stackname}-monitoring", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "monitoring")}"
}

resource "aws_elb" "monitoring_internal_elb" {
  name            = "${var.stackname}-monitoring"
  subnets         = ["${data.terraform_remote_state.infra_networking.private_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_monitoring_internal_elb_id}"]
  internal        = "true"

  listener {
    instance_port     = 5667
    instance_protocol = "tcp"
    lb_port           = 5667
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3

    target   = "TCP:5667"
    interval = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = "${map("Name", "${var.stackname}-monitoring", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "monitoring")}"
}

module "monitoring" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-monitoring"
  vpc_id                        = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "monitoring", "aws_hostname", "monitoring-1")}"
  instance_subnet_ids           = "${data.terraform_remote_state.infra_networking.private_subnet_ids}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_monitoring_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "t2.medium"
  create_instance_key           = true
  instance_key_name             = "${var.stackname}-monitoring"
  instance_public_key           = "${var.ssh_public_key}"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids              = ["${aws_elb.monitoring_external_elb.id}", "${aws_elb.monitoring_internal_elb.id}"]
  instance_ami_filter_name      = "${var.instance_ami_filter_name}"
}

resource "aws_route53_record" "external_service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.external_zone_id}"
  name    = "alert.${data.terraform_remote_state.infra_stack_dns_zones.external_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.monitoring_external_elb.dns_name}"
    zone_id                = "${aws_elb.monitoring_external_elb.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "internal_service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.internal_zone_id}"
  name    = "alert.${data.terraform_remote_state.infra_stack_dns_zones.internal_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.monitoring_internal_elb.dns_name}"
    zone_id                = "${aws_elb.monitoring_internal_elb.zone_id}"
    evaluate_target_health = true
  }
}

# Outputs
# --------------------------------------------------------------

output "monitoring_external_elb_dns_name" {
  value       = "${aws_elb.monitoring_external_elb.dns_name}"
  description = "External DNS name to access the monitoring service"
}

output "monitoring_internal_elb_dns_name" {
  value       = "${aws_elb.monitoring_internal_elb.dns_name}"
  description = "Internal DNS name to access the monitoring service"
}
