/**
* ## Project: app-gatling
*
* Gatling node
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

variable "asg_desired_capacity" {
  type        = "string"
  description = "The autoscaling groups desired capacity"
  default     = "0"
}

variable "asg_max_size" {
  type        = "string"
  description = "The autoscaling groups max_size"
  default     = "0"
}

variable "asg_min_size" {
  type        = "string"
  description = "The autoscaling groups max_size"
  default     = "0"
}

variable "ebs_encrypted" {
  type        = "string"
  description = "Whether or not the EBS volume is encrypted"
}

variable "elb_external_certname" {
  type        = "string"
  description = "The ACM cert domain name to find the ARN of"
}

variable "external_zone_name" {
  type        = "string"
  description = "The name of the Route53 zone that contains external records"
}

variable "external_domain_name" {
  type        = "string"
  description = "The domain name of the external DNS records, it could be different from the zone name"
}

variable "instance_ami_filter_name" {
  type        = "string"
  description = "Name to use to find AMI images"
  default     = ""
}

variable "instance_type" {
  type        = "string"
  description = "Instance type used for EC2 resources"
  default     = "m5.2xlarge"
}

variable "office_ips" {
  type        = "list"
  description = "An array of CIDR blocks that will be allowed offsite access."
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

locals {
  external_lb_map = {
    "HTTPS:443" = "HTTP:80"
  }
}

module "gatling_external_lb" {
  source                                     = "../../modules/aws/lb"
  name                                       = "${var.stackname}-gatling-external"
  internal                                   = false
  vpc_id                                     = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  access_logs_bucket_name                    = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  access_logs_bucket_prefix                  = "elb/${var.stackname}-gatling-external-elb"
  listener_certificate_domain_name           = "${var.elb_external_certname}"
  listener_secondary_certificate_domain_name = ""
  listener_action                            = "${local.external_lb_map}"
  subnets                                    = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups                            = ["${data.terraform_remote_state.infra_security_groups.sg_gatling_external_elb_id}"]
  alarm_actions                              = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  target_group_health_check_path             = "/"
  target_group_health_check_matcher          = "200-499"
  default_tags                               = "${map("Project", var.stackname, "aws_migration", "gatling", "aws_environment", var.aws_environment)}"
}

resource "aws_route53_record" "gatling_external_service_record" {
  zone_id = "${data.aws_route53_zone.external.zone_id}"
  name    = "gatling.${var.external_domain_name}"
  type    = "A"

  alias {
    name                   = "${module.gatling_external_lb.lb_dns_name}"
    zone_id                = "${module.gatling_external_lb.lb_zone_id}"
    evaluate_target_health = true
  }
}

module "gatling" {
  source                            = "../../modules/aws/node_group"
  name                              = "${var.stackname}-gatling"
  default_tags                      = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "gatling", "aws_hostname", "gatling-1")}"
  instance_subnet_ids               = "${data.terraform_remote_state.infra_networking.private_subnet_ids}"
  instance_security_group_ids       = ["${data.terraform_remote_state.infra_security_groups.sg_gatling_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                     = "${var.instance_type}"
  instance_additional_user_data     = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids_length           = "0"
  instance_elb_ids                  = []
  instance_ami_filter_name          = "${var.instance_ami_filter_name}"
  asg_max_size                      = "${var.asg_max_size}"
  asg_min_size                      = "${var.asg_min_size}"
  asg_desired_capacity              = "${var.asg_desired_capacity}"
  asg_notification_topic_arn        = "${data.terraform_remote_state.infra_monitoring.sns_topic_autoscaling_group_events_arn}"
  instance_target_group_arns        = "${module.gatling_external_lb.target_group_arns}"
  instance_target_group_arns_length = "${length(distinct(values(local.external_lb_map)))}"
  root_block_device_volume_size     = "30"
}

# S3 Bucket to store results
resource "aws_s3_bucket" "results" {
  bucket = "gatling-results-${var.aws_environment}"

  website {
    index_document = "index.html"
  }
}

resource "aws_s3_bucket_policy" "results" {
  bucket = "${aws_s3_bucket.results.id}"
  policy = "${data.aws_iam_policy_document.results_bucket_access.json}"
}

data "aws_iam_policy_document" "results_bucket_access" {
  statement {
    sid     = "ReadResultsFromOffice"
    actions = ["s3:GetObject", "s3:ListBucket"]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.results.id}",
      "arn:aws:s3:::${aws_s3_bucket.results.id}/*",
    ]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = ["${var.office_ips}"]
    }

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}

# Outputs
# --------------------------------------------------------------

output "instance_iam_role_name" {
  value       = "${module.gatling.instance_iam_role_name}"
  description = "name of the instance iam role"
}
