/**
* ## Project: app-search
*
* Search application servers
*/

terraform {
  backend "s3" {}
}

provider "aws" {
  region  = var.aws_region
  version = "2.46.0"
}

module "search" {
  source = "../../modules/aws/node_group"
  name   = "${var.stackname}-search"
  default_tags = {
    "Project"         = var.stackname
    "aws_stackname"   = var.stackname
    "aws_environment" = var.aws_environment
    "aws_migration"   = "search"
    "aws_hostname"    = "search-1"
  }
  instance_subnet_ids = data.terraform_remote_state.infra_networking.outputs.private_subnet_ids
  instance_security_group_ids = [
    data.terraform_remote_state.infra_security_groups.outputs.sg_search_id,
    data.terraform_remote_state.infra_security_groups.outputs.sg_management_id
  ]
  instance_type                 = var.instance_type
  instance_additional_user_data = join("\n", null_resource.user_data.*.triggers.snippet)
  instance_ami_filter_name      = var.instance_ami_filter_name
  asg_max_size                  = var.asg_max_size
  asg_min_size                  = var.asg_min_size
  asg_desired_capacity          = var.asg_desired_capacity
  asg_notification_topic_arn    = data.terraform_remote_state.infra_monitoring.outputs.sns_topic_autoscaling_group_events_arn
  asg_health_check_grace_period = 1200
}

resource "aws_s3_bucket" "sitemaps_bucket" {
  bucket = "govuk-${var.aws_environment}-sitemaps"
  region = var.aws_region

  tags = {
    Name            = "govuk-${var.aws_environment}-sitemaps"
    aws_environment = var.aws_environment
  }
  logging {
    target_bucket = data.terraform_remote_state.infra_monitoring.outputs.aws_logging_bucket_id
    target_prefix = "s3/govuk-${var.aws_environment}-sitemaps/"
  }
  lifecycle_rule {
    id      = "sitemaps_lifecycle_rule"
    prefix  = ""
    enabled = true
    expiration { days = 3 }
  }
}

resource "aws_iam_role_policy_attachment" "sitemaps_bucket_access_iam_role_policy_attachment" {
  role       = module.search.instance_iam_role_name
  policy_arn = aws_iam_policy.sitemaps_bucket_access.arn
}

resource "aws_iam_policy" "sitemaps_bucket_access" {
  name        = "govuk-${var.aws_environment}-sitemaps-bucket-access-policy"
  policy      = data.aws_iam_policy_document.sitemaps_bucket_policy.json
  description = "Allows reading and writing of the sitemaps bucket"
}

