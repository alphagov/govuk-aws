variable "remote_state_bucket" {
  type        = string
  description = "Name of S3 bucket containing legacy remote Terraform state"
}

data "terraform_remote_state" "infra_vpc" {
  backend = "s3"
  config = {
    bucket = var.remote_state_bucket
    key    = "govuk/infra-vpc.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "infra_networking" {
  backend = "s3"
  config = {
    bucket = var.remote_state_bucket
    key    = "govuk/infra-networking.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "infra_security_groups" {
  backend = "s3"
  config = {
    bucket = var.remote_state_bucket
    key    = "govuk/infra-security-groups.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "infra_root_dns_zones" {
  backend = "s3"
  config = {
    bucket = var.remote_state_bucket
    key    = "govuk/infra-root-dns-zones.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "infra_monitoring" {
  backend = "s3"
  config = {
    bucket = var.remote_state_bucket
    key    = "govuk/infra-monitoring.tfstate"
    region = var.aws_region
  }
}
