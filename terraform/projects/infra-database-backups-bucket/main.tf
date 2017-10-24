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

# Set up the backend & provider for each region
terraform {
  backend          "s3"             {}
  required_version = "= 0.10.7"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "1.0.0"
}

resource "aws_s3_bucket" "database_backups" {
  bucket = "govuk-${var.aws_environment}-database-backups"

  tags {
    Name            = "govuk-${var.aws_environment}-database-backups"
    aws_environment = "${var.aws_environment}"
  }
}
