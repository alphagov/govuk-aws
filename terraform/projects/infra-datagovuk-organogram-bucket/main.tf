/**
* ## Project: datagovuk-organogram-bucket
*
* This creates an s3 bucket
*
* datagovuk-organogram-bucket: A bucket to hold data.gov.uk organogram files
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

variable "domain" {
  type        = "string"
  description = "The domain of the data.gov.uk service to manage"
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

resource "aws_s3_bucket" "datagovuk-organogram" {
  bucket = "datagovuk-${var.aws_environment}-ckan-organogram"

  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = "${compact(list(var.domain, var.aws_environment == "production" ? "https://staging.data.gov.uk" : ""))}"
  }

  tags {
    Name            = "datagovuk-${var.aws_environment}-ckan-organogram"
    aws_environment = "${var.aws_environment}"
  }

  logging {
    target_bucket = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    target_prefix = "s3/datagovuk-${var.aws_environment}-ckan-organogram/"
  }

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_policy" "govuk_datagovuk_organogram_read_policy" {
  bucket = "${aws_s3_bucket.datagovuk-organogram.id}"
  policy = "${data.aws_iam_policy_document.s3_fastly_read_policy_doc.json}"
}
