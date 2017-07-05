#
# Variables used in the security groups project
#

variable "stackname" {
  type        = "string"
  description = "The name of the stack being built. Must be unique within the environment as it's used for disambiguation."
}

variable "office_ips" {
  type        = "list"
  description = "An array of CIDR blocks that will be allowed offsite access."
}

variable "aws_region" {
  type        = "string"
  description = "AWS region"
  default     = "eu-west-1"
}
