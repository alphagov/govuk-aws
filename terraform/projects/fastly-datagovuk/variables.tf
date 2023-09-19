variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-1"
}

variable "stackname" {
  type        = string
  description = "Stackname"
}

variable "aws_environment" {
  type        = string
  description = "AWS Environment"
}

variable "fastly_api_key" {
  type        = string
  description = "API key to authenticate with Fastly"
}

variable "logging_aws_access_key_id" {
  type        = string
  description = "IAM key ID with access to put logs into the S3 bucket"
}

variable "logging_aws_secret_access_key" {
  type        = string
  description = "IAM secret key with access to put logs into the S3 bucket"
}

variable "domain" {
  type        = string
  description = "The domain of the data.gov.uk service to manage"
}

variable "backend_domain" {
  type        = string
  description = "The domain of the data.gov.uk PaaS instance to forward requests to"
}
