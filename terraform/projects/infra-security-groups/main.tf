/**
* ## Project: infra-security-groups
*
* Manage the security groups for the entire infrastructure
*/

variable "aws_environment" {
  type        = "string"
  description = "AWS Environment"
}

# Resources
# --------------------------------------------------------------

terraform {
  backend          "s3"             {}
  required_version = "= 0.11.14"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "2.33.0"
}

# used by the fastly ip ranges provider.
# an API key is needed but 'fake' seems to work.
provider "fastly" {
  api_key = "fake"
  version = "0.1.2"
}

data "fastly_ip_ranges" "fastly" {}

data "terraform_remote_state" "infra_vpc" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket}"
    key    = "${coalesce(var.remote_state_infra_vpc_key_stack, var.stackname)}/infra-vpc.tfstate"
    region = "${var.aws_region}"
  }
}
