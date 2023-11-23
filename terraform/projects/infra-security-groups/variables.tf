#
# Variables used in the security groups project
#

variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-1"
}

variable "stackname" {
  type        = string
  description = "The name of the stack being built. Must be unique within the environment as it's used for disambiguation."
}

variable "remote_state_bucket" {
  type        = string
  description = "S3 bucket we store our terraform state in"
}

variable "remote_state_infra_vpc_key_stack" {
  type        = string
  description = "Override infra_vpc remote state path"
  default     = ""
}

variable "gds_egress_ips" {
  type        = list(string)
  description = "An array of CIDR blocks that will be allowed offsite access."
}

variable "traffic_replay_ips" {
  type        = list(string)
  description = "An array of CIDR blocks that will replay traffic against an environment"
}

variable "paas_ireland_egress_ips" {
  type        = list(string)
  description = "An array of CIDR blocks that are used for egress from the GOV.UK PaaS Ireland region"
  default     = []
}

variable "paas_london_egress_ips" {
  type        = list(string)
  description = "An array of CIDR blocks that are used for egress from the GOV.UK PaaS London region"
  default     = []
}

variable "ithc_access_ips" {
  type        = list(string)
  description = "An array of CIDR blocks that will be allowed temporary access for ITHC purposes."
  default     = []
}

variable "aws_integration_external_nat_gateway_ips" {
  type        = list(string)
  description = "An array of public IPs of the AWS integration external NAT gateways."
  default     = []
}

variable "aws_staging_external_nat_gateway_ips" {
  type        = list(string)
  description = "An array of public IPs of the AWS staging external NAT gateways."
  default     = []
}
