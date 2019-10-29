/**
* ## Project: app-elasticsearch5
*
* Managed Elasticsearch 5 cluster
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

# managed elasticsearch snapshots can't be given a prefix, so they
# need to live in their own bucket.
resource "aws_s3_bucket" "manual_snapshots" {
  bucket = "govuk-${var.aws_environment}-elasticsearch5-manual-snapshots"
  region = "${var.aws_region}"

  tags {
    Name            = "govuk-${var.aws_environment}-elasticsearch5-manual-snapshots"
    aws_environment = "${var.aws_environment}"
  }

  logging {
    target_bucket = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    target_prefix = "s3/govuk-${var.aws_environment}-elasticsearch5-manual-snapshots/"
  }
}
