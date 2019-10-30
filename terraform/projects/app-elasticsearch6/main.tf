/**
* ## Project: app-elasticsearch6
*
* Managed Elasticsearch 6 cluster
*
* This project has two gotchas, where we work around things terraform
* doesn't support:
*
* - Deploying the cluster across 3 availability zones: terraform has
*   some built-in validation which rejects using 3 master nodes and 3
*   data nodes across 3 availability zones.  To provision a new
*   cluster, only use two of everything, then bump the numbers in the
*   AWS console and in the terraform variables - it won't complain
*   when you next plan.
*
*   https://github.com/terraform-providers/terraform-provider-aws/issues/7504
*
* - Configuring a snapshot repository: terraform doesn't support this,
*   and as far as I can tell doesn't have any plans to.  There's a
*   Python script in this directory which sets those up.
*
*/
variable "aws_environment" {
  type        = "string"
  description = "AWS Environment"
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

variable "elasticsearch6_instance_type" {
  type        = "string"
  description = "The instance type of the individual ElasticSearch nodes, only instances which allow EBS volumes are supported"
  default     = "r4.xlarge.elasticsearch"
}

variable "elasticsearch6_instance_count" {
  type        = "string"
  description = "The number of ElasticSearch nodes"
  default     = "6"
}

variable "elasticsearch6_dedicated_master_enabled" {
  type        = "string"
  description = "Indicates whether dedicated master nodes are enabled for the cluster"
  default     = "true"
}

variable "elasticsearch6_master_instance_type" {
  type        = "string"
  description = "Instance type of the dedicated master nodes in the cluster"
  default     = "c4.large.elasticsearch"
}

# TODO: change the default to 3 after the first deploy
variable "elasticsearch6_master_instance_count" {
  type        = "string"
  description = "Number of dedicated master nodes in the cluster"
  default     = "2"
}

variable "elasticsearch6_ebs_encrypt" {
  type        = "string"
  description = "Whether to encrypt the EBS volume at rest"
}

variable "elasticsearch6_ebs_type" {
  type        = "string"
  description = "The type of EBS storage to attach"
  default     = "gp2"
}

variable "elasticsearch6_ebs_size" {
  type        = "string"
  description = "The amount of EBS storage to attach"
  default     = 32
}

variable "elasticsearch6_snapshot_start_hour" {
  type        = "string"
  description = "The hour in which the daily snapshot is taken"
  default     = 1
}

variable "elasticsearch_subnet_names" {
  type        = "list"
  description = "Names of the subnets to place the ElasticSearch domain in"
}

variable "cloudwatch_log_retention" {
  type        = "string"
  description = "Number of days to retain Cloudwatch logs for"
  default     = 90
}

variable "elasticsearch6_manual_snapshot_bucket_arns" {
  type        = "list"
  description = "Bucket ARNs this domain can read/write for manual snapshots"
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

# Resources
# --------------------------------------------------------------
terraform {
  backend          "s3"             {}
  required_version = "= 0.11.14"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "2.33.0"
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

    resources = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/aes/domains/${var.stackname}-elasticsearch6-domain/*"]

    principals {
      identifiers = ["es.amazonaws.com"]
      type        = "Service"
    }
  }
}

data "aws_route53_zone" "internal" {
  name         = "${var.internal_zone_name}"
  private_zone = true
}

resource "aws_cloudwatch_log_group" "elasticsearch6_application_log_group" {
  name              = "/aws/aes/domains/${var.stackname}-elasticsearch6-domain/es6-application-logs"
  retention_in_days = "${var.cloudwatch_log_retention}"
}

resource "aws_cloudwatch_log_group" "elasticsearch6_search_log_group" {
  name              = "/aws/aes/domains/${var.stackname}-elasticsearch6-domain/es6-search-logs"
  retention_in_days = "${var.cloudwatch_log_retention}"
}

resource "aws_cloudwatch_log_group" "elasticsearch6_index_log_group" {
  name              = "/aws/aes/domains/${var.stackname}-elasticsearch6-domain/es6-index-logs"
  retention_in_days = "${var.cloudwatch_log_retention}"
}

resource "aws_cloudwatch_log_resource_policy" "elasticsearch6_log_resource_policy" {
  policy_name     = "elasticsearch6_log_resource_policy"
  policy_document = "${data.aws_iam_policy_document.elasticsearch6_log_publishing_policy.json}"
}

module "elasticsearch6_application_log_exporter" {
  source                       = "../../modules/aws/cloudwatch_log_exporter"
  log_group_name               = "${aws_cloudwatch_log_group.elasticsearch6_application_log_group.name}"
  firehose_role_arn            = "${data.terraform_remote_state.infra_monitoring.firehose_logs_role_arn}"
  firehose_bucket_arn          = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_arn}"
  firehose_bucket_prefix       = "elasticsearch6/application-logs"
  lambda_filename              = "../../lambda/ElasticsearchLogsToFirehose/ElasticsearchLogsToFirehose.zip"
  lambda_role_arn              = "${data.terraform_remote_state.infra_monitoring.lambda_logs_role_arn}"
  lambda_log_retention_in_days = "${var.cloudwatch_log_retention}"
}

module "elasticsearch6_search_log_exporter" {
  source                       = "../../modules/aws/cloudwatch_log_exporter"
  log_group_name               = "${aws_cloudwatch_log_group.elasticsearch6_search_log_group.name}"
  firehose_role_arn            = "${data.terraform_remote_state.infra_monitoring.firehose_logs_role_arn}"
  firehose_bucket_arn          = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_arn}"
  firehose_bucket_prefix       = "elasticsearch6/search-logs"
  lambda_filename              = "../../lambda/ElasticsearchLogsToFirehose/ElasticsearchLogsToFirehose.zip"
  lambda_role_arn              = "${data.terraform_remote_state.infra_monitoring.lambda_logs_role_arn}"
  lambda_log_retention_in_days = "${var.cloudwatch_log_retention}"
}

module "elasticsearch6_index_log_exporter" {
  source                       = "../../modules/aws/cloudwatch_log_exporter"
  log_group_name               = "${aws_cloudwatch_log_group.elasticsearch6_index_log_group.name}"
  firehose_role_arn            = "${data.terraform_remote_state.infra_monitoring.firehose_logs_role_arn}"
  firehose_bucket_arn          = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_arn}"
  firehose_bucket_prefix       = "elasticsearch6/index-logs"
  lambda_filename              = "../../lambda/ElasticsearchLogsToFirehose/ElasticsearchLogsToFirehose.zip"
  lambda_role_arn              = "${data.terraform_remote_state.infra_monitoring.lambda_logs_role_arn}"
  lambda_log_retention_in_days = "${var.cloudwatch_log_retention}"
}

resource "aws_iam_service_linked_role" "role" {
  aws_service_name = "es.amazonaws.com"
}

resource "aws_elasticsearch_domain" "elasticsearch6" {
  domain_name           = "${var.stackname}-elasticsearch6-domain"
  elasticsearch_version = "6.7"

  cluster_config {
    instance_type            = "${var.elasticsearch6_instance_type}"
    instance_count           = "${var.elasticsearch6_instance_count}"
    dedicated_master_enabled = "${var.elasticsearch6_dedicated_master_enabled}"
    dedicated_master_type    = "${var.elasticsearch6_master_instance_type}"
    dedicated_master_count   = "${var.elasticsearch6_master_instance_count}"
    zone_awareness_enabled   = true
  }

  ebs_options {
    ebs_enabled = true
    volume_type = "${var.elasticsearch6_ebs_type}"
    volume_size = "${var.elasticsearch6_ebs_size}"
  }

  encrypt_at_rest {
    enabled = "${var.elasticsearch6_ebs_encrypt}"
  }

  vpc_options {
    subnet_ids         = ["${matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_elasticsearch_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_elasticsearch_names_ids_map), var.elasticsearch_subnet_names)}"]
    security_group_ids = ["${data.terraform_remote_state.infra_security_groups.sg_elasticsearch6_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  }

  snapshot_options {
    automated_snapshot_start_hour = "${var.elasticsearch6_snapshot_start_hour}"
  }

  log_publishing_options {
    cloudwatch_log_group_arn = "${aws_cloudwatch_log_group.elasticsearch6_application_log_group.arn}"
    log_type                 = "ES_APPLICATION_LOGS"
  }

  log_publishing_options {
    cloudwatch_log_group_arn = "${aws_cloudwatch_log_group.elasticsearch6_search_log_group.arn}"
    log_type                 = "SEARCH_SLOW_LOGS"
  }

  log_publishing_options {
    cloudwatch_log_group_arn = "${aws_cloudwatch_log_group.elasticsearch6_index_log_group.arn}"
    log_type                 = "INDEX_SLOW_LOGS"
  }

  access_policies = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "*"
        ]
      },
      "Action": [
        "es:*"
      ],
      "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.stackname}-elasticsearch6-domain/*"
    }
  ]
}
CONFIG

  tags {
    Name            = "${var.stackname}-elasticsearch6"
    Project         = "${var.stackname}"
    aws_stackname   = "${var.stackname}"
    aws_environment = "${var.aws_environment}"
  }

  depends_on = [
    "aws_iam_service_linked_role.role",
  ]
}

resource "aws_route53_record" "service_record" {
  zone_id = "${data.aws_route53_zone.internal.zone_id}"
  name    = "elasticsearch6.${var.internal_domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = ["${aws_elasticsearch_domain.elasticsearch6.endpoint}"]
}

# managed elasticsearch snapshots can't be given a prefix, so they
# need to live in their own bucket.
resource "aws_s3_bucket" "manual_snapshots" {
  bucket = "govuk-${var.aws_environment}-elasticsearch6-manual-snapshots"
  region = "${var.aws_region}"

  tags {
    Name            = "govuk-${var.aws_environment}-elasticsearch6-manual-snapshots"
    aws_environment = "${var.aws_environment}"
  }

  logging {
    target_bucket = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    target_prefix = "s3/govuk-${var.aws_environment}-elasticsearch6-manual-snapshots/"
  }
}

resource "aws_s3_bucket_policy" "manual_snapshots_cross_account_access" {
  bucket = "${aws_s3_bucket.manual_snapshots.id}"
  policy = "${data.aws_iam_policy_document.manual_snapshots_cross_account_access.json}"
}

data "aws_iam_policy_document" "manual_snapshots_cross_account_access" {
  statement {
    sid    = "CrossAccountAccess"
    effect = "Allow"

    principals = {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::210287912431:root",
        "arn:aws:iam::696911096973:root",
        "arn:aws:iam::172025368201:root",
      ]
    }

    # this bucket is only used for the data sync, not for actual
    # backups, so granting the ability to delete or modify things
    # (which elasticsearch needs - it tests it has access to the
    # bucket by writing to it!) doesn't risk anything important.
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:PutObjectAcl",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.manual_snapshots.id}",
      "arn:aws:s3:::${aws_s3_bucket.manual_snapshots.id}/*",
    ]
  }
}

resource "aws_iam_role" "manual_snapshot_role" {
  name = "${var.stackname}-elasticsearch6-manual-snapshot-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "es.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

data "aws_iam_policy_document" "manual_snapshot_bucket_policy" {
  statement {
    actions = [
      "s3:ListBucket",
    ]

    effect = "Allow"

    resources = ["${var.elasticsearch6_manual_snapshot_bucket_arns}"]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
    ]

    effect = "Allow"

    resources = ["${formatlist("%s/*", var.elasticsearch6_manual_snapshot_bucket_arns)}"]
  }
}

resource "aws_iam_policy" "manual_snapshot_bucket_policy" {
  name   = "govuk-${var.aws_environment}-elasticsearch6-manual-snapshot-bucket-policy"
  policy = "${data.aws_iam_policy_document.manual_snapshot_bucket_policy.json}"
}

resource "aws_iam_policy_attachment" "manual_snapshot_role_policy_attachment" {
  name       = "govuk-${var.aws_environment}-elasticsearch6-manual-snapshot-bucket-policy-attachment"
  roles      = ["${aws_iam_role.manual_snapshot_role.name}"]
  policy_arn = "${aws_iam_policy.manual_snapshot_bucket_policy.arn}"
}

# policy used (by a human!) to configure the elasticsearch domain to use the snapshot bucket, see:
# https://docs.aws.amazon.com/elasticsearch-service/latest/developerguide/es-managedomains-snapshots.html#es-managedomains-snapshot-prerequisites
resource "aws_iam_policy" "manual_snapshot_domain_configuration_policy" {
  name = "govuk-${var.aws_environment}-elasticsearch6-manual-snapshot-domain-configuration-policy"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "iam:PassRole",
      "Resource": "${aws_iam_role.manual_snapshot_role.arn}"
    },
    {
      "Effect": "Allow",
      "Action": "es:ESHttpPut",
      "Resource": "${aws_elasticsearch_domain.elasticsearch6.arn}/*"
    }
  ]
}
POLICY
}

# Outputs
# --------------------------------------------------------------

output "service_endpoint" {
  value       = "${aws_elasticsearch_domain.elasticsearch6.endpoint}"
  description = "Endpoint to submit index, search, and upload requests"
}

output "service_dns_name" {
  value       = "${aws_route53_record.service_record.fqdn}"
  description = "DNS name to access the Elasticsearch internal service"
}

output "domain_configuration_policy_arn" {
  value       = "${aws_iam_policy.manual_snapshot_domain_configuration_policy.arn}"
  description = "ARN of the policy used to configure the elasticsearch domain"
}

output "manual_snapshots_bucket_arn" {
  value       = "${aws_s3_bucket.manual_snapshots.arn}"
  description = "ARN of the bucket to store manual snapshots"
}
