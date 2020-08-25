/**
* ## Project: app-accessibility-reports
*
* Accessibility Reports
*
* Generates reports for the Accessibility Team, using the govuk-accessibility-reports repo
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

locals {
  mirror_bucket_name         = "govuk-staging-mirror"
  mirror_replica_bucket_name = "govuk-staging-mirror-replica"
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

data "aws_caller_identity" "current" {}

data "aws_ami" "ubuntu_bionic" {
  most_recent = true

  # canonical
  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

data "aws_iam_policy_document" "accessibility-reports_read_ssm_policy_document" {
  statement {
    actions = [
      "ssm:GetParameter",
    ]

    resources = [
      "arn:aws:ssm:eu-west-1:${data.aws_caller_identity.current.account_id}:parameter/govuk_accessibility_reports_github_deploy_key",
      "arn:aws:ssm:eu-west-1:${data.aws_caller_identity.current.account_id}:parameter/govuk_accessibility_reports_mirror_bucket_prefix",
    ]
  }
}

resource "aws_iam_policy" "accessibility-reports_read_ssm_policy" {
  name   = "accessibility-reports_read_ssm_policy"
  policy = "${data.aws_iam_policy_document.accessibility-reports_read_ssm_policy_document.json}"
}

data "template_file" "ec2_assume_policy_template" {
  template = "${file("${path.module}/../../policies/ec2_assume_policy.tpl")}"
}

resource "aws_iam_role" "govuk-accessibility-reports-data-reader_role" {
  name               = "govuk-accessibility-reports-data-reader"
  assume_role_policy = "${data.template_file.ec2_assume_policy_template.rendered}"
}

resource "aws_iam_role_policy_attachment" "accessibility-reports_read_ssm_role_attachment" {
  role       = "${aws_iam_role.govuk-accessibility-reports-data-reader_role.name}"
  policy_arn = "${aws_iam_policy.accessibility-reports_read_ssm_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "read_write_data_infrastructure_bucket_role_attachment" {
  role       = "${aws_iam_role.govuk-accessibility-reports-data-reader_role.name}"
  policy_arn = "${data.terraform_remote_state.app_knowledge_graph.read_write_data_infrastructure_bucket_policy_arn}"
}

data "aws_iam_policy_document" "accessibility-reports_read_s3_mirror_bucket_policy_document" {
  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::${local.mirror_bucket_name}",
      "arn:aws:s3:::${local.mirror_bucket_name}/*",
    ]
  }
}

data "aws_iam_policy_document" "accessibility-reports_read_s3_mirror_replica_bucket_policy_document" {
  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::${local.mirror_replica_bucket_name}",
      "arn:aws:s3:::${local.mirror_replica_bucket_name}/*",
    ]
  }
}

resource "aws_iam_policy" "accessibility-reports_read_s3_mirror_bucket_policy" {
  name   = "accessibility-reports_read_s3_mirror_bucket_policy"
  policy = "${data.aws_iam_policy_document.accessibility-reports_read_s3_mirror_bucket_policy_document.json}"
}

resource "aws_iam_policy" "accessibility-reports_read_s3_mirror_replica_bucket_policy" {
  name   = "accessibility-reports_read_s3_mirror_replica_bucket_policy"
  policy = "${data.aws_iam_policy_document.accessibility-reports_read_s3_mirror_replica_bucket_policy_document.json}"
}

resource "aws_iam_role_policy_attachment" "accessibility-reports_read_s3_mirror_bucket_role_attachment" {
  role       = "${aws_iam_role.govuk-accessibility-reports-data-reader_role.name}"
  policy_arn = "${aws_iam_policy.accessibility-reports_read_s3_mirror_bucket_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "accessibility-reports_read_s3_mirror_replica_bucket_role_attachment" {
  role       = "${aws_iam_role.govuk-accessibility-reports-data-reader_role.name}"
  policy_arn = "${aws_iam_policy.accessibility-reports_read_s3_mirror_replica_bucket_policy.arn}"
}

resource "aws_iam_instance_profile" "accessibility-reports_instance-profile" {
  name = "accessibility-reports_instance-profile"
  role = "${aws_iam_role.govuk-accessibility-reports-data-reader_role.name}"
}

data "template_file" "accessibility-reports_userdata" {
  template = "${file("${path.module}/userdata.tpl")}"

  vars {
    data_infrastructure_bucket_name = "${data.terraform_remote_state.app_knowledge_graph.data-infrastructure-bucket_name}"
    mirror_bucket_name              = "govuk-${var.aws_environment}-mirror-replica"
    data_science_base               = "${file("../../userdata/90-data-science-base")}"
  }
}

resource "aws_launch_template" "accessibility-reports_launch-template" {
  name          = "accessibility-reports_launch-template"
  image_id      = "${data.aws_ami.ubuntu_bionic.id}"
  instance_type = "r4.2xlarge"

  vpc_security_group_ids = [
    "${data.terraform_remote_state.infra_security_groups.sg_accessibility-reports_id}",
  ]

  iam_instance_profile {
    name = "${aws_iam_instance_profile.accessibility-reports_instance-profile.name}"
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

  user_data = "${base64encode(data.template_file.accessibility-reports_userdata.rendered)}"
}

resource "aws_autoscaling_group" "accessibility-reports-asg" {
  name             = "govuk-accessibility-reports"
  min_size         = 0
  max_size         = 1
  desired_capacity = 0

  launch_template {
    id      = "${aws_launch_template.accessibility-reports_launch-template.id}"
    version = "$Latest"
  }

  vpc_zone_identifier = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]

  tag {
    key                 = "Name"
    value               = "accessibility-reports"
    propagate_at_launch = true
  }
}
