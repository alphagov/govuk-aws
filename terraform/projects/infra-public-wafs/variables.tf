variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-1"
}

variable "stackname" {
  type        = string
  description = "Stackname"
  default     = "govuk"
}

variable "aws_environment" {
  type        = string
  description = "AWS Environment"
}

locals {
  tags = {
    Project         = var.stackname
    aws_stackname   = var.stackname
    aws_environment = var.aws_environment
  }
}

variable "remote_state_infra_public_services_key_stack" {
  type        = string
  description = "Override path to infra_public_services remote state"
  default     = ""
}

data "terraform_remote_state" "infra_public_services" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket
    key    = "${coalesce(var.remote_state_infra_public_services_key_stack, var.stackname)}/infra-public-services.tfstate"
    region = var.aws_region
  }
}
