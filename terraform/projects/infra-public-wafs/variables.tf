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
