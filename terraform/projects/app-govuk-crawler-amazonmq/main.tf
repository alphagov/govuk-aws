/**
 * ## Project: app-govuk-crawler-amazonmq
 * 
 */

terraform {
  backend "s3" {}
  required_version = ">= 1.1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    local = {
      version = "~> 2.2.3"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
