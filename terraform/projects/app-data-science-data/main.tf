/**
* ## Project: app-data-science-data
*
* Data science data
*
* A central place where data is generated on a daily basis to be used by multiple data science projects, including related links and the knowledge graph.
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
  data_infrastructure_bucket_name = "${data.terraform_remote_state.app_knowledge_graph.data-infrastructure-bucket_name}"
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

data "aws_ami" "ubuntu_bionic" {
  most_recent = true

  # canonical
  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

resource "aws_iam_instance_profile" "data-science-data_instance_profile" {
  name = "${var.stackname}-data-science-data"
  role = "${aws_iam_role.data-science-data_role.name}"
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "data-science-data_read_ssm_policy_document" {
  statement {
    actions = [
      "ssm:GetParameter",
    ]

    resources = [
      "arn:aws:ssm:eu-west-1:${data.aws_caller_identity.current.account_id}:parameter/govuk_knowledge_graph_github_deploy_key",
      "arn:aws:ssm:eu-west-1:${data.aws_caller_identity.current.account_id}:parameter/govuk_big_query_data_service_user_key_file",
      "arn:aws:ssm:eu-west-1:${data.aws_caller_identity.current.account_id}:parameter/govuk_knowledge_graph_publishing_api_host",
      "arn:aws:ssm:eu-west-1:${data.aws_caller_identity.current.account_id}:parameter/govuk_knowledge_graph_publishing_api_database",
      "arn:aws:ssm:eu-west-1:${data.aws_caller_identity.current.account_id}:parameter/govuk_knowledge_graph_publishing_api_user",
      "arn:aws:ssm:eu-west-1:${data.aws_caller_identity.current.account_id}:parameter/govuk_knowledge_graph_publishing_api_password",
    ]
  }
}

data "aws_iam_policy_document" "invoke_sagemaker_govner_endpoint_policy_document" {
  statement {
    actions = [
      "sagemaker:InvokeEndpoint",
    ]

    resources = [
      "arn:aws:sagemaker:eu-west-1:${data.aws_caller_identity.current.account_id}:endpoint/govner-endpoint",
    ]
  }
}

resource "aws_iam_policy" "data-science-data_read_ssm_policy" {
  name   = "data-science-data_read_ssm_policy"
  policy = "${data.aws_iam_policy_document.data-science-data_read_ssm_policy_document.json}"
}

resource "aws_iam_policy" "invoke_sagemaker_govner_endpoint_policy" {
  name   = "invoke_sagemaker_govner_endpoint_policy"
  policy = "${data.aws_iam_policy_document.invoke_sagemaker_govner_endpoint_policy_document.json}"
}

resource "aws_iam_role_policy_attachment" "data-science-data_read_ssm_role_attachment" {
  role       = "${aws_iam_role.data-science-data_role.name}"
  policy_arn = "${aws_iam_policy.data-science-data_read_ssm_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "invoke_sagemaker_govner_endpoint_role_attachment" {
  role       = "${aws_iam_role.data-science-data_role.name}"
  policy_arn = "${aws_iam_policy.invoke_sagemaker_govner_endpoint_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "read_write_data_infrastructure_bucket_role_attachment" {
  role       = "${aws_iam_role.data-science-data_role.name}"
  policy_arn = "${data.terraform_remote_state.app_knowledge_graph.read_write_data_infrastructure_bucket_policy_arn}"
}

resource "aws_iam_role_policy_attachment" "data-science-data_read_content_store_backups_bucket_role_attachment" {
  role       = "${aws_iam_role.data-science-data_role.name}"
  policy_arn = "${data.terraform_remote_state.app_related_links.policy_read_content_store_backups_bucket_policy_arn}"
}

resource "aws_iam_role_policy_attachment" "data-science-data_read_related_links_bucket_role_attachment" {
  role       = "${aws_iam_role.data-science-data_role.name}"
  policy_arn = "${data.terraform_remote_state.app_related_links.policy_read_write_related_links_bucket_policy_arn}"
}

resource "aws_iam_role" "data-science-data_role" {
  name               = "${var.stackname}-data-science-data"
  assume_role_policy = "${data.template_file.ec2_assume_policy_template.rendered}"
}

data "template_file" "ec2_assume_policy_template" {
  template = "${file("${path.module}/../../policies/ec2_assume_policy.tpl")}"
}

data "template_file" "data-science-data_userdata" {
  template = "${file("${path.module}/userdata.tpl")}"

  vars {
    database_backups_bucket_name    = "${data.terraform_remote_state.infra_database_backups_bucket.s3_database_backups_bucket_name}"
    data_infrastructure_bucket_name = "${data.terraform_remote_state.app_knowledge_graph.data-infrastructure-bucket_name}"
  }
}

resource "aws_launch_template" "data-science-data_launch_template" {
  name     = "data-science-data_launch-template"
  image_id = "${data.aws_ami.ubuntu_bionic.id}"

  instance_type = "r4.2xlarge"

  vpc_security_group_ids = ["${data.terraform_remote_state.infra_security_groups.sg_data-science-data_id}"]

  iam_instance_profile {
    name = "${aws_iam_instance_profile.data-science-data_instance_profile.name}"
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

  user_data = "${base64encode(data.template_file.data-science-data_userdata.rendered)}"
}

resource "aws_autoscaling_group" "data-science-data_asg" {
  name             = "${var.stackname}_data-science-data"
  min_size         = 0
  max_size         = 1
  desired_capacity = 0

  launch_template {
    id      = "${aws_launch_template.data-science-data_launch_template.id}"
    version = "$Latest"
  }

  vpc_zone_identifier = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]

  tag {
    key                 = "Name"
    value               = "${var.stackname}_data-science-data"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_schedule" "data-science-data_schedule-spin-up" {
  autoscaling_group_name = "${aws_autoscaling_group.data-science-data_asg.name}"
  scheduled_action_name  = "data-science-data_schedule-spin-up"
  recurrence             = "30 8 * * MON-SUN"
  min_size               = -1
  max_size               = -1
  desired_capacity       = 1
}

resource "aws_autoscaling_schedule" "data-science-data_schedule-spin-down" {
  autoscaling_group_name = "${aws_autoscaling_group.data-science-data_asg.name}"
  scheduled_action_name  = "data-science-data_schedule-spin-down"
  recurrence             = "29 10 * * MON-SUN"
  min_size               = -1
  max_size               = -1
  desired_capacity       = 0
}
