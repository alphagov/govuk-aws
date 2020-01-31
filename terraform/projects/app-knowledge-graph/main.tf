/**
* ## Project: app-knowledge-graph
*
* Knowledge graph
*
* The central knowledge graph which can be used to ask questions of GOV.UK content.
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

variable "stackname" {
  type        = "string"
  description = "Stackname"
}

variable "external_zone_name" {
  type        = "string"
  description = "The name of the Route53 zone that contains external records"
}

variable "external_domain_name" {
  type        = "string"
  description = "The domain name of the external DNS records, it could be different from the zone name"
}

variable "elb_external_certname" {
  type        = "string"
  description = "The ACM cert domain name to find the ARN of"
}

locals {
  data_infrastructure_bucket_name = "govuk-data-infrastructure-${var.aws_environment}"
}

# Resources
# --------------------------------------------------------------

terraform {
  backend          "s3"             {}
  required_version = "= 0.11.14"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "1.40.0"
}

resource "aws_s3_bucket" "data_infrastructure_bucket" {
  bucket = "${local.data_infrastructure_bucket_name}"

  versioning {
    enabled = true
  }

  tags {
    aws_environment = "${var.aws_environment}"
    Name            = "${local.data_infrastructure_bucket_name}"
  }
}

data "aws_ami" "neo4j_community_ami" {
  most_recent = true

  # canonical
  owners = ["679593333241"]

  filter {
    name   = "name"
    values = ["neo4j-community-*"]
  }
}

data "aws_route53_zone" "external" {
  name         = "${var.external_zone_name}"
  private_zone = false
}

data "aws_acm_certificate" "elb_external_cert" {
  domain   = "${var.elb_external_certname}"
  statuses = ["ISSUED"]
}

resource "aws_iam_instance_profile" "knowledge-graph_instance_profile" {
  name = "${var.stackname}-knowledge-graph"
  role = "${aws_iam_role.knowledge-graph_role.name}"
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "knowledge-graph_read_ssm_policy_document" {
  statement {
    actions = [
      "ssm:GetParameter",
    ]

    resources = [
      "arn:aws:ssm:eu-west-1:${data.aws_caller_identity.current.account_id}:parameter/govuk_knowledge_graph_github_deploy_key",
      "arn:aws:ssm:eu-west-1:${data.aws_caller_identity.current.account_id}:parameter/govuk_knowledge_graph_shared_password",
      "arn:aws:ssm:eu-west-1:${data.aws_caller_identity.current.account_id}:parameter/govuk_big_query_data_service_user_key_file",
      "arn:aws:ssm:eu-west-1:${data.aws_caller_identity.current.account_id}:parameter/govuk_knowledge_graph_publishing_api_host",
      "arn:aws:ssm:eu-west-1:${data.aws_caller_identity.current.account_id}:parameter/govuk_knowledge_graph_publishing_api_database",
      "arn:aws:ssm:eu-west-1:${data.aws_caller_identity.current.account_id}:parameter/govuk_knowledge_graph_publishing_api_user",
      "arn:aws:ssm:eu-west-1:${data.aws_caller_identity.current.account_id}:parameter/govuk_knowledge_graph_publishing_api_password",
      "arn:aws:ssm:eu-west-1:${data.aws_caller_identity.current.account_id}:parameter/govuk_knowledge_graph_bolt_endpoint",
      "arn:aws:ssm:eu-west-1:${data.aws_caller_identity.current.account_id}:parameter/govuk_knowledge_graph_https_endpoint",
    ]
  }
}

data "aws_iam_policy_document" "knowledge-graph_register_instance_with_elb_policy_document" {
  statement {
    actions = [
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
    ]

    resources = [
      "${aws_elb.knowledge-graph_elb_external.arn}",
    ]
  }
}

data "aws_iam_policy_document" "read_write_data_infrastructure_bucket_policy_document" {
  statement {
    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${local.data_infrastructure_bucket_name}",
    ]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:CreateMultipartUpload",
    ]

    resources = [
      "arn:aws:s3:::${local.data_infrastructure_bucket_name}/*",
    ]
  }
}

resource "aws_iam_policy" "knowledge-graph_register_instance_with_elb_policy" {
  name   = "knowledge-graph_register_instance_with_elb_policy"
  policy = "${data.aws_iam_policy_document.knowledge-graph_register_instance_with_elb_policy_document.json}"
}

resource "aws_iam_policy" "knowledge-graph_read_ssm_policy" {
  name   = "knowledge-graph_read_ssm_policy"
  policy = "${data.aws_iam_policy_document.knowledge-graph_read_ssm_policy_document.json}"
}

resource "aws_iam_policy" "read_write_data_infrastructure_bucket_policy" {
  name   = "read_write_data_infrastructure_bucket_policy"
  policy = "${data.aws_iam_policy_document.read_write_data_infrastructure_bucket_policy_document.json}"
}

resource "aws_iam_role_policy_attachment" "knowledge-graph_register_instance_with_elb_role_attachment" {
  role       = "${aws_iam_role.knowledge-graph_role.name}"
  policy_arn = "${aws_iam_policy.knowledge-graph_register_instance_with_elb_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "knowledge-graph_read_ssm_role_attachment" {
  role       = "${aws_iam_role.knowledge-graph_role.name}"
  policy_arn = "${aws_iam_policy.knowledge-graph_read_ssm_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "read_write_data_infrastructure_bucket_role_attachment" {
  role       = "${aws_iam_role.knowledge-graph_role.name}"
  policy_arn = "${aws_iam_policy.read_write_data_infrastructure_bucket_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "knowledge-graph_read_content_store_backups_bucket_role_attachment" {
  role       = "${aws_iam_role.knowledge-graph_role.name}"
  policy_arn = "${data.terraform_remote_state.app_related_links.policy_read_content_store_backups_bucket_policy_arn}"
}

resource "aws_iam_role_policy_attachment" "knowledge-graph_read_related_links_bucket_role_attachment" {
  role       = "${aws_iam_role.knowledge-graph_role.name}"
  policy_arn = "${data.terraform_remote_state.app_related_links.policy_read_write_related_links_bucket_policy_arn}"
}

resource "aws_iam_role" "knowledge-graph_role" {
  name               = "${var.stackname}-knowledge-graph"
  assume_role_policy = "${data.template_file.ec2_assume_policy_template.rendered}"
}

data "template_file" "ec2_assume_policy_template" {
  template = "${file("${path.module}/../../policies/ec2_assume_policy.tpl")}"
}

data "template_file" "knowledge-graph_userdata" {
  template = "${file("${path.module}/userdata.tpl")}"

  vars {
    elb_name                        = "${aws_elb.knowledge-graph_elb_external.name}"
    database_backups_bucket_name    = "${data.terraform_remote_state.infra_database_backups_bucket.s3_database_backups_bucket_name}"
    data_infrastructure_bucket_name = "${aws_s3_bucket.data_infrastructure_bucket.id}"
    related_links_bucket_name       = "govuk-related-links-${var.aws_environment}"
  }
}

resource "aws_launch_template" "knowledge-graph_launch_template" {
  name     = "knowledge-graph_launch-template"
  image_id = "${data.aws_ami.neo4j_community_ami.id}"

  instance_type = "r4.2xlarge"

  vpc_security_group_ids = ["${data.terraform_remote_state.infra_security_groups.sg_knowledge-graph_id}"]

  iam_instance_profile {
    name = "${aws_iam_instance_profile.knowledge-graph_instance_profile.name}"
  }

  instance_initiated_shutdown_behavior = "terminate"

  lifecycle {
    create_before_destroy = true
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 64
    }
  }

  user_data = "${base64encode(data.template_file.knowledge-graph_userdata.rendered)}"
}

resource "aws_autoscaling_group" "knowledge-graph_asg" {
  name             = "${var.stackname}_knowledge-graph"
  min_size         = 0
  max_size         = 1
  desired_capacity = 1

  launch_template {
    id      = "${aws_launch_template.knowledge-graph_launch_template.id}"
    version = "$Latest"
  }

  vpc_zone_identifier = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]

  tag {
    key                 = "Name"
    value               = "${var.stackname}_knowledge-graph"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_schedule" "knowledge-graph_schedule-spin-up" {
  autoscaling_group_name = "${aws_autoscaling_group.knowledge-graph_asg.name}"
  scheduled_action_name  = "knowledge-graph_schedule-spin-up"
  recurrence             = "0 9 * * MON-SUN"
  min_size               = -1
  max_size               = -1
  desired_capacity       = 1
}

resource "aws_autoscaling_schedule" "knowledge-graph_schedule-spin-down" {
  autoscaling_group_name = "${aws_autoscaling_group.knowledge-graph_asg.name}"
  scheduled_action_name  = "knowledge-graph_schedule-spin-down"
  recurrence             = "55 17 * * MON-FRI"
  min_size               = -1
  max_size               = -1
  desired_capacity       = 0
}

resource "aws_autoscaling_schedule" "knowledge-graph_schedule-spin-down-weekend" {
  autoscaling_group_name = "${aws_autoscaling_group.knowledge-graph_asg.name}"
  scheduled_action_name  = "knowledge-graph_schedule-spin-down-weekend"
  recurrence             = "55 9 * * SAT-SUN"
  min_size               = -1
  max_size               = -1
  desired_capacity       = 0
}

resource "aws_route53_record" "knowledge_graph_service_record_external" {
  zone_id = "${data.aws_route53_zone.external.zone_id}"
  name    = "knowledge-graph.${var.external_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.knowledge-graph_elb_external.dns_name}"
    zone_id                = "${aws_elb.knowledge-graph_elb_external.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_elb" "knowledge-graph_elb_external" {
  name     = "${var.stackname}-knowledge-graph-external"
  internal = false

  listener {
    instance_port     = 22
    instance_protocol = "tcp"
    lb_port           = 22
    lb_protocol       = "tcp"
  }

  listener {
    instance_port      = 3000
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "${data.aws_acm_certificate.elb_external_cert.arn}"
  }

  listener {
    instance_port      = 7473
    instance_protocol  = "https"
    lb_port            = 7473
    lb_protocol        = "https"
    ssl_certificate_id = "${data.aws_acm_certificate.elb_external_cert.arn}"
  }

  listener {
    instance_port      = 7687
    instance_protocol  = "ssl"
    lb_port            = 7687
    lb_protocol        = "ssl"
    ssl_certificate_id = "${data.aws_acm_certificate.elb_external_cert.arn}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    target              = "TCP:7687"
    interval            = 30
    timeout             = 10
  }

  subnets = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]

  security_groups = [
    "${data.terraform_remote_state.infra_security_groups.sg_knowledge-graph_elb_external_id}",
    "${data.terraform_remote_state.infra_security_groups.sg_offsite_ssh_id}",
  ]

  tags {
    Name = "${var.stackname}-knowledge-graph-external"
  }
}
