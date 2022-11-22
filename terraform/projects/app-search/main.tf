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
  default     = "c5.xlarge"
}

# Resources
# --------------------------------------------------------------
terraform {
  backend          "s3"             {}
  required_version = "= 0.11.15"
}

data "aws_route53_zone" "internal" {
  name         = "${var.internal_zone_name}"
  private_zone = true
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "2.46.0"
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

    target   = "HTTP:80/_healthcheck-live_search-api"
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

resource "aws_iam_role_policy_attachment" "use_sagemaker" {
  role       = "${module.search.instance_iam_role_name}"
  policy_arn = "${aws_iam_policy.use_sagemaker.arn}"
}

resource "aws_iam_policy" "use_sagemaker" {
  name        = "govuk-${var.aws_environment}-search-use-sagemaker-policy"
  policy      = "${data.aws_iam_policy_document.use_sagemaker.json}"
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

  lifecycle_rule {
    id      = "expire_training_data"
    prefix  = "data/"
    enabled = true

    expiration {
      days = 7
    }
  }

  lifecycle_rule {
    id      = "expire_models"
    prefix  = "model/"
    enabled = true

    expiration {
      days = 7
    }
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

# Daily learn-to-rank

resource "aws_iam_role" "learntorank" {
  name = "govuk-${var.aws_environment}-search-learntorank-role"

  assume_role_policy = "${data.aws_iam_policy_document.learntorank-assume-role.json}"
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
  role       = "${aws_iam_role.learntorank.name}"
  policy_arn = "${aws_iam_policy.search_relevancy_bucket_access.arn}"
}

# this grants much broader permissions than we need, so we might want
# to narrow this down in the future.
resource "aws_iam_role_policy_attachment" "learntorank-sagemaker" {
  role       = "${aws_iam_role.learntorank.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

resource "aws_iam_role_policy_attachment" "learntorank-ecr" {
  role       = "${aws_iam_role.learntorank.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

# we might want to retire this in favour of a dedicated project
resource "aws_ecr_repository" "repo" {
  name = "search"

  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository_policy" "policy" {
  repository = "${aws_ecr_repository.repo.name}"
  policy     = "${data.aws_iam_policy_document.ecr-usage.json}"
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
      type = "AWS"

      identifiers = [
        "${aws_iam_role.learntorank.arn}",
      ]
    }

    principals {
      type        = "Service"
      identifiers = ["sagemaker.amazonaws.com"]
    }
  }
}

resource "aws_iam_instance_profile" "learntorank-generation" {
  name = "govuk-${var.aws_environment}-search-ltr-generation"
  role = "${aws_iam_role.learntorank.name}"
}

resource "aws_key_pair" "learntorank-generation-key" {
  key_name   = "govuk-${var.aws_environment}-search-ltr-generation-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDGNF9QVcjq9LUioccV8Fw161BrM3EHPRtwzp+2IRaYrgpwgBoIxgK2q1LLrLSwcoLfbDyU3dW0cMN0wpbxFzHTFuDqzm5fdAzhijZJCKMyPtMSPOhUev+/JfHVZj7JGXHV2SOMM1Q1XkEBwgenPmR2Hz6fMs3+R/LdeNkMTU1H/fOXl6WU9DY1XAUdYzfufRXiDt2aCGCOknAWqOAdT+22FZcmgc657tt9xbOJYzVoEAqBArCxixpf5N7Tha0QUac8QGQQxw01LENHRN1S4NLtvUEBqI3m99f8NleOlO4eD7XBkcwPXMrFP7/4IqAPq+JgoD2OrDSX3HiE8HNtJTLr0vmP5plBiwH3Bd+32oILQiw4HqXt8JpTfr/fAJXlsHCmYkxlEzhhZ46H1VZsgU9BM69C/bWTvGWCFAYrWbu2vt9Gbo1nbZVTQjLBfKgY3vxk5Tmj4b43AGI1tprPdBh43IdQvvYu9oiTodzxetaQoK8fUMKPVoQruPJNfKcu3Yukm8DvVmwQqoAgik5iYk7up9gX1L//L0dJIpjWSlU5ytpmG+M5k+Abbg+kkIjnCXXkS2Icwnh3BEIvxLIt9MaMf89Lxi4Jin1uNu727Z9cXGRp8Fyz5GdDEKz37P5k7jFEV70KYLwl3r7qxp66RafXgRx/fRRVHdTNf43O6UqDUQ== concourse-worker"
}

data "aws_ami" "ubuntu_focal" {
  most_recent = true

  # canonical
  owners = ["099720109477", "696911096973"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_launch_template" "learntorank-generation" {
  name          = "govuk-${var.aws_environment}-search-ltr-generation"
  image_id      = "${data.aws_ami.ubuntu_focal.id}"
  instance_type = "c5.large"

  vpc_security_group_ids = [
    "${data.terraform_remote_state.infra_security_groups.sg_search-ltr-generation_id}",
  ]

  key_name = "${aws_key_pair.learntorank-generation-key.key_name}"

  iam_instance_profile {
    name = "${aws_iam_instance_profile.learntorank-generation.name}"
  }

  instance_initiated_shutdown_behavior = "terminate"

  lifecycle {
    create_before_destroy = true
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 32
    }
  }
}

resource "aws_autoscaling_group" "learntorank-generation" {
  name             = "govuk-${var.aws_environment}-search-ltr-generation"
  min_size         = 0
  max_size         = 1
  desired_capacity = 0

  launch_template {
    id      = "${aws_launch_template.learntorank-generation.id}"
    version = "$Latest"
  }

  vpc_zone_identifier = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]

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

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "autoscaling:SetDesiredCapacity",
    ]

    resources = [
      "${aws_autoscaling_group.learntorank-generation.arn}",
    ]
  }
}

resource "aws_iam_policy" "scale-learntorank-generation-asg-policy" {
  name   = "govuk-${var.aws_environment}-scale-search-ltr-generation-asg"
  policy = "${data.aws_iam_policy_document.scale-learntorank-generation-asg.json}"
}

resource "aws_iam_role_policy_attachment" "scale-learntorank-generation" {
  role       = "${aws_iam_role.learntorank.name}"
  policy_arn = "${aws_iam_policy.scale-learntorank-generation-asg-policy.arn}"
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

output "scale_learntorank_asg_policy_arn" {
  value       = "${aws_iam_policy.scale-learntorank-generation-asg-policy.arn}"
  description = "ARN of the policy used by to scale the ASG for learn to rank"
}

output "ltr_role_arn" {
  value       = "${aws_iam_role.learntorank.arn}"
  description = "LTR role ARN"
}

output "ecr_repository_url" {
  value       = "${aws_ecr_repository.repo.repository_url}"
  description = "URL of the ECR repository"
}

output "search_relevancy_s3_policy_arn" {
  value       = "${aws_iam_policy.search_relevancy_bucket_access.arn}"
  description = "ARN of the policy used to access the search-relevancy S3 bucket"
}

output "sitemaps_s3_policy_arn" {
  value       = "${aws_iam_policy.sitemaps_bucket_access.arn}"
  description = "ARN of the policy used to access the sitemaps S3 bucket"
}
