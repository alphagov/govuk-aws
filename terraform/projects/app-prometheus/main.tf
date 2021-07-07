/*
* ## Project: app-prometheus
*
* Prometheus node
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

  #  default     = "ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"
  default = "ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"
}

variable "prometheus_1_subnet" {
  type        = "string"
  description = "Name of the subnet to place the Prometheus instance and EBS volume"
}

variable "instance_type" {
  type        = "string"
  description = "Instance type used for EC2 resources"
  default     = "t3.medium"
}

variable "elb_internal_certname" {
  type        = "string"
  description = "The ACM cert domain name (e.g. *.production.govuk-internal.digital) to find the ARN of"
}

variable "internal_zone_name" {
  type        = "string"
  description = "The name of the Route53 zone that contains internal records"
}

variable "internal_domain_name" {
  type        = "string"
  description = "The domain name of the internal DNS records, it could be different from the zone name"
}

variable "ebs_volume_size" {
  type        = "string"
  description = "EBS volume size"
  default     = "64"
}

# Resources
# --------------------------------------------------------------
terraform {
  backend          "s3"             {}
  required_version = "= 0.11.14"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "2.46.0"
}

module "prometheus-1" {
  source       = "../../modules/aws/node_group"
  name         = "${var.stackname}-prometheus-1"
  default_tags = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment",
var.aws_environment, "aws_migration", "prometheus", "aws_hostname", "prometheus-1")}"

  instance_subnet_ids = "${matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map),
keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.prometheus_1_subnet))}"

  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_prometheus_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "${var.instance_type}"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_ami_filter_name      = "${var.instance_ami_filter_name}"
  asg_notification_topic_arn    = "${data.terraform_remote_state.infra_monitoring.sns_topic_autoscaling_group_events_arn}"
}

resource "aws_ebs_volume" "prometheus-1" {
  availability_zone = "${lookup(data.terraform_remote_state.infra_networking.private_subnet_names_azs_map, var.prometheus_1_subnet)}"
  size              = "${var.ebs_volume_size}"
  type              = "gp3"

  tags {
    Name            = "${var.stackname}-prometheus-1"
    Project         = "${var.stackname}"
    Device          = "xvdf"
    aws_stackname   = "${var.stackname}"
    aws_environment = "${var.aws_environment}"
    aws_migration   = "prometheus"
    aws_hostname    = "prometheus-1"
  }
}

data "aws_route53_zone" "internal" {
  name         = "${var.internal_zone_name}"
  private_zone = true
}

data "aws_acm_certificate" "elb_internal_cert" {
  domain   = "${var.elb_internal_certname}"
  statuses = ["ISSUED"]
}

module "prometheus_internal_alb" {
  source                           = "../../modules/aws/lb"
  name                             = "${var.stackname}-prometheus-internal"
  internal                         = true
  vpc_id                           = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  access_logs_bucket_name          = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  access_logs_bucket_prefix        = "elb/${var.stackname}-prometheus-internal-alb"
  listener_certificate_domain_name = "${var.elb_internal_certname}"
  listener_action                  = "${map("HTTPS:443", "HTTP:80")}"
  subnets                          = ["${data.terraform_remote_state.infra_networking.private_subnet_ids}"]
  target_group_health_check_path   = "/-/ready"                                                              # See https://prometheus.io/docs/prometheus/latest/management_api/

  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_prometheus_internal_elb_id}"]
  alarm_actions   = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  default_tags    = "${map("Project", var.stackname, "aws_migration", "prometheus", "aws_environment", var.aws_environment)}"
}

resource "aws_autoscaling_attachment" "internal_lb" {
  autoscaling_group_name = "${module.prometheus-1.autoscaling_group_name}"
  alb_target_group_arn   = "${module.prometheus_internal_alb.target_group_arns[0]}"
}

resource "aws_lb_listener_rule" "internal_lb" {
  listener_arn = "${module.prometheus_internal_alb.load_balancer_ssl_listeners[0]}"

  action {
    type             = "forward"
    target_group_arn = "${module.prometheus_internal_alb.target_group_arns[0]}"
  }

  condition {
    field  = "host-header"
    values = ["prometheus.${var.internal_domain_name}"]
  }
}

resource "aws_route53_record" "service_record_internal" {
  zone_id = "${data.aws_route53_zone.internal.zone_id}"
  name    = "prometheus.${var.internal_domain_name}"
  type    = "A"

  alias {
    name                   = "${module.prometheus_internal_alb.lb_dns_name}"
    zone_id                = "${module.prometheus_internal_alb.lb_zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_iam_policy" "prometheus_1_iam_policy" {
  name   = "${var.stackname}-prometheus-1-additional"
  path   = "/"
  policy = "${file("${path.module}/additional_policy.json")}"
}

resource "aws_iam_role_policy_attachment" "prometheus_1_iam_role_policy_attachment" {
  role       = "${module.prometheus-1.instance_iam_role_name}"
  policy_arn = "${aws_iam_policy.prometheus_1_iam_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "prometheus_1_iam_role_policy_cloudwatch_attachment" {
  role       = "${module.prometheus-1.instance_iam_role_name}"
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
}
