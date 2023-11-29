variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-1"
}

variable "aws_environment" {
  type        = string
  description = "AWS Environment"
}

variable "domain" {
  type        = string
  description = "The domain of the data.gov.uk service to manage"
}

variable "remote_state_bucket" {
  type        = string
  description = "S3 bucket we store our terraform state in"
}
