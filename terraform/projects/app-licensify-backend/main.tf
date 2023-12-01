/**
* ## Project: app-licensify-backend
*
* Licensify Backend nodes
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
  description = "The domain name of the ACM cert to use for the internal LB"
}

variable "app_service_records" {
  type        = list(string)
  description = "List of application service names that get traffic via the internal LB"
  default     = []
}

variable "asg_size" {
  type        = string
  description = "The autoscaling group's desired/max/min capacity. licensify-feed can only have one master instance and mastership is manually configured."
  default     = "1"
}

variable "instance_type" {
  type        = string
  description = "Instance type used for EC2 resources"
  default     = "m5.large"
}

# Resources
# --------------------------------------------------------------
terraform {
  backend "s3" {}
  required_version = "= 0.11.15"
}

provider "aws" {
  region  = var.aws_region
  version = "2.46.0"
}

data "aws_route53_zone" "internal" {
  name         = data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name
  private_zone = true
}

data "aws_acm_certificate" "elb_internal_cert" {
  domain   = var.elb_internal_certname
  statuses = ["ISSUED"]
}

module "internal_lb" {
  source                           = "../../modules/aws/lb"
  name                             = "licensify-backend-internal"
  internal                         = true
  vpc_id                           = data.terraform_remote_state.infra_vpc.vpc_id
  access_logs_bucket_name          = data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id
  access_logs_bucket_prefix        = "elb/licensify-backend-internal-elb"
  listener_certificate_domain_name = var.elb_internal_certname
  target_group_health_check_path   = "/healthcheck"

  listener_action = {
    "HTTPS:443" = "HTTP:80"
  }

  subnets         = ["${data.terraform_remote_state.infra_networking.private_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_licensify-backend_internal_elb_id}"]
  alarm_actions   = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]

  default_tags = {
    Project         = "${var.stackname}"
    aws_migration   = "licensing_backend"
    aws_environment = "${var.aws_environment}"
  }
}

# For each service name (there is only licensify-admin for now), create DNS A
# records pointing at the internal LB.
resource "aws_route53_record" "internal_service_names" {
  count   = length(var.app_service_records)
  zone_id = data.aws_route53_zone.internal.zone_id
  name    = "${element(var.app_service_records, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "A"

  alias {
    name                   = module.internal_lb.lb_dns_name
    zone_id                = module.internal_lb.lb_zone_id
    evaluate_target_health = true
  }
}

module "licensify-backend" {
  source = "../../modules/aws/node_group"
  name   = "licensify-backend"

  default_tags = {
    Project         = "${var.stackname}"
    aws_stackname   = "${var.stackname}"
    aws_environment = "${var.aws_environment}"
    aws_migration   = "licensing_backend"
    aws_hostname    = "licensify-backend-1"
  }

  instance_subnet_ids               = data.terraform_remote_state.infra_networking.private_subnet_ids
  instance_security_group_ids       = ["${data.terraform_remote_state.infra_security_groups.sg_licensify-backend_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                     = var.instance_type
  instance_additional_user_data     = join("\n", null_resource.user_data.*.triggers.snippet)
  instance_target_group_arns_length = "1"
  instance_target_group_arns        = ["${module.internal_lb.target_group_arns[0]}"]
  instance_ami_filter_name          = var.instance_ami_filter_name
  asg_max_size                      = var.asg_size
  asg_min_size                      = var.asg_size
  asg_desired_capacity              = var.asg_size
  asg_notification_topic_arn        = data.terraform_remote_state.infra_monitoring.sns_topic_autoscaling_group_events_arn
  root_block_device_volume_size     = "50"
}

# Outputs
# --------------------------------------------------------------

output "licensify-backend_internal_elb_dns_name" {
  value       = module.internal_lb.lb_dns_name
  description = "Internal DNS name for the licensify-backend internal LB"
}
