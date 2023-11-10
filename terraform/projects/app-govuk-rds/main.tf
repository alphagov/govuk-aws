terraform {
  backend "s3" {}
  required_version = "~> 1.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Project         = basename(abspath(path.root))
      aws_stackname   = var.stackname
      aws_environment = var.aws_environment
    }
  }
}
