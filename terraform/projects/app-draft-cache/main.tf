/**
* ## Project: app-draft-cache
*
* Draft Cache servers
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

variable "ssh_public_key" {
  type        = "string"
  description = "Default public key material"
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

# Resources
# --------------------------------------------------------------
terraform {
  backend          "s3"             {}
  required_version = "= 0.10.8"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "1.0.0"
}

data "aws_acm_certificate" "elb_internal_cert" {
  domain   = "${var.elb_internal_certname}"
  statuses = ["ISSUED"]
}

resource "aws_elb" "draft-cache_elb" {
  name            = "${var.stackname}-draft-cache"
  subnets         = ["${data.terraform_remote_state.infra_networking.private_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_draft-cache_elb_id}"]
  internal        = "true"

  access_logs {
    bucket        = "${data.terraform_remote_state.infra_aws_logging.aws_logging_bucket_id}"
    bucket_prefix = "elb/${var.stackname}-draft-cache-internal-elb"
    interval      = 60
  }

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 443
    lb_protocol       = "https"

    ssl_certificate_id = "${data.aws_acm_certificate.elb_internal_cert.arn}"
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

  tags = "${map("Name", "${var.stackname}-draft-cache", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "draft_cache")}"
}

resource "aws_route53_record" "draft-cache_service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.internal_zone_id}"
  name    = "draft-cache.${data.terraform_remote_state.infra_stack_dns_zones.internal_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.draft-cache_elb.dns_name}"
    zone_id                = "${aws_elb.draft-cache_elb.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "draft-router-api_internal_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.internal_zone_id}"
  name    = "draft-router-api.${data.terraform_remote_state.infra_stack_dns_zones.internal_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.draft-cache_elb.dns_name}"
    zone_id                = "${aws_elb.draft-cache_elb.zone_id}"
    evaluate_target_health = true
  }
}

module "draft-cache" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-draft-cache"
  vpc_id                        = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "draft_cache", "aws_hostname", "draft-cache-1")}"
  instance_subnet_ids           = "${data.terraform_remote_state.infra_networking.private_subnet_ids}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_draft-cache_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "t2.medium"
  create_instance_key           = true
  instance_key_name             = "${var.stackname}-draft-cache"
  instance_public_key           = "${var.ssh_public_key}"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids              = ["${aws_elb.draft-cache_elb.id}"]
  instance_ami_filter_name      = "${var.instance_ami_filter_name}"
  asg_max_size                  = "2"
  asg_min_size                  = "2"
  asg_desired_capacity          = "2"
}

module "alarms-elb-draft-cache-internal" {
  source                         = "../../modules/aws/alarms/elb"
  name_prefix                    = "${var.stackname}-draft-cache-internal"
  alarm_actions                  = ["${data.terraform_remote_state.infra_stack_sns_alerts.sns_topic_alerts_arn}"]
  elb_name                       = "${aws_elb.draft-cache_elb.name}"
  httpcode_backend_4xx_threshold = "0"
  httpcode_backend_5xx_threshold = "100"
  httpcode_elb_4xx_threshold     = "100"
  httpcode_elb_5xx_threshold     = "100"
  surgequeuelength_threshold     = "0"
  healthyhostcount_threshold     = "0"
}

# Outputs
# --------------------------------------------------------------

output "draft-cache_elb_dns_name" {
  value       = "${aws_elb.draft-cache_elb.dns_name}"
  description = "DNS name to access the draft-cache service"
}

output "service_dns_name" {
  value       = "${aws_route53_record.draft-cache_service_record.fqdn}"
  description = "DNS name to access the service"
}

output "draft-router-api_internal_dns_name" {
  value       = "${aws_route53_record.draft-router-api_internal_record.fqdn}"
  description = "DNS name to access draft-router-api"
}
