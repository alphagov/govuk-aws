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

variable "domain_name" {
  type        = string
  description = "The domain name for API Gateway, must CNAME to csp-reporter.<environment>.govuk.digital"
}

variable "certificate_arn" {
  type        = string
  description = "Certificate to use for the API Gateway domain name, must cover domain name and *.<environment>.govuk.digital"
}

locals {
  project_name = "infra-csp-reporter"
}

