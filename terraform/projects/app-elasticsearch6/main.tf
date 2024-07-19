/**
* ## Project: app-elasticsearch6
*
* Managed Elasticsearch 6 cluster
*
* The snapshot repository configuration is not currently done via Terraform;
* see register-snapshot-repository.py.
*
*/

terraform {
  backend "s3" {}
  required_version = "~> 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      terraform_deployment = basename(abspath(path.root))
      aws_environment      = var.aws_environment
      project              = "GOV.UK - Search"
    }
  }
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "elasticsearch6_log_publishing_policy" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:PutLogEventsBatch",
    ]
    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/aes/domains/${var.stackname}-elasticsearch6-domain/*"
    ]
    principals {
      identifiers = ["es.amazonaws.com"]
      type        = "Service"
    }
  }
}

data "aws_route53_zone" "internal" {
  name         = var.internal_zone_name
  private_zone = true
}

data "aws_acm_certificate" "govuk_internal" {
  domain   = "*.${var.aws_environment}.govuk-internal.digital"
  statuses = ["ISSUED"]
}

resource "aws_cloudwatch_log_group" "elasticsearch6_application_log_group" {
  name              = "/aws/aes/domains/${var.stackname}-elasticsearch6-domain/es6-application-logs"
  retention_in_days = var.cloudwatch_log_retention
}

resource "aws_cloudwatch_log_group" "elasticsearch6_search_log_group" {
  name              = "/aws/aes/domains/${var.stackname}-elasticsearch6-domain/es6-search-logs"
  retention_in_days = var.cloudwatch_log_retention
}

resource "aws_cloudwatch_log_group" "elasticsearch6_index_log_group" {
  name              = "/aws/aes/domains/${var.stackname}-elasticsearch6-domain/es6-index-logs"
  retention_in_days = var.cloudwatch_log_retention
}

resource "aws_cloudwatch_log_resource_policy" "elasticsearch6_log_resource_policy" {
  policy_name     = "elasticsearch6_log_resource_policy"
  policy_document = data.aws_iam_policy_document.elasticsearch6_log_publishing_policy.json
}

resource "aws_iam_service_linked_role" "role" {
  aws_service_name = "es.amazonaws.com"
}

resource "aws_elasticsearch_domain" "elasticsearch6" {
  depends_on = [aws_iam_service_linked_role.role]

  domain_name           = "${var.stackname}-elasticsearch6-domain"
  elasticsearch_version = "6.7"

  cluster_config {
    instance_type            = var.elasticsearch6_instance_type
    instance_count           = var.elasticsearch6_instance_count
    dedicated_master_enabled = var.elasticsearch6_dedicated_master_enabled
    dedicated_master_type    = var.elasticsearch6_master_instance_type
    dedicated_master_count   = var.elasticsearch6_master_instance_count
    zone_awareness_enabled   = true
    zone_awareness_config { availability_zone_count = 3 }
  }

  domain_endpoint_options {
    custom_endpoint                 = "elasticsearch6.${var.aws_environment}.govuk-internal.digital"
    custom_endpoint_certificate_arn = data.aws_acm_certificate.govuk_internal.arn
    custom_endpoint_enabled         = true
    # TODO: enforce TLS once the last non-TLS clients are cleaned up.
    enforce_https = false
  }

  ebs_options {
    ebs_enabled = true
    iops        = 3000
    volume_type = "gp3"
    volume_size = var.elasticsearch6_ebs_size
  }

  vpc_options {
    subnet_ids = matchkeys(
      values(data.terraform_remote_state.infra_networking.outputs.private_subnet_elasticsearch_names_ids_map),
      keys(data.terraform_remote_state.infra_networking.outputs.private_subnet_elasticsearch_names_ids_map),
      var.elasticsearch_subnet_names
    )
    security_group_ids = [
      data.terraform_remote_state.infra_security_groups.outputs.sg_elasticsearch6_id,
    ]
  }

  snapshot_options {
    automated_snapshot_start_hour = var.elasticsearch6_snapshot_start_hour
  }

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.elasticsearch6_application_log_group.arn
    log_type                 = "ES_APPLICATION_LOGS"
  }

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.elasticsearch6_search_log_group.arn
    log_type                 = "SEARCH_SLOW_LOGS"
  }

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.elasticsearch6_index_log_group.arn
    log_type                 = "INDEX_SLOW_LOGS"
  }

  access_policies = data.aws_iam_policy_document.es_access.json

  tags = {
    Name          = "${var.stackname}-elasticsearch6"
    Project       = var.stackname
    aws_stackname = var.stackname
  }
}

data "aws_iam_policy_document" "es_access" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = ["es:*"]
    resources = [
      "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.stackname}-elasticsearch6-domain/*"
    ]
  }
}

resource "aws_route53_record" "service_record" {
  zone_id = data.aws_route53_zone.internal.zone_id
  name    = "elasticsearch6.${var.stackname}"
  type    = "CNAME"
  ttl     = 300
  records = [aws_elasticsearch_domain.elasticsearch6.endpoint]
}

resource "aws_s3_bucket" "manual_snapshots" {
  bucket = "govuk-${var.aws_environment}-elasticsearch6-manual-snapshots"
  tags   = { Name = "govuk-${var.aws_environment}-elasticsearch6-manual-snapshots" }
}

resource "aws_s3_bucket_logging" "manual_snapshots" {
  bucket        = aws_s3_bucket.manual_snapshots.id
  target_bucket = data.terraform_remote_state.infra_monitoring.outputs.aws_logging_bucket_id
  target_prefix = "s3/govuk-${var.aws_environment}-elasticsearch6-manual-snapshots/"
}

resource "aws_s3_bucket_policy" "manual_snapshots_cross_account_access" {
  bucket = aws_s3_bucket.manual_snapshots.id
  policy = data.aws_iam_policy_document.manual_snapshots_cross_account_access.json
}

data "aws_iam_policy_document" "manual_snapshots_cross_account_access" {
  statement {
    sid = "CrossAccountAccess"
    principals {
      type = "AWS"
      identifiers = [
        "172025368201", # Production
        "696911096973", # Staging
        "210287912431", # Integration
      ]
    }
    # This bucket is only for copying the indices from prod to
    # staging/integration. Backup snapshots of prod are stored separately, so
    # the (required) put/delete permissions here don't represent a problem.
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:PutObjectAcl",
    ]
    resources = [
      aws_s3_bucket.manual_snapshots.arn,
      "${aws_s3_bucket.manual_snapshots.arn}/*",
    ]
  }
}

resource "aws_iam_role" "manual_snapshot_role" {
  name               = "${var.stackname}-elasticsearch6-manual-snapshot-role"
  assume_role_policy = data.aws_iam_policy_document.es_can_assume_role.json
}

data "aws_iam_policy_document" "es_can_assume_role" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["es.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "manual_snapshot_bucket_policy" {
  statement {
    actions   = ["s3:ListBucket"]
    resources = var.elasticsearch6_manual_snapshot_bucket_arns
  }
  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
    ]
    resources = formatlist("%s/*", var.elasticsearch6_manual_snapshot_bucket_arns)
  }
}

resource "aws_iam_policy" "manual_snapshot_bucket_policy" {
  name   = "govuk-${var.aws_environment}-elasticsearch6-manual-snapshot-bucket-policy"
  policy = data.aws_iam_policy_document.manual_snapshot_bucket_policy.json
}

resource "aws_iam_policy_attachment" "manual_snapshot_role_policy_attachment" {
  name       = "govuk-${var.aws_environment}-elasticsearch6-manual-snapshot-bucket-policy-attachment"
  roles      = [aws_iam_role.manual_snapshot_role.name]
  policy_arn = aws_iam_policy.manual_snapshot_bucket_policy.arn
}

resource "aws_iam_policy" "can_configure_es_snapshots" {
  name        = "govuk-${var.aws_environment}-elasticsearch6-manual-snapshot-domain-configuration-policy"
  description = "Human operator permissions for initial setup of the snapshot bucket for the ES domain. https://docs.aws.amazon.com/elasticsearch-service/latest/developerguide/es-managedomains-snapshots.html#es-managedomains-snapshot-prerequisites"
  lifecycle { ignore_changes = [description] } # Inexplicably immutable in AWS.
  policy = data.aws_iam_policy_document.can_configure_es_snapshots.json
}

data "aws_iam_policy_document" "can_configure_es_snapshots" {
  statement {
    actions   = ["iam:PassRole"]
    resources = [aws_iam_role.manual_snapshot_role.arn]
  }
  statement {
    actions   = ["es:ESHttpPut"]
    resources = ["${aws_elasticsearch_domain.elasticsearch6.arn}/*"]
  }
}
