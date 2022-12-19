/**
* ## Project: infra-athena-query-results
*
* This creates an S3 bucket that is intended for the storage of Athena query
* results conducted via the AWS web UI.
*
* This bucket is to be configured as the query result destination for the
* default workgroup, primary. This bucket will have to be connected to that
* workgroup via clickops as I can't find a good way to edit that automatically
* created workgroup, and it seems low value in using terraform to create a new
* workgroup that isn't the default (as I expect every user would forget to
* change it)
*/

variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-1"
}

variable "aws_environment" {
  type        = string
  description = "AWS Environment"
}

variable "stackname" {
  type        = string
  description = "Stackname"
}

# Resources
# --------------------------------------------------------------
terraform {
  backend "s3" {}
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_s3_bucket" "athena_query_results" {
  bucket = "govuk-${var.aws_environment}-athena-query-results"

  tags = {
    Name            = "govuk-${var.aws_environment}-athena-query-results"
    aws_environment = var.aws_environment
    project         = "infra-athena-query-results"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "athena_query_results_lifecycle" {
  bucket = aws_s3_bucket.athena_query_results.id

  rule {
    id     = "govuk-${var.aws_environment}-csp-reports-lifecycle"
    status = "Enabled"

    expiration {
      days = 7
    }
  }
}
