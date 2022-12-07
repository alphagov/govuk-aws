/**
* ## Project: infra-csp-reporter
*
* Creates a HTTP endpoint of Content Security Policy report-uri, stores the
* data of reports in S3 and provides an Athena configuration to query them.
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

provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}
