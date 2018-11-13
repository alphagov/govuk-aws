#
# Variables used in the security groups project
#

variable "aws_region" {
  type        = "string"
  description = "AWS region"
  default     = "eu-west-1"
}

variable "stackname" {
  type        = "string"
  description = "The name of the stack being built. Must be unique within the environment as it's used for disambiguation."
}

variable "remote_state_bucket" {
  type        = "string"
  description = "S3 bucket we store our terraform state in"
}

variable "remote_state_infra_vpc_key_stack" {
  type        = "string"
  description = "Override infra_vpc remote state path"
  default     = ""
}

variable "office_ips" {
  type        = "list"
  description = "An array of CIDR blocks that will be allowed offsite access."
}

variable "carrenza_integration_ips" {
  type        = "list"
  description = "An array of CIDR blocks that will be allowed to SSH to the jumpbox."
}

variable "carrenza_staging_ips" {
  type        = "list"
  description = "An array of CIDR blocks that will be allowed to SSH to the jumpbox."
}

variable "carrenza_production_ips" {
  type        = "list"
  description = "An array of CIDR blocks that will be allowed to SSH to the jumpbox."
}

variable "carrenza_env_ips" {
  type        = "list"
  description = "An array of CIDR blocks for the current environment that will be allowed to SSH to the jumpbox."
}

variable "traffic_replay_ips" {
  type        = "list"
  description = "An array of CIDR blocks that will replay traffic against an environment"
}

variable "ckan_pentest_allowed_ips" {
  type        = "list"
  description = "An array of CIDR blocks that will be used for penetration testing in CKAN"
}
