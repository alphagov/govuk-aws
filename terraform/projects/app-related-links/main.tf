/**
* ## Project: app-related-links
*
* Related Links
*
* Run resource intensive scripts for data science purposes.
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

variable "jenkins_ssh_public_key" {
  type        = "string"
  description = "Jenkins SSH public key"
}

locals {
  content_store_bucket_name = "${data.terraform_remote_state.infra_database_backups_bucket.s3_database_backups_bucket_name}"
  related_links_bucket_name = "govuk-related-links-${var.aws_environment}"
}

# Resources
# --------------------------------------------------------------

terraform {
  backend          "s3"             {}
  required_version = "= 0.11.15"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "1.40.0"
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_secretsmanager_secret" "secret_big_query_service_account_key" {
  name = "related_links-BIG_QUERY_SERVICE_ACCOUNT_KEY"
}

data "aws_secretsmanager_secret" "secret_publishing_api_bearer_token" {
  name = "related_links_PUBLISHING_API_BEARER_TOKEN"
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${local.related_links_bucket_name}"

  versioning {
    enabled = true
  }

  tags {
    aws_environment = "${var.aws_environment}"
    Name            = "${local.related_links_bucket_name}"
  }
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

data "template_file" "ec2_assume_policy_template" {
  template = "${file("${path.module}/../../policies/ec2_assume_policy.tpl")}"
}

resource "aws_iam_role" "ec2_role" {
  name               = "${var.stackname}-ec2-role"
  assume_role_policy = "${data.template_file.ec2_assume_policy_template.rendered}"
}

data "aws_iam_policy_document" "read_content_store_backups_bucket_policy_document" {
  statement {
    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${local.content_store_bucket_name}",
    ]
  }

  statement {
    actions = [
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::${local.content_store_bucket_name}/mongo-api/*",
    ]
  }
}

data "aws_iam_policy_document" "read_write_related_links_bucket_policy_document" {
  statement {
    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${local.related_links_bucket_name}",
    ]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:CreateMultipartUpload",
    ]

    resources = [
      "arn:aws:s3:::${local.related_links_bucket_name}/*",
    ]
  }
}

data "aws_iam_policy_document" "read_secrets_from_secrets_manager_policy_document" {
  statement {
    actions = [
      "secretsmanager:GetSecretValue",
    ]

    resources = [
      "${data.aws_secretsmanager_secret.secret_big_query_service_account_key.arn}",
      "${data.aws_secretsmanager_secret.secret_publishing_api_bearer_token.arn}",
    ]
  }
}

data "template_file" "provision-generation-instance-userdata" {
  template = "${file("${path.module}/provision-generation-instance.tpl")}"

  vars {
    database_backups_bucket_name = "${data.terraform_remote_state.infra_database_backups_bucket.s3_database_backups_bucket_name}"
    related_links_bucket_name    = "govuk-related-links-${var.aws_environment}"
  }
}

data "template_file" "provision-ingestion-instance-userdata" {
  template = "${file("${path.module}/provision-ingestion-instance.tpl")}"

  vars {
    publishing_api_uri        = "https://publishing-api.${var.aws_environment}.govuk-internal.digital"
    related_links_bucket_name = "govuk-related-links-${var.aws_environment}"
  }
}

data "aws_iam_policy_document" "related_links_jenkins_policy_document" {
  statement {
    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "autoscaling:SetDesiredCapacity",
    ]

    resources = [
      "${aws_autoscaling_group.related-links-generation.arn}",
      "${aws_autoscaling_group.related-links-ingestion.arn}",
    ]
  }

  statement {
    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${local.content_store_bucket_name}",
      "arn:aws:s3:::${local.related_links_bucket_name}",
    ]
  }

  statement {
    actions = [
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::${local.content_store_bucket_name}/mongo-api/*",
      "arn:aws:s3:::${local.related_links_bucket_name}/*",
    ]
  }

  statement {
    actions = [
      "s3:PutObject",
      "s3:CreateMultipartUpload",
    ]

    resources = [
      "arn:aws:s3:::${local.related_links_bucket_name}/*",
    ]
  }
}

resource "aws_iam_policy" "read_content_store_backups_bucket_policy" {
  name   = "read_content_store_backups_bucket_policy"
  policy = "${data.aws_iam_policy_document.read_content_store_backups_bucket_policy_document.json}"
}

resource "aws_iam_policy" "read_write_related_links_bucket_policy" {
  name   = "read_write_related_links_bucket_policy"
  policy = "${data.aws_iam_policy_document.read_write_related_links_bucket_policy_document.json}"
}

resource "aws_iam_policy" "read_secrets_from_secrets_manager_policy" {
  name   = "read_secrets_from_secrets_manager_policy"
  policy = "${data.aws_iam_policy_document.read_secrets_from_secrets_manager_policy_document.json}"
}

resource "aws_iam_role_policy_attachment" "attach_read_content_store_backups_bucket_policy" {
  role       = "${aws_iam_role.ec2_role.name}"
  policy_arn = "${aws_iam_policy.read_content_store_backups_bucket_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "attach_read_write_related_links_bucket_policy" {
  role       = "${aws_iam_role.ec2_role.name}"
  policy_arn = "${aws_iam_policy.read_write_related_links_bucket_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "attach_read_secrets_from_secrets_manager_policy" {
  role       = "${aws_iam_role.ec2_role.name}"
  policy_arn = "${aws_iam_policy.read_secrets_from_secrets_manager_policy.arn}"
}

resource "aws_iam_policy" "related_links_jenkins_policy" {
  name   = "related_links_jenkins_policy"
  policy = "${data.aws_iam_policy_document.related_links_jenkins_policy_document.json}"
}

resource "aws_iam_instance_profile" "related-links_instance-profile" {
  name = "related-links_instance-profile"
  role = "${aws_iam_role.ec2_role.name}"
}

resource "aws_key_pair" "jenkins_public_key" {
  key_name   = "jenkins-public-key"
  public_key = "${var.jenkins_ssh_public_key}"
}

resource "aws_launch_template" "related-links-generation_launch-template" {
  name          = "related-links-generation_launch-template"
  image_id      = "${data.aws_ami.ubuntu_bionic.id}"
  instance_type = "m5.8xlarge"

  vpc_security_group_ids = [
    "${data.terraform_remote_state.infra_security_groups.sg_related-links_id}",
  ]

  key_name = "${aws_key_pair.jenkins_public_key.key_name}"

  iam_instance_profile {
    name = "${aws_iam_instance_profile.related-links_instance-profile.name}"
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

  user_data = "${base64encode(data.template_file.provision-generation-instance-userdata.rendered)}"
}

resource "aws_autoscaling_group" "related-links-generation" {
  name             = "related-links-generation"
  min_size         = 0
  max_size         = 1
  desired_capacity = 0

  launch_template {
    id      = "${aws_launch_template.related-links-generation_launch-template.id}"
    version = "$Latest"
  }

  vpc_zone_identifier = ["${data.terraform_remote_state.infra_networking.private_subnet_ids}"]

  tag {
    key                 = "Name"
    value               = "related-links-generation"
    propagate_at_launch = true
  }
}

resource "aws_launch_template" "related-links-ingestion_launch-template" {
  name          = "related-links-ingestion_launch-template"
  image_id      = "${data.aws_ami.ubuntu_bionic.id}"
  instance_type = "t2.micro"

  vpc_security_group_ids = [
    "${data.terraform_remote_state.infra_security_groups.sg_related-links_id}",
    "${data.terraform_remote_state.infra_security_groups.sg_management_id}",
  ]

  key_name = "${aws_key_pair.jenkins_public_key.key_name}"

  iam_instance_profile {
    name = "${aws_iam_instance_profile.related-links_instance-profile.name}"
  }

  instance_initiated_shutdown_behavior = "terminate"

  lifecycle {
    create_before_destroy = true
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 8
    }
  }

  user_data = "${base64encode(data.template_file.provision-ingestion-instance-userdata.rendered)}"
}

resource "aws_autoscaling_group" "related-links-ingestion" {
  name             = "related-links-ingestion"
  min_size         = 0
  max_size         = 1
  desired_capacity = 0

  launch_template {
    id      = "${aws_launch_template.related-links-ingestion_launch-template.id}"
    version = "$Latest"
  }

  vpc_zone_identifier = ["${data.terraform_remote_state.infra_networking.private_subnet_ids}"]

  tag {
    key                 = "Name"
    value               = "related-links-ingestion"
    propagate_at_launch = true
  }
}

# Outputs
# --------------------------------------------------------------

output "policy_read_content_store_backups_bucket_policy_arn" {
  value       = "${aws_iam_policy.read_content_store_backups_bucket_policy.arn}"
  description = "ARN of the policy used to read content store backups from the database backups bucket"
}

output "policy_read_write_related_links_bucket_policy_arn" {
  value       = "${aws_iam_policy.read_write_related_links_bucket_policy.arn}"
  description = "ARN of the policy used to read/write data from/to the related links bucket"
}

output "policy_related_links_jenkins_policy_arn" {
  value       = "${aws_iam_policy.related_links_jenkins_policy.arn}"
  description = "ARN of the policy used by Jenkins to manage related links generation and ingestion"
}