data "aws_iam_policy_document" "sitemaps_bucket_policy" {
  statement {
    sid       = "ReadListOfBuckets"
    actions   = ["s3:ListAllMyBuckets"]
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

resource "aws_iam_role_policy_attachment" "use_sagemaker" {
  role       = module.search.instance_iam_role_name
  policy_arn = aws_iam_policy.use_sagemaker.arn
}

resource "aws_iam_policy" "use_sagemaker" {
  name        = "govuk-${var.aws_environment}-search-use-sagemaker-policy"
  policy      = data.aws_iam_policy_document.use_sagemaker.json
  description = "Allows invoking and describing SageMaker endpoints"
}

data "aws_iam_policy_document" "use_sagemaker" {
  statement {
    sid = "InvokeSagemaker"
    actions = [
      "sagemaker:DescribeEndpoint",
      "sagemaker:InvokeEndpoint",
    ]
    resources = ["arn:aws:sagemaker:*"]
  }
}

resource "aws_s3_bucket" "search_relevancy_bucket" {
  bucket = "govuk-${var.aws_environment}-search-relevancy"
  region = var.aws_region

  tags = {
    Name            = "govuk-${var.aws_environment}-search-relevancy"
    Description     = "S3 bucket for Search Relevancy"
    aws_environment = var.aws_environment
  }

  logging {
    target_bucket = data.terraform_remote_state.infra_monitoring.outputs.aws_logging_bucket_id
    target_prefix = "s3/govuk-${var.aws_environment}-search-relevancy/"
  }

  lifecycle_rule {
    id      = "expire_training_data"
    prefix  = "data/"
    enabled = true
    expiration { days = 7 }
  }

  lifecycle_rule {
    id      = "expire_models"
    prefix  = "model/"
    enabled = true
    expiration { days = 7 }
  }
}

resource "aws_iam_role_policy_attachment" "search_relevancy_bucket_access_iam_role_policy_attachment" {
  role       = module.search.instance_iam_role_name
  policy_arn = aws_iam_policy.search_relevancy_bucket_access.arn
}

resource "aws_iam_policy" "search_relevancy_bucket_access" {
  name        = "govuk-${var.aws_environment}-search-relevancy-bucket-access-policy"
  policy      = data.aws_iam_policy_document.search_relevancy_bucket_policy.json
  description = "Allows reading and writing of the search relevancy bucket"
}

data "aws_iam_policy_document" "search_relevancy_bucket_policy" {
  statement {
    sid       = "ReadListOfBuckets"
    actions   = ["s3:ListAllMyBuckets"]
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

# Daily learn-to-rank

resource "aws_iam_role" "learntorank" {
  name               = "govuk-${var.aws_environment}-search-learntorank-role"
  assume_role_policy = data.aws_iam_policy_document.learntorank-assume-role.json
}

data "aws_iam_policy_document" "learntorank-assume-role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["sagemaker.amazonaws.com"]
    }
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "learntorank-bucket" {
  role       = aws_iam_role.learntorank.name
  policy_arn = aws_iam_policy.search_relevancy_bucket_access.arn
}

# this grants much broader permissions than we need, so we might want
# to narrow this down in the future.
resource "aws_iam_role_policy_attachment" "learntorank-sagemaker" {
  role       = aws_iam_role.learntorank.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

resource "aws_iam_role_policy_attachment" "learntorank-ecr" {
  role       = aws_iam_role.learntorank.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

resource "aws_ecr_repository" "repo" {
  name                 = "search"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository_policy" "policy" {
  repository = aws_ecr_repository.repo.name
  policy     = data.aws_iam_policy_document.ecr-usage.json
}

data "aws_iam_policy_document" "ecr-usage" {
  statement {
    sid = "read"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:DescribeRepositories",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
    ]
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.learntorank.arn]
    }
    principals {
      type        = "Service"
      identifiers = ["sagemaker.amazonaws.com"]
    }
  }
}

resource "aws_iam_instance_profile" "learntorank-generation" {
  name = "govuk-${var.aws_environment}-search-ltr-generation"
  role = aws_iam_role.learntorank.name
}

resource "aws_key_pair" "learntorank-generation-key" {
  key_name   = "govuk-${var.aws_environment}-search-ltr-generation-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDGNF9QVcjq9LUioccV8Fw161BrM3EHPRtwzp+2IRaYrgpwgBoIxgK2q1LLrLSwcoLfbDyU3dW0cMN0wpbxFzHTFuDqzm5fdAzhijZJCKMyPtMSPOhUev+/JfHVZj7JGXHV2SOMM1Q1XkEBwgenPmR2Hz6fMs3+R/LdeNkMTU1H/fOXl6WU9DY1XAUdYzfufRXiDt2aCGCOknAWqOAdT+22FZcmgc657tt9xbOJYzVoEAqBArCxixpf5N7Tha0QUac8QGQQxw01LENHRN1S4NLtvUEBqI3m99f8NleOlO4eD7XBkcwPXMrFP7/4IqAPq+JgoD2OrDSX3HiE8HNtJTLr0vmP5plBiwH3Bd+32oILQiw4HqXt8JpTfr/fAJXlsHCmYkxlEzhhZ46H1VZsgU9BM69C/bWTvGWCFAYrWbu2vt9Gbo1nbZVTQjLBfKgY3vxk5Tmj4b43AGI1tprPdBh43IdQvvYu9oiTodzxetaQoK8fUMKPVoQruPJNfKcu3Yukm8DvVmwQqoAgik5iYk7up9gX1L//L0dJIpjWSlU5ytpmG+M5k+Abbg+kkIjnCXXkS2Icwnh3BEIvxLIt9MaMf89Lxi4Jin1uNu727Z9cXGRp8Fyz5GdDEKz37P5k7jFEV70KYLwl3r7qxp66RafXgRx/fRRVHdTNf43O6UqDUQ== concourse-worker"
}

data "aws_ami" "ubuntu_focal" {
  most_recent = true
  owners      = ["099720109477", "696911096973"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_launch_template" "learntorank-generation" {
  name                   = "govuk-${var.aws_environment}-search-ltr-generation"
  image_id               = data.aws_ami.ubuntu_focal.id
  instance_type          = "c5.large"
  vpc_security_group_ids = [data.terraform_remote_state.infra_security_groups.outputs.sg_search-ltr-generation_id]
  key_name               = aws_key_pair.learntorank-generation-key.key_name

  iam_instance_profile { name = aws_iam_instance_profile.learntorank-generation.name }
  lifecycle { create_before_destroy = true }
  instance_initiated_shutdown_behavior = "terminate"

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs { volume_size = 32 }
  }
}

resource "aws_autoscaling_group" "learntorank-generation" {
  name             = "govuk-${var.aws_environment}-search-ltr-generation"
  min_size         = 0
  max_size         = 1
  desired_capacity = 0

  launch_template {
    id      = aws_launch_template.learntorank-generation.id
    version = "$Latest"
  }

  vpc_zone_identifier = data.terraform_remote_state.infra_networking.outputs.public_subnet_ids

  tag {
    key                 = "Name"
    value               = "govuk-${var.aws_environment}-search-ltr-generation"
    propagate_at_launch = true
  }
}

data "aws_iam_policy_document" "scale-learntorank-generation-asg" {
  statement {
    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
    ]
    resources = ["*"]
  }
  statement {
    actions   = ["autoscaling:SetDesiredCapacity"]
    resources = [aws_autoscaling_group.learntorank-generation.arn]
  }
}

resource "aws_iam_policy" "scale-learntorank-generation-asg-policy" {
  name   = "govuk-${var.aws_environment}-scale-search-ltr-generation-asg"
  policy = data.aws_iam_policy_document.scale-learntorank-generation-asg.json
}

resource "aws_iam_role_policy_attachment" "scale-learntorank-generation" {
  role       = aws_iam_role.learntorank.name
  policy_arn = aws_iam_policy.scale-learntorank-generation-asg-policy.arn
}
