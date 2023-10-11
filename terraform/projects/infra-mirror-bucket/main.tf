/**
* ## Project: infra-mirror-bucket
*
* This project creates two s3 buckets: a primary s3 bucket to store the govuk
* mirror files and a replica s3 bucket which tracks the primary s3 bucket.
*
* The primary bucket should be in London and the backup in Ireland.
*
*/

variable "aws_region" {
  type        = string
  description = "AWS region where primary s3 bucket is located"
  default     = "eu-west-2"
}

variable "aws_replica_region" {
  type        = string
  description = "AWS region where replica s3 bucket is located"
  default     = "eu-west-1"
}

variable "aws_environment" {
  type        = string
  description = "AWS Environment"
}

variable "stackname" {
  type        = string
  description = "Stackname"
}

variable "remote_state_bucket" {
  type        = string
  description = "S3 bucket we store our terraform state in"
}

variable "remote_state_infra_monitoring_key_stack" {
  type        = string
  description = "Override stackname path to infra_monitoring remote state "
  default     = ""
}

variable "remote_state_infra_networking_key_stack" {
  type        = string
  description = "Override infra_networking remote state path"
  default     = ""
}

variable "office_ips" {
  type        = list
  description = "An array of CIDR blocks that will be allowed offsite access."
}

variable "eks_egress_ips" {
  type        = list(string)
  description = "Egress addresses for the corresponding EKS environment, in CIDR notation."
}

variable "lifecycle_main" {
  type        = string
  description = "Number of days for the lifecycle rule for the mirror"
  default     = "5"
}

variable "lifecycle_government_uploads" {
  type        = string
  description = "Number of days for the lifecycle rule for the mirror in the case where the prefix path is www.gov.uk/government/uploads/"
  default     = "8"
}

variable "remote_state_infra_vpc_key_stack" {
  type        = string
  description = "Override infra_vpc remote state path"
  default     = ""
}

variable "enable_replication" {
  type        = bool
  description = "Enable replication from the mirror bucket to its replica"
  default     = true
}

variable "enable_replica_lifecycle_rules" {
  type        = bool
  description = "Enable lifecycle rules for the mirror bucket's replica"
  default     = true
}

# Resources
# --------------------------------------------------------------

# Set up the backend & provider for each region
terraform {
  backend "s3" {}
  required_version = "= 0.13.6"

  required_providers {
    fastly = {
      source  = "fastly/fastly"
      version = ">= 3.0.4"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.76"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "aws" {
  region = var.aws_replica_region
  alias  = "aws_replica"
}

# This provider is no longer used, but at time of writing resources still exist that were created by it, so it can't be removed yet
provider "aws" {
  region = "us-east-1"
  alias  = "aws_cloudfront_certificate"
}

data "aws_caller_identity" "current" {}

data "terraform_remote_state" "infra_monitoring" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket
    key    = "${coalesce(var.remote_state_infra_monitoring_key_stack, var.stackname)}/infra-monitoring.tfstate"
    region = var.aws_replica_region
  }
}

data "terraform_remote_state" "infra_networking" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket
    key    = "${coalesce(var.remote_state_infra_networking_key_stack, var.stackname)}/infra-networking.tfstate"
    region = var.aws_replica_region
  }
}

data "terraform_remote_state" "infra_vpc" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket
    key    = "${coalesce(var.remote_state_infra_vpc_key_stack, var.stackname)}/infra-vpc.tfstate"
    region = var.aws_replica_region
  }
}

