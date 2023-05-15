/**
* ## Manifest: remote_state
*
* This file is generated by generate-remote-state-boiler-plate.sh. DO NOT EDIT
*
* Create infrastructure data resources
*/

variable "remote_state_bucket" {
  description = "S3 bucket we store our terraform state in"
}

variable "remote_state_infra_vpc_key_stack" {
  description = "Override infra_vpc remote state path"
  default     = ""
}

variable "remote_state_infra_networking_key_stack" {
  description = "Override infra_networking remote state path"
  default     = ""
}

variable "remote_state_infra_security_groups_key_stack" {
  description = "Override infra_security_groups stackname path to infra_vpc remote state "
  default     = ""
}

variable "remote_state_infra_root_dns_zones_key_stack" {
  description = "Override stackname path to infra_root_dns_zones remote state "
  default     = ""
}

variable "remote_state_infra_stack_dns_zones_key_stack" {
  description = "Override stackname path to infra_stack_dns_zones remote state "
  default     = ""
}

variable "remote_state_infra_monitoring_key_stack" {
  description = "Override stackname path to infra_monitoring remote state "
  default     = ""
}

# Resources
# --------------------------------------------------------------

data "terraform_remote_state" "infra_vpc" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket
    key    = "${coalesce(var.remote_state_infra_vpc_key_stack, var.stackname)}/infra-vpc.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "infra_networking" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket
    key    = "${coalesce(var.remote_state_infra_networking_key_stack, var.stackname)}/infra-networking.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "infra_security_groups" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket
    key    = "${coalesce(var.remote_state_infra_security_groups_key_stack, var.stackname)}/infra-security-groups.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "infra_root_dns_zones" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket
    key    = "${coalesce(var.remote_state_infra_root_dns_zones_key_stack, var.stackname)}/infra-root-dns-zones.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "infra_stack_dns_zones" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket
    key    = "${coalesce(var.remote_state_infra_stack_dns_zones_key_stack, var.stackname)}/infra-stack-dns-zones.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "infra_monitoring" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket
    key    = "${coalesce(var.remote_state_infra_monitoring_key_stack, var.stackname)}/infra-monitoring.tfstate"
    region = var.aws_region
  }
}
