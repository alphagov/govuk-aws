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

variable "fastly_rate_limit_token" {
  type        = string
  description = "Token used by the CDN to skip rate limiting"
  default     = ""
}

variable "backend_public_base_rate_warning" {
  type        = number
  description = "For the backend ALB. Allows us to configure a warning level to detect what happens if we reduce the limit."
}

variable "backend_public_base_rate_limit" {
  type        = number
  description = "For the backend ALB. Number of requests to allow in a 5 minute period before rate limiting is applied."
}

variable "backend_public_ja3_denylist" {
  type        = list(string)
  description = "For the backend ALB. List of JA3 signatures for which we should block all requests."
}

variable "bouncer_public_base_rate_warning" {
  type        = number
  description = "For the bouncer ALB. Allows us to configure a warning level to detect what happens if we reduce the limit."
}

variable "bouncer_public_base_rate_limit" {
  type        = number
  description = "For the bouncer ALB. Number of requests to allow in a 5 minute period before rate limiting is applied."
}

variable "cache_public_base_rate_warning" {
  type        = number
  description = "For the cache ALB. Allows us to configure a warning level to detect what happens if we reduce the limit."
}

variable "cache_public_base_rate_limit" {
  type        = number
  description = "For the cache ALB. Number of requests to allow in a 5 minute period before rate limiting is applied."
}

variable "traffic_replay_ips" {
  type        = list(string)
  description = "An array of CIDR blocks that will replay traffic against an environment"
}

variable "eks_egress_ips" {
  type        = list(string)
  description = "An array of CIDR blocks for the corresponding EKS environment's NAT gateway IPs"
}

variable "allow_high_request_rate_from_cidrs" {
  type        = list(string)
  description = "Source IP netblocks from which we allow a higher rate of requests."
}

variable "waf_log_retention_days" {
  type        = string
  description = "The number of days CloudWatch will retain WAF logs for."
  default     = "30"
}
