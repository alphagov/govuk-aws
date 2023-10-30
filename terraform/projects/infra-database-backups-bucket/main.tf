/**
* ## Project: database-backups-bucket
*
* This creates an s3 bucket
*
* database-backups: The bucket that will hold database backups
*
*/

variable "aws_region" {
  type        = "string"
  description = "AWS region"
  default     = "eu-west-1"
}

variable "aws_backup_region" {
  type        = "string"
  description = "AWS region"
  default     = "eu-west-2"
}

variable "aws_environment" {
  type        = "string"
  description = "AWS Environment"
}

variable "stackname" {
  type        = "string"
  description = "Stackname"
}

variable "remote_state_bucket" {
  type        = "string"
  description = "S3 bucket we store our terraform state in"
}

variable "remote_state_infra_monitoring_key_stack" {
  type        = "string"
  description = "Override stackname path to infra_monitoring remote state "
  default     = ""
}

# Set up the backend & provider for each region
terraform {
  backend "s3" {}
  required_version = "~> 0.12.31"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "2.46.0"
}

provider "aws" {
  alias   = "eu-london"
  region  = "${var.aws_backup_region}"
  version = "2.46.0"
}

data "terraform_remote_state" "infra_monitoring" {
  backend = "s3"

  config = {
    bucket = "${var.remote_state_bucket}"
    key    = "${coalesce(var.remote_state_infra_monitoring_key_stack, var.stackname)}/infra-monitoring.tfstate"
    region = "${var.aws_region}"
  }
}

resource "aws_s3_bucket" "database_backups" {
  bucket = "govuk-${var.aws_environment}-database-backups"
  region = "${var.aws_region}"

  tags = {
    Name            = "govuk-${var.aws_environment}-database-backups"
    aws_environment = "${var.aws_environment}"
  }

  logging {
    target_bucket = "${data.terraform_remote_state.infra_monitoring.outputs.aws_logging_bucket_id}"
    target_prefix = "s3/govuk-${var.aws_environment}-database-backups/"
  }

  versioning {
    # It's not entirely clear if versioning is useful on this bucket – but it was previously configured this way,
    # so we've decided not to change it. Whilst it helps protect against accidental deletion, it doesn't protect
    # against malicious actors, so shouldn't be considered a security feature.
    enabled = true
  }

  lifecycle_rule {
    # Use a long retention period in production
    id      = "long_retention_period"
    enabled = "${var.aws_environment == "production"}"

    # Ideally everything would go in the Standard (Infrequent Access) storage class when created.
    # But newly created objects always go into Standard, and can only move into IA after at least 30 days.
    # https://docs.aws.amazon.com/AmazonS3/latest/userguide/lifecycle-transition-general-considerations.html
    transition {
      storage_class = "STANDARD_IA"
      days          = 30
    }

    # Likewise, we have to wait at least another 30 days before we can move objects into Glacier storage.
    transition {
      storage_class = "GLACIER"
      days          = 60
    }

    # Versioning is enabled on this bucket, so this rule will 'soft delete' objects.
    # In AWS lingo, this means a 'delete marker' will be set on the current version of the object.
    # More info on how expiration rules apply to versioned buckets here:
    # https://docs.aws.amazon.com/AmazonS3/latest/userguide/intro-lifecycle-rules.html#intro-lifecycle-rules-actions
    expiration {
      days = 120
    }

    # This rule will 'hard delete' objects 1 day after they were 'soft deleted'.
    # In other words: old database backups will be permanently deleted 1 day after they've expired.
    noncurrent_version_expiration {
      days = "1"
    }
  }

  lifecycle_rule {
    # Use a short retention period in integration and staging
    id      = "short_retention_period"
    enabled = "${var.aws_environment != "production"}"

    expiration {
      days = "3"
    }

    noncurrent_version_expiration {
      days = "1"
    }
  }

  replication_configuration {
    role = "${aws_iam_role.backup_replication_role.arn}"

    rules {
      id     = "main_replication_rule"
      status = "Enabled"

      destination {
        bucket        = "${aws_s3_bucket.database_backups_replica.arn}"
        storage_class = "STANDARD_IA"
      }
    }
  }
}

# Bucket in the second region (Backup of the backup)
resource "aws_s3_bucket" "database_backups_replica" {
  bucket   = "govuk-${var.aws_environment}-database-backups-replica"
  region   = "${var.aws_backup_region}"
  provider = "aws.eu-london"

  tags = {
    Name            = "govuk-${var.aws_environment}-database-backups-replica"
    aws_environment = "${var.aws_environment}"
  }

  versioning {
    enabled = true
  }

  # Use the same lifecycle rules as the source bucket
  # This ensures the replica bucket gets cleaned up in a timely manner
  lifecycle_rule {
    # Use a long retention period in production
    id      = "long_retention_period"
    enabled = "${var.aws_environment == "production"}"

    transition {
      storage_class = "STANDARD_IA"
      days          = 30
    }

    transition {
      storage_class = "GLACIER"
      days          = 60
    }

    expiration {
      days = 120
    }

    noncurrent_version_expiration {
      days = "1"
    }
  }

  lifecycle_rule {
    # Use a short retention period in integration and staging
    id      = "short_retention_period"
    enabled = "${var.aws_environment != "production"}"

    expiration {
      days = "3"
    }

    noncurrent_version_expiration {
      days = "1"
    }
  }
}

# S3 backup replica role configuration
data "template_file" "s3_backup_replica_assume_role_template" {
  template = "${file("${path.module}/../../policies/s3_backup_replica_role.tpl")}"
}

# Adding backup replication role
resource "aws_iam_role" "backup_replication_role" {
  name               = "${var.stackname}-backup-bucket-replication-role"
  assume_role_policy = "${data.template_file.s3_backup_replica_assume_role_template.rendered}"
}

# S3 backup replica policy configuration
data "template_file" "s3_backup_replica_policy_template" {
  template = "${file("${path.module}/../../policies/s3_backup_replica_policy.json")}"

  vars = {
    govuk_s3_bucket = "${aws_s3_bucket.database_backups.arn}"
    govuk_s3_backup = "${aws_s3_bucket.database_backups_replica.arn}"
  }
}

# Adding backup replication policy
resource "aws_iam_policy" "backup_replication_policy" {
  name        = "govuk-${var.aws_environment}-backup-bucket-replication-policy"
  policy      = "${data.template_file.s3_backup_replica_policy_template.rendered}"
  description = "Allows replication of the backup buckets"
}

# Combine the role and policy
resource "aws_iam_policy_attachment" "backup_replication_policy_attachment" {
  name       = "s3-backup-replication-policy-attachment"
  roles      = ["${aws_iam_role.backup_replication_role.name}"]
  policy_arn = "${aws_iam_policy.backup_replication_policy.arn}"
}

# Outputs
#--------------------------------------------------------------

output "s3_database_backups_bucket_name" {
  value       = "${aws_s3_bucket.database_backups.id}"
  description = "The name of the database backups bucket"
}