resource "aws_s3_bucket" "govuk-mirror" {
  bucket = "govuk-${var.aws_environment}-mirror"

  tags = {
    Name            = "govuk-${var.aws_environment}-mirror"
    aws_environment = var.aws_environment
  }

  logging {
    target_bucket = data.terraform_remote_state.infra_monitoring.outputs.aws_secondary_logging_bucket_id
    target_prefix = "s3/govuk-${var.aws_environment}-mirror/"
  }

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "main"
    enabled = true

    prefix = ""

    noncurrent_version_expiration {
      days = var.lifecycle_main
    }
  }

  lifecycle_rule {
    id      = "government_uploads"
    enabled = true

    prefix = "www.gov.uk/government/uploads/"

    noncurrent_version_expiration {
      days = var.lifecycle_government_uploads
    }
  }

  dynamic "replication_configuration" {
    for_each = var.enable_replication ? [1] : []

    content {
      role = aws_iam_role.govuk_mirror_replication_role.arn

      rules {
        id     = "govuk-mirror-replication-whole-bucket-rule"
        prefix = ""
        status = "Enabled"

        destination {
          bucket        = aws_s3_bucket.govuk-mirror-replica.arn
          storage_class = "STANDARD"
        }
      }
    }
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket" "govuk-mirror-replica" {
  bucket   = "govuk-${var.aws_environment}-mirror-replica"
  provider = aws.aws_replica

  tags = {
    Name            = "govuk-${var.aws_environment}-mirror-replica"
    Status          = var.enable_replication ? null : "Not in use in ${var.aws_environment} environment"
    aws_environment = var.aws_environment
  }

  logging {
    target_bucket = data.terraform_remote_state.infra_monitoring.outputs.aws_logging_bucket_id
    target_prefix = "s3/govuk-${var.aws_environment}-mirror-replica/"
  }

  versioning {
    enabled = true
  }

  dynamic "lifecycle_rule" {
    for_each = var.enable_replica_lifecycle_rules ? [1] : []

    content {
      id      = "main"
      enabled = true

      prefix = ""

      noncurrent_version_expiration {
        days = var.lifecycle_main
      }
    }
  }

  dynamic "lifecycle_rule" {
    for_each = var.enable_replica_lifecycle_rules ? [1] : []

    content {
      id      = "government_uploads"
      enabled = true

      prefix = "www.gov.uk/government/uploads/"

      noncurrent_version_expiration {
        days = var.lifecycle_government_uploads
      }
    }
  }
}

resource "aws_s3_bucket_policy" "govuk_mirror_read_policy" {
  bucket = aws_s3_bucket.govuk-mirror.id
  policy = data.aws_iam_policy_document.s3_mirror_read_policy_doc.json
}

resource "aws_s3_bucket_policy" "govuk_mirror_replica_read_policy" {
  bucket   = aws_s3_bucket.govuk-mirror-replica.id
  policy   = data.aws_iam_policy_document.s3_mirror_replica_read_policy_doc.json
  provider = aws.aws_replica
}

# S3 backup replica role configuration
data "template_file" "s3_govuk_mirror_replication_role_template" {
  template = file("${path.module}/../../policies/s3_govuk_mirror_replication_role.tpl")
}

# Adding backup replication role
resource "aws_iam_role" "govuk_mirror_replication_role" {
  name               = "${var.stackname}-mirror-replication-role"
  assume_role_policy = data.template_file.s3_govuk_mirror_replication_role_template.rendered
}

data "template_file" "s3_govuk_mirror_replication_policy_template" {
  template = file("${path.module}/../../policies/s3_govuk_mirror_replication_policy.tpl")

  vars = {
    govuk_mirror_arn         = aws_s3_bucket.govuk-mirror.arn
    govuk_mirror_replica_arn = aws_s3_bucket.govuk-mirror-replica.arn
    aws_account_id           = data.aws_caller_identity.current.account_id
  }
}

# Adding backup replication policy
resource "aws_iam_policy" "govuk_mirror_replication_policy" {
  name        = "govuk-${var.aws_environment}-mirror-buckets-replication-policy"
  policy      = data.template_file.s3_govuk_mirror_replication_policy_template.rendered
  description = "Allows replication of the mirror buckets"
}

# Combine the role and policy
resource "aws_iam_policy_attachment" "govuk_mirror_replication_policy_attachment" {
  name       = "s3-govuk-mirror-replication-policy-attachment"
  roles      = [aws_iam_role.govuk_mirror_replication_role.name]
  policy_arn = aws_iam_policy.govuk_mirror_replication_policy.arn
}

data "template_file" "s3_govuk_mirror_read_policy_template" {
  template = file("${path.module}/../../policies/s3_govuk_mirror_read_policy.tpl")

  vars = {
    govuk_mirror_arn = aws_s3_bucket.govuk-mirror.arn
  }
}

resource "aws_iam_policy" "govuk_mirror_read_policy" {
  name        = "govuk-${var.aws_environment}-mirror-read-policy"
  policy      = data.template_file.s3_govuk_mirror_read_policy_template.rendered
  description = "Allow the listing and reading of the primary govuk mirror bucket"
}

resource "aws_iam_user" "govuk_mirror_google_reader" {
  name = "govuk_mirror_google_reader"
}

resource "aws_iam_policy_attachment" "govuk_mirror_read_policy_attachment" {
  name       = "s3-govuk-mirror-read-policy-attachment"
  users      = [aws_iam_user.govuk_mirror_google_reader.name]
  policy_arn = aws_iam_policy.govuk_mirror_read_policy.arn
}
