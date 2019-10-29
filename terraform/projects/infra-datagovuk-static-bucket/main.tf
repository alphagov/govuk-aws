/**
* ## Project: datagovuk-static-bucket
*
* This creates an s3 bucket
*
* datagovuk-static-bucket: A bucket to hold legacy CKAN static data and assets
*
*/

variable "aws_region" {
  type        = "string"
  description = "AWS region"
  default     = "eu-west-1"
}

variable "aws_environment" {
  type        = "string"
  description = "AWS Environment"
}

variable "stackname" {
  type        = "string"
  description = "Stackname"
}

variable "remote_state_bucket" {
  type        = "string"
  description = "S3 bucket we store our terraform state in"
}

variable "remote_state_infra_monitoring_key_stack" {
  type        = "string"
  description = "Override stackname path to infra_monitoring remote state "
  default     = ""
}

variable "s3_bucket_read_ips" {
  type        = "list"
  description = "Additional IPs to allow read access from"
}

# Set up the backend & provider for each region
terraform {
  backend          "s3"             {}
  required_version = "= 0.11.14"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "2.33.0"
}

data "terraform_remote_state" "infra_monitoring" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket}"
    key    = "${coalesce(var.remote_state_infra_monitoring_key_stack, var.stackname)}/infra-monitoring.tfstate"
    region = "${var.aws_region}"
  }
}

resource "aws_s3_bucket" "datagovuk-static" {
  bucket = "datagovuk-${var.aws_environment}-ckan-static-data"

  tags {
    Name            = "datagovuk-${var.aws_environment}-ckan-static-data"
    aws_environment = "${var.aws_environment}"
  }

  logging {
    target_bucket = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    target_prefix = "s3/datagovuk-${var.aws_environment}-ckan-static-data/"
  }

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_policy" "govuk_datagovuk_static_read_policy" {
  bucket = "${aws_s3_bucket.datagovuk-static.id}"
  policy = "${data.aws_iam_policy_document.s3_fastly_read_policy_doc.json}"
}
