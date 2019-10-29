/**
* ## Project: app-search
*
* Search application servers
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

variable "asg_max_size" {
  type        = "string"
  description = "The maximum size of the autoscaling group"
  default     = "2"
}

variable "asg_min_size" {
  type        = "string"
  description = "The minimum size of the autoscaling group"
  default     = "2"
}

variable "asg_desired_capacity" {
  type        = "string"
  description = "The desired capacity of the autoscaling group"
  default     = "2"
}

variable "elb_internal_certname" {
  type        = "string"
  description = "The ACM cert domain name to find the ARN of"
}

variable "app_service_records" {
  type        = "list"
  description = "List of application service names that get traffic via this loadbalancer"
  default     = []
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
  default     = "c5.large"
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

data "aws_acm_certificate" "elb_cert" {
  domain   = "${var.elb_internal_certname}"
  statuses = ["ISSUED"]
}

resource "aws_elb" "search_elb" {
  name            = "${var.stackname}-search"
  subnets         = ["${data.terraform_remote_state.infra_networking.private_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_search_elb_id}"]
  internal        = "true"

  access_logs {
    bucket        = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    bucket_prefix = "elb/${var.stackname}-search-internal-elb"
    interval      = 60
  }

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 443
    lb_protocol       = "https"

    ssl_certificate_id = "${data.aws_acm_certificate.elb_cert.arn}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3

    target   = "HTTP:80/_healthcheck_search-api"
    interval = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = "${map("Name", "${var.stackname}-search", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "search")}"
}

resource "aws_route53_record" "service_record" {
  zone_id = "${data.aws_route53_zone.internal.zone_id}"
  name    = "search.${var.internal_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.search_elb.dns_name}"
    zone_id                = "${aws_elb.search_elb.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "app_service_records" {
  count   = "${length(var.app_service_records)}"
  zone_id = "${data.aws_route53_zone.internal.zone_id}"
  name    = "${element(var.app_service_records, count.index)}.${var.internal_domain_name}"
  type    = "CNAME"
  records = ["search.${var.internal_domain_name}"]
  ttl     = "300"
}

module "search" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-search"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "search", "aws_hostname", "search-1")}"
  instance_subnet_ids           = "${data.terraform_remote_state.infra_networking.private_subnet_ids}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_search_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "${var.instance_type}"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids_length       = "1"
  instance_elb_ids              = ["${aws_elb.search_elb.id}"]
  instance_ami_filter_name      = "${var.instance_ami_filter_name}"
  asg_max_size                  = "${var.asg_max_size}"
  asg_min_size                  = "${var.asg_min_size}"
  asg_desired_capacity          = "${var.asg_desired_capacity}"
  asg_notification_topic_arn    = "${data.terraform_remote_state.infra_monitoring.sns_topic_autoscaling_group_events_arn}"
  asg_health_check_grace_period = "1200"
}

module "alarms-elb-search-internal" {
  source                         = "../../modules/aws/alarms/elb"
  name_prefix                    = "${var.stackname}-search-internal"
  alarm_actions                  = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  elb_name                       = "${aws_elb.search_elb.name}"
  httpcode_backend_4xx_threshold = "0"
  httpcode_backend_5xx_threshold = "100"
  httpcode_elb_4xx_threshold     = "100"
  httpcode_elb_5xx_threshold     = "100"
  surgequeuelength_threshold     = "0"
  healthyhostcount_threshold     = "0"
}

resource "aws_s3_bucket" "sitemaps_bucket" {
  bucket = "govuk-${var.aws_environment}-sitemaps"
  region = "${var.aws_region}"

  tags {
    Name            = "govuk-${var.aws_environment}-sitemaps"
    aws_environment = "${var.aws_environment}"
  }

  logging {
    target_bucket = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    target_prefix = "s3/govuk-${var.aws_environment}-sitemaps/"
  }

  lifecycle_rule {
    id      = "sitemaps_lifecycle_rule"
    prefix  = ""
    enabled = true

    expiration {
      days = 3
    }
  }
}

resource "aws_iam_role_policy_attachment" "sitemaps_bucket_access_iam_role_policy_attachment" {
  role       = "${module.search.instance_iam_role_name}"
  policy_arn = "${aws_iam_policy.sitemaps_bucket_access.arn}"
}

resource "aws_iam_policy" "sitemaps_bucket_access" {
  name        = "govuk-${var.aws_environment}-sitemaps-bucket-access-policy"
  policy      = "${data.aws_iam_policy_document.sitemaps_bucket_policy.json}"
  description = "Allows reading and writing of the sitemaps bucket"
}

data "aws_iam_policy_document" "sitemaps_bucket_policy" {
  statement {
    sid = "ReadListOfBuckets"

    actions = [
      "s3:ListAllMyBuckets",
    ]

    resources = ["*"]
  }

  statement {
    sid = "SitemapAccess"

    actions = [
      "s3:DeleteObject",
      "s3:Put*",
      "s3:Get*",
      "s3:List*",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.sitemaps_bucket.id}",
      "arn:aws:s3:::${aws_s3_bucket.sitemaps_bucket.id}/*",
    ]
  }
}

# s3 bucket for search relevancy

resource "aws_s3_bucket" "search_relevancy_bucket" {
  bucket = "govuk-${var.aws_environment}-search-relevancy"
  region = "${var.aws_region}"

  tags {
    Name            = "govuk-${var.aws_environment}-search-relevancy"
    aws_environment = "${var.aws_environment}"
  }

  logging {
    target_bucket = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    target_prefix = "s3/govuk-${var.aws_environment}-search-relevancy/"
  }
}

resource "aws_iam_role_policy_attachment" "search_relevancy_bucket_access_iam_role_policy_attachment" {
  role       = "${module.search.instance_iam_role_name}"
  policy_arn = "${aws_iam_policy.search_relevancy_bucket_access.arn}"
}

resource "aws_iam_policy" "search_relevancy_bucket_access" {
  name        = "govuk-${var.aws_environment}-search-relevancy-bucket-access-policy"
  policy      = "${data.aws_iam_policy_document.search_relevancy_bucket_policy.json}"
  description = "Allows reading and writing of the search relevancy bucket"
}

data "aws_iam_policy_document" "search_relevancy_bucket_policy" {
  statement {
    sid = "ReadListOfBuckets"

    actions = [
      "s3:ListAllMyBuckets",
    ]

    resources = ["*"]
  }

  statement {
    sid = "SearchRelevancyAccess"

    actions = [
      "s3:DeleteObject",
      "s3:Put*",
      "s3:Get*",
      "s3:List*",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.search_relevancy_bucket.id}",
      "arn:aws:s3:::${aws_s3_bucket.search_relevancy_bucket.id}/*",
    ]
  }
}

# Outputs
# --------------------------------------------------------------

output "search_elb_dns_name" {
  value       = "${aws_elb.search_elb.dns_name}"
  description = "DNS name to access the search service"
}

output "service_dns_name" {
  value       = "${aws_route53_record.service_record.name}"
  description = "DNS name to access the node service"
}
