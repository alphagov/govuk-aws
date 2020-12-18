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

variable "concourse_aws_account_id" {
  type        = "string"
  description = "AWS account ID which contains the Concourse role"
}

locals {
  content_store_bucket_name = "${data.terraform_remote_state.infra_database_backups_bucket.s3_database_backups_bucket_name}"
  related_links_bucket_name = "govuk-related-links-${var.aws_environment}"
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

resource "aws_iam_role" "concourse_role" {
  name               = "concourse_role"
  assume_role_policy = "${data.template_file.concourse_assume_policy_template.rendered}"
}

data "template_file" "concourse_assume_policy_template" {
  template = "${file("${path.module}/../../policies/concourse_assume_policy.tpl")}"

  vars {
    concourse_aws_account_id = "${var.concourse_aws_account_id}"
  }
}

data "aws_iam_policy_document" "scale_asg_policy_document" {
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
}

resource "aws_iam_policy" "scale_asg_policy" {
  name   = "scale_asg_policy"
  policy = "${data.aws_iam_policy_document.scale_asg_policy_document.json}"
}

resource "aws_iam_role_policy_attachment" "scale_asg_concourse_role_attachment" {
  role       = "${aws_iam_role.concourse_role.name}"
  policy_arn = "${aws_iam_policy.scale_asg_policy.arn}"
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

resource "aws_iam_policy" "read_content_store_backups_bucket_policy" {
  name   = "read_content_store_backups_bucket_policy"
  policy = "${data.aws_iam_policy_document.read_content_store_backups_bucket_policy_document.json}"
}

resource "aws_iam_policy" "read_write_related_links_bucket_policy" {
  name   = "read_write_related_links_bucket_policy"
  policy = "${data.aws_iam_policy_document.read_write_related_links_bucket_policy_document.json}"
}

resource "aws_iam_role_policy_attachment" "attach_read_content_store_backups_bucket_policy" {
  role       = "${aws_iam_role.ec2_role.name}"
  policy_arn = "${aws_iam_policy.read_content_store_backups_bucket_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "attach_read_write_related_links_bucket_policy" {
  role       = "${aws_iam_role.ec2_role.name}"
  policy_arn = "${aws_iam_policy.read_write_related_links_bucket_policy.arn}"
}

resource "aws_iam_instance_profile" "related-links_instance-profile" {
  name = "related-links_instance-profile"
  role = "${aws_iam_role.ec2_role.name}"
}

resource "aws_key_pair" "concourse_public_key" {
  key_name   = "concourse-public-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDmhwTY/gIED+aNtja8rgo9B0lYWdhK81NRP1heZ7A8oV5GKbLqiHwyZha/1NiTlyoLuptUFzZb9zYC0pqPYnE8H1C4pssk6yNvNX0rhMO3xhGy52qkgfKN21B23tVFK+x1q2znAb8o/OoApvIW8PGyoQDYQ4/ygHeYvr9UjWyUkLEprUoB25ZU133qSEmnL9m5j6+0ZAOvI+mGJyPJ0o6x1e5q9IT7WN+//TDE+iON2WMWOqidmtsy6ARIKtCvifX0+3CgiUaJ55IpsICesfuaHMziuMarD/VWWWwAjKCrsFKywnnKC1Q3e1rmzwhUe/f1z1P3HXEu6orrBQxMNSrxkAvfwfWnru9fsabIL+ve4Ymm/oOWdHgLP35qkOYrXQzsQU+KzCsU1HnMix8p7DZO13vzpWfaDpw3v0vEwpZOYGN92RWZMaz2id2m1fJ4tRa+j4XNcdg5KE7b8egVwUCef3GL/LJKwJpWJ+ai4dWEfBziVwmq2CDZ5Q3ABw3eg9REHvTZf/+T9q0VQ9F4UQAyM9XILF/C/xYH4KGSHamWQphWZTrhV9w3c86jHZMRxOlgukvg82N+ENJmn0RS5f834ebKhGwtqXiqqFWqn6ukVjfvtzUsDFvEsVILUdG+TrxzpogPo7VWdLWqWDVIGWj2aCgBZW9U0nvqmd9zz9toMQ=="
}

resource "aws_launch_template" "related-links-generation_launch-template" {
  name          = "related-links-generation_launch-template"
  image_id      = "${data.aws_ami.ubuntu_bionic.id}"
  instance_type = "m5.4xlarge"

  vpc_security_group_ids = [
    "${data.terraform_remote_state.infra_security_groups.sg_related-links_id}",
  ]

  key_name = "${aws_key_pair.concourse_public_key.key_name}"

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

  vpc_zone_identifier = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]

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

  key_name = "${aws_key_pair.concourse_public_key.key_name}"

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

  vpc_zone_identifier = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]

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

output "concourse_role_name" {
  value       = "${aws_iam_role.concourse_role.name}"
  description = "Name of the role assumed by Concourse"
}
