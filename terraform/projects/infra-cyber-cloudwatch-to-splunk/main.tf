
variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-1"
}

variable "splunk_destination_v2_arn" {
  type        = string
  description = "The ARN of v2 of Cyber Security's centralised security logging service (https://github.com/alphagov/centralised-security-logging-service)"
}

terraform {
  backend "s3" {}
  required_version = "~> 1.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.25"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_cloudwatch_log_subscription_filter" "log_subscription_v2" {
  name            = "log_subscription_python"
  log_group_name  = "auth-log"
  filter_pattern  = ""
  destination_arn = var.splunk_destination_v2_arn
}
