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
