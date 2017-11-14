/**
*  ## Project: artefact-bucket
*
* This creates 3 s3 buckets
*
* artefact: The bucket that will hold the artefacts
* artefact_access_logs: Bucket for logs to go to
* artefact_replication_destination: Bucket in another region to replicate to
*/
variable "aws_region" {
  type        = "string"
  description = "AWS region"
  default     = "eu-west-1"
}

variable "aws_secondary_region" {
  type        = "string"
  description = "Secondary region for cross-replication"
  default     = "eu-west-2"
}

variable "aws_environment" {
  type        = "string"
  description = "AWS Environment"
}

# Set up the backend & provider for each region
terraform {
  backend          "s3"             {}
  required_version = "= 0.10.8"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "1.0.0"
}

provider "aws" {
  alias   = "secondary"
  region  = "${var.aws_secondary_region}"
  version = "1.0.0"
}

# Create the buckets
# Logs bucket
resource "aws_s3_bucket" "artefact_access_logs" {
  bucket = "govuk-${var.aws_environment}-artefact-access-logs"
  acl    = "log-delivery-write"

  versioning {
    enabled = true
  }
}

# Replication bucket (different region to the other buckets)
resource "aws_s3_bucket" "artefact_replication_destination" {
  provider = "aws.secondary"
  bucket   = "govuk-${var.aws_environment}-artefact-replication-destination"

  versioning {
    enabled = true
  }
}

# Main bucket
resource "aws_s3_bucket" "artefact" {
  bucket = "govuk-${var.aws_environment}-artefact"
  acl    = "public-read"

  tags {
    Name            = "govuk-${var.aws_environment}-artefact"
    aws_environment = "${var.aws_environment}"
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = "${aws_s3_bucket.artefact_access_logs.id}"
    target_prefix = "log/"
  }

  replication_configuration {
    role = "${aws_iam_role.artefact_replication.arn}"

    rules {
      status = "Enabled"
      prefix = ""

      destination {
        bucket = "${aws_s3_bucket.artefact_replication_destination.arn}"
      }
    }
  }
}
