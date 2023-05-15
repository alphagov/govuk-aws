/**
* ## Project: app-whitehall-backend
*
* Whitehall Backend nodes
*/

terraform {
  backend "s3" {}
}

provider "aws" {
  region  = var.aws_region
  version = "2.46.0"
}

resource "aws_s3_bucket" "whitehall_csvs" {
  bucket = "govuk-${var.aws_environment}-whitehall-csvs"

  tags = {
    name            = "govuk-${var.aws_environment}-whitehall-csvs"
    aws_environment = var.aws_environment
  }

  logging {
    target_bucket = data.terraform_remote_state.infra_monitoring.outputs.aws_logging_bucket_id
    target_prefix = "s3/govuk-${var.aws_environment}-whitehall-csvs/"
  }
}
