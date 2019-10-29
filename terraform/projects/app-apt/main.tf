/**
* ## Project: app-apt
*
* Apt node
*/
variable "aws_environment" {
  type        = "string"
  description = "AWS environment"
}

variable "aws_region" {
  type        = "string"
  description = "AWS region"
  default     = "eu-west-1"
}

variable "ebs_encrypted" {
  type        = "string"
  description = "Whether or not the EBS volume is encrypted"
}

variable "stackname" {
  type        = "string"
  description = "Stackname"
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

variable "apt_1_subnet" {
  type        = "string"
  description = "Name of the subnet to place the apt instance 1 and EBS volume"
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

locals {
  external_lb_map = {
    "HTTPS:443" = "HTTP:80"
  }

  internal_lb_map = {
    "HTTPS:443" = "HTTP:80"
    "HTTP:80"   = "HTTP:80"
  }
}

module "apt_external_lb" {
  source                                     = "../../modules/aws/lb"
  name                                       = "${var.stackname}-apt-external"
  internal                                   = false
  vpc_id                                     = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  access_logs_bucket_name                    = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  access_logs_bucket_prefix                  = "elb/${var.stackname}-apt-external-elb"
  listener_certificate_domain_name           = "${var.elb_external_certname}"
  listener_secondary_certificate_domain_name = ""
  listener_action                            = "${local.external_lb_map}"
  subnets                                    = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups                            = ["${data.terraform_remote_state.infra_security_groups.sg_apt_external_elb_id}"]
  alarm_actions                              = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  target_group_health_check_path             = "/"
  target_group_health_check_matcher          = "200-499"
  default_tags                               = "${map("Project", var.stackname, "aws_migration", "apt", "aws_environment", var.aws_environment)}"
}

resource "aws_route53_record" "apt_external_service_record" {
  zone_id = "${data.aws_route53_zone.external.zone_id}"
  name    = "apt.${var.external_domain_name}"
  type    = "A"

  alias {
    name                   = "${module.apt_external_lb.lb_dns_name}"
    zone_id                = "${module.apt_external_lb.lb_zone_id}"
    evaluate_target_health = true
  }
}

module "apt_internal_lb" {
  source                                     = "../../modules/aws/lb"
  name                                       = "${var.stackname}-apt-internal"
  internal                                   = true
  vpc_id                                     = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  access_logs_bucket_name                    = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  access_logs_bucket_prefix                  = "elb/${var.stackname}-apt-internal-elb"
  listener_certificate_domain_name           = "${var.elb_internal_certname}"
  listener_secondary_certificate_domain_name = ""
  listener_action                            = "${local.internal_lb_map}"
  subnets                                    = ["${data.terraform_remote_state.infra_networking.private_subnet_ids}"]
  security_groups                            = ["${data.terraform_remote_state.infra_security_groups.sg_apt_internal_elb_id}"]
  alarm_actions                              = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  target_group_health_check_path             = "/"
  target_group_health_check_matcher          = "200-499"
  default_tags                               = "${map("Project", var.stackname, "aws_migration", "apt", "aws_environment", var.aws_environment)}"
}

resource "aws_route53_record" "gemstash_internal_service_record" {
  zone_id = "${data.aws_route53_zone.internal.zone_id}"
  name    = "gemstash.${var.internal_domain_name}"
  type    = "A"

  alias {
    name                   = "${module.apt_internal_lb.lb_dns_name}"
    zone_id                = "${module.apt_internal_lb.lb_zone_id}"
    evaluate_target_health = true
  }
}

module "apt" {
  source                            = "../../modules/aws/node_group"
  name                              = "${var.stackname}-apt"
  default_tags                      = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "apt", "aws_hostname", "apt-1")}"
  instance_subnet_ids               = "${matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.apt_1_subnet))}"
  instance_security_group_ids       = ["${data.terraform_remote_state.infra_security_groups.sg_apt_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                     = "${var.instance_type}"
  instance_additional_user_data     = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_target_group_arns        = ["${concat(module.apt_internal_lb.target_group_arns, module.apt_external_lb.target_group_arns)}"]
  instance_target_group_arns_length = "${length(distinct(values(local.external_lb_map))) + length(distinct(values(local.internal_lb_map)))}"
  instance_ami_filter_name          = "${var.instance_ami_filter_name}"
  asg_notification_topic_arn        = "${data.terraform_remote_state.infra_monitoring.sns_topic_autoscaling_group_events_arn}"
  root_block_device_volume_size     = "20"
}

resource "aws_ebs_volume" "apt" {
  availability_zone = "${lookup(data.terraform_remote_state.infra_networking.private_subnet_names_azs_map, var.apt_1_subnet)}"
  encrypted         = "${var.ebs_encrypted}"
  size              = 40
  type              = "gp2"

  tags {
    Name            = "${var.stackname}-apt"
    Project         = "${var.stackname}"
    Device          = "xvdf"
    aws_hostname    = "apt-1"
    aws_migration   = "apt"
    aws_stackname   = "${var.stackname}"
    aws_environment = "${var.aws_environment}"
  }
}

resource "aws_iam_policy" "apt_1_iam_policy" {
  name   = "${var.stackname}-apt-additional"
  path   = "/"
  policy = "${file("${path.module}/additional_policy.json")}"
}

resource "aws_iam_role_policy_attachment" "apt_1_iam_role_policy_attachment" {
  role       = "${module.apt.instance_iam_role_name}"
  policy_arn = "${aws_iam_policy.apt_1_iam_policy.arn}"
}

# Outputs
# --------------------------------------------------------------

output "apt_external_service_dns_name" {
  value       = "${aws_route53_record.apt_external_service_record.fqdn}"
  description = "DNS name to access the Apt external service"
}

output "gemstash_internal_elb_dns_name" {
  value       = "${aws_route53_record.gemstash_internal_service_record.fqdn}"
  description = "DNS name to access the Gemstash internal service"
}
