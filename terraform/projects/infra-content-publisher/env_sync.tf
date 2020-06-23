variable "aws_test_account_root_arn" {
  type        = "string"
  description = "root arn of the aws test account of govuk"
  default     = ""
}

variable "aws_staging_account_root_arn" {
  type        = "string"
  description = "root arn of the aws staging account of govuk"
  default     = ""
}

variable "aws_integration_account_root_arn" {
  type        = "string"
  description = "root arn of the aws integration account of govuk"
  default     = ""
}

# Resources
# --------------------------------------------------------------
resource "aws_s3_bucket_policy" "test_cross_account_access_to_integration" {
  count  = "${var.aws_environment == "integration" ? 1 : 0}"
  bucket = "${aws_s3_bucket.activestorage.id}"
  policy = "${data.aws_iam_policy_document.test_cross_account_access_to_integration.json}"
}

data "aws_iam_policy_document" "test_cross_account_access_to_integration" {
  statement {
    effect = "Allow"

    principals = {
      type = "AWS"

      identifiers = [
        "${var.aws_test_account_root_arn}", # govuk-infrastructure-test
      ]
    }

    actions = [
      "s3:List*",
      "s3:Get*",
    ]

    resources = [
      "arn:aws:s3:::govuk-integration-content-publisher-activestorage",
      "arn:aws:s3:::govuk-integration-content-publisher-activestorage/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "integration_cross_account_access_to_staging" {
  count  = "${var.aws_environment == "staging" ? 1 : 0}"
  bucket = "${aws_s3_bucket.activestorage.id}"
  policy = "${data.aws_iam_policy_document.integration_cross_account_access_to_staging.json}"
}

data "aws_iam_policy_document" "integration_cross_account_access_to_staging" {
  statement {
    effect = "Allow"

    principals = {
      type = "AWS"

      identifiers = [
        "${var.aws_integration_account_root_arn}", # govuk-infrastructure-integration
      ]
    }

    actions = [
      "s3:List*",
      "s3:Get*",
    ]

    resources = [
      "arn:aws:s3:::govuk-staging-content-publisher-activestorage",
      "arn:aws:s3:::govuk-staging-content-publisher-activestorage/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "staging_cross_account_access_to_production" {
  count  = "${var.aws_environment == "production" ? 1 : 0}"
  bucket = "${aws_s3_bucket.activestorage.id}"
  policy = "${data.aws_iam_policy_document.staging_cross_account_access_to_production.json}"
}

data "aws_iam_policy_document" "staging_cross_account_access_to_production" {
  statement {
    effect = "Allow"

    principals = {
      type = "AWS"

      identifiers = [
        "${var.aws_staging_account_root_arn}", # govuk-infrastructure-staging
      ]
    }

    actions = [
      "s3:List*",
      "s3:Get*",
    ]

    resources = [
      "arn:aws:s3:::govuk-production-content-publisher-activestorage",
      "arn:aws:s3:::govuk-production-content-publisher-activestorage/*",
    ]
  }
}

resource "aws_iam_policy" "integration_content_publisher_active_storage_reader_writer" {
  name        = "integration_content_publisher_active_storage-reader_writer-policy"
  policy      = "${data.aws_iam_policy_document.integration_content_publisher_active_storage_reader_writer.json}"
  description = "Allows reading and writing the integration content publisher active storage bucket"
}

data "aws_iam_policy_document" "integration_content_publisher_active_storage_reader_writer" {
  statement {
    sid = "IntegrationContentPublisherActiveStorageReaderWriter"

    actions = [
      "s3:Get*",
      "s3:List*",
      "s3:Put*",
      "s3:DeleteObject",
    ]

    # Need access to the top level of the tree.
    resources = [
      "arn:aws:s3:::govuk-integration-content-publisher-activestorage",
      "arn:aws:s3:::govuk-integration-content-publisher-activestorage/*",
    ]
  }
}

resource "aws_iam_policy" "staging_content_publisher_active_storage_reader" {
  name        = "staging_content_publisher_active_storage-reader-policy"
  policy      = "${data.aws_iam_policy_document.staging_content_publisher_active_storage_reader.json}"
  description = "Allows reading the staging content publisher active storage bucket"
}

data "aws_iam_policy_document" "staging_content_publisher_active_storage_reader" {
  statement {
    sid = "StagingContentPublisherActiveStorageReader"

    actions = [
      "s3:Get*",
      "s3:List*",
    ]

    # Need access to the top level of the tree.
    resources = [
      "arn:aws:s3:::govuk-staging-content-publisher-activestorage",
      "arn:aws:s3:::govuk-staging-content-publisher-activestorage/*",
    ]
  }
}

resource "aws_iam_policy" "staging_content_publisher_active_storage_reader_writer" {
  name        = "staging_content_publisher_active_storage-reader_writer-policy"
  policy      = "${data.aws_iam_policy_document.staging_content_publisher_active_storage_reader_writer.json}"
  description = "Allows reading and writing the staging content publisher active storage bucket"
}

data "aws_iam_policy_document" "staging_content_publisher_active_storage_reader_writer" {
  statement {
    sid = "StagingContentPublisherActiveStorageReaderWriter"

    actions = [
      "s3:Get*",
      "s3:List*",
      "s3:Put*",
      "s3:DeleteObject",
    ]

    # Need access to the top level of the tree.
    resources = [
      "arn:aws:s3:::govuk-staging-content-publisher-activestorage",
      "arn:aws:s3:::govuk-staging-content-publisher-activestorage/*",
    ]
  }
}

resource "aws_iam_policy" "production_content_publisher_active_storage_reader" {
  name        = "production_content_publisher_active_storage-reader-policy"
  policy      = "${data.aws_iam_policy_document.production_content_publisher_active_storage_reader.json}"
  description = "Allows reading the production content publisher active storage bucket"
}

data "aws_iam_policy_document" "production_content_publisher_active_storage_reader" {
  statement {
    sid = "ProductionContentPublisherActiveStorageReader"

    actions = [
      "s3:Get*",
      "s3:List*",
    ]

    # Need access to the top level of the tree.
    resources = [
      "arn:aws:s3:::govuk-production-content-publisher-activestorage",
      "arn:aws:s3:::govuk-production-content-publisher-activestorage/*",
    ]
  }
}

# Outputs
# --------------------------------------------------------------

output "integration_content_publisher_active_storage_bucket_reader_writer_policy_arn" {
  value       = "${aws_iam_policy.integration_content_publisher_active_storage_reader_writer.arn}"
  description = "ARN of the staging content publisher storage bucket reader writer policy"
}

output "staging_content_publisher_active_storage_bucket_reader_policy_arn" {
  value       = "${aws_iam_policy.staging_content_publisher_active_storage_reader.arn}"
  description = "ARN of the staging content publisher storage bucket reader policy"
}

output "staging_content_publisher_active_storage_bucket_reader_writer_policy_arn" {
  value       = "${aws_iam_policy.staging_content_publisher_active_storage_reader_writer.arn}"
  description = "ARN of the staging content publisher storage bucket reader writer policy"
}

output "production_content_publisher_active_storage_bucket_reader_policy_arn" {
  value       = "${aws_iam_policy.production_content_publisher_active_storage_reader.arn}"
  description = "ARN of the production content publisher storage bucket reader policy"
}
