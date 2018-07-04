/*
* ## Project: infr-prometheus
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
  default     = "ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20180522"
}

variable "prometheus_1_subnet" {
  type        = "string"
  description = "Name of the subnet to place the Prometheus instance and EBS volume"
}

variable "elb_external_cert" {
  type        = "string"
  description = "Name of the name of domain" 
}


# Resources
# --------------------------------------------------------------
terraform {
  backend          "s3"             {}
  required_version = "= 0.11.7"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "1.14.0"
}

data "aws_acm_certificate" "elb_external_cert" {
  domain   = "${var.elb_external_certname}"
  statuses = ["ISSUED"]
}

resource "aws_elb" "prometheus_external_elb" {
  name            = "${var.stackname}-prometheus-external"
  subnets         = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_prometheus_external_elb_id}"]

  internal = "false"

  access_logs {
    bucket        = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    bucket_prefix = "elb/${var.stackname}-prometheus-external-elb"
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

  tags = "${map("Name", "${var.stackname}-prometheus-external",
"Project", var.stackname, "aws_environment", var.aws_environment,
"aws_migration", "prometheus")}"
}

resource "aws_route53_record" "prometheus_external_service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.external_zone_id}"
  name    = "prometheus.${data.terraform_remote_state.infra_stack_dns_zones.external_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.prometheus_external_elb.dns_name}"
    zone_id                = "${aws_elb.prometheus.prometheus_external_elb.zone_id}"
    evaluate_target_health = true
  }
}

module "prometheus-1" {
  source       = "../../modules/aws/node_group"
  name         = "${var.stackname}-prometheus-1"
  vpc_id       = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment",
var.aws_environment, "aws_migration", "promtheus", "aws_hostname", "prometheus-1")}"

  instance_subnet_ids = "${matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map),
keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.prometheus_1_subnet))}"

  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_prometheus_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "t2.micro"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids_length       = "1"
  instance_elb_ids              = ["${aws_elb.prometheus_external_elb.id}"]
  instance_ami_filter_name      = "${var.instance_ami_filter_name}"
  asg_notification_topic_arn    = "${data.terraform_remote_state.infra_monitoring.sns_topic_autoscaling_group_events_arn}"
}

resource "aws_ebs_volume" "prometheus-1" {
  availability_zone = "${lookup(data.terraform_remote_state.infra_networking.private_subnet_names_azs_map, var.prometheus_1_subnet)}"
  size              = 64
  type              = "gp2"

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

# Outputs
# --------------------------------------------------------------

output "prometheus_external_elb_dns_name" {
  value       = "${aws_route53_record.prometheus_external_service_record.fqdn}"
  description = "DNS name to access the Prometheus external service"
}
