/**
* ## Project: database-backups-bucket
*
* This creates an s3 bucket
*
* database-backups: The bucket that will hold database backups
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

# Set up the backend & provider for each region
terraform {
  backend          "s3"             {}
  required_version = "= 0.11.2"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "1.0.0"
}

data "terraform_remote_state" "infra_monitoring" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket}"
    key    = "${coalesce(var.remote_state_infra_monitoring_key_stack, var.stackname)}/infra-monitoring.tfstate"
    region = "eu-west-1"
  }
}

resource "aws_s3_bucket" "database_backups" {
  bucket = "govuk-${var.aws_environment}-database-backups"

  tags {
    Name            = "govuk-${var.aws_environment}-database-backups"
    aws_environment = "${var.aws_environment}"
  }

  logging {
    target_bucket = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    target_prefix = "s3/govuk-${var.aws_environment}-database-backups/"
  }

  lifecycle_rule {
    prefix  = "mysql/"
    enabled = true

    transition {
      storage_class = "STANDARD_IA"
      days          = 30
    }

    transition {
      storage_class = "GLACIER"
      days          = 90
    }

    expiration {
      days = 120
    }
  }

  lifecycle_rule {
    prefix  = "postgres/"
    enabled = true

    transition {
      storage_class = "STANDARD_IA"
      days          = 30
    }

    transition {
      storage_class = "GLACIER"
      days          = 90
    }

    expiration {
      days = 120
    }
  }

  lifecycle_rule {
    prefix  = "mongodb/daily"
    enabled = true

    transition {
      storage_class = "STANDARD_IA"
      days          = 30
    }

    transition {
      storage_class = "GLACIER"
      days          = 90
    }

    expiration {
      days = 120
    }
  }

  lifecycle_rule {
    prefix  = "mongodb/regular"
    enabled = true

    expiration {
      days = 7
    }
  }
}
