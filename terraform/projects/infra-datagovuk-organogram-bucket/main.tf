// datagovuk-organogram-bucket defines an S3 bucket to hold data.gov.uk organogram files.

terraform {
  backend "s3" {}
  required_version = "~> 1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    fastly = {
      source  = "fastly/fastly"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      terraform_deployment = basename(abspath(path.root))
      aws_environment      = var.aws_environment
    }
  }
}

provider "fastly" { api_key = "test" }

data "terraform_remote_state" "infra_monitoring" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket
    key    = "govuk/infra-monitoring.tfstate"
    region = var.aws_region
  }
}

resource "aws_s3_bucket" "datagovuk-organogram" {
  bucket = "datagovuk-${var.aws_environment}-ckan-organogram"
  tags   = { Name = "datagovuk-${var.aws_environment}-ckan-organogram" }
}

resource "aws_s3_bucket_versioning" "datagovuk_organogram" {
  bucket = aws_s3_bucket.datagovuk-organogram.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_logging" "datagovuk_organogram" {
  bucket        = aws_s3_bucket.datagovuk-organogram.id
  target_bucket = data.terraform_remote_state.infra_monitoring.outputs.aws_logging_bucket_id
  target_prefix = "s3/datagovuk-${var.aws_environment}-ckan-organogram/"
}

resource "aws_s3_bucket_cors_configuration" "datagovuk_organogram" {
  bucket = aws_s3_bucket.datagovuk-organogram.id
  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = [
      var.domain,
      "https://www.staging.data.gov.uk",
      "https://www.integration.data.gov.uk",
      "https://find.eks.production.govuk.digital",
      "https://find.eks.integration.govuk.digital",
      "https://find.eks.staging.govuk.digital"
    ]
  }
}

resource "aws_s3_bucket_policy" "govuk_datagovuk_organogram_read_policy" {
  bucket = aws_s3_bucket.datagovuk-organogram.id
  policy = data.aws_iam_policy_document.s3_fastly_read_policy_doc.json
}
