variable "remote_state_bucket" {
  type        = string
  description = "S3 bucket we store our terraform state in"
}

variable "remote_state_infra_database_backups_bucket_key_stack" {
  type        = string
  description = "Override path to infra_database_backups_bucket remote state"
  default     = ""
}

variable "remote_state_infra_monitoring_key_stack" {
  type        = string
  description = "Override path to infra_monitoring remote state"
  default     = ""
}

variable "remote_state_infra_networking_key_stack" {
  type        = string
  description = "Override path to infra_networking remote state"
  default     = ""
}

variable "remote_state_infra_security_groups_key_stack" {
  type        = string
  description = "Override path to infra_security_groups remote state"
  default     = ""
}

data "terraform_remote_state" "infra_database_backups_bucket" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket
    key    = "${coalesce(var.remote_state_infra_database_backups_bucket_key_stack, var.stackname)}/infra-database-backups-bucket.tfstate"
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
