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

variable "training_only" {
  type        = "string"
  description = "Only apply these policies to training "
  default     = "false"
}

variable "integration_only" {
  type        = "string"
  description = "Only apply these policies to integration "
  default     = "false"
}

variable "standard_s3_storage_time" {
  type        = "string"
  description = "Storage time in days for Standard S3 Bucket Objects"
  default     = "30"
}

variable "glacier_storage_time" {
  type        = "string"
  description = "Storage time in days for Glacier Objects"
  default     = "90"
}

variable "expiration_time" {
  type        = "string"
  description = "Expiration time in days of S3 Objects"
  default     = "120"
}

variable "expiration_time_whisper_mongo" {
  type        = "string"
  description = "Expiration time in days for Whisper/Mongo S3 database backups"
  default     = "7"
}

# Set up the backend & provider for each region
terraform {
  backend          "s3"             {}
  required_version = "= 0.11.14"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "2.33.0"
}

provider "aws" {
  alias   = "eu-london"
  region  = "${var.aws_backup_region}"
  version = "2.33.0"
}

data "terraform_remote_state" "infra_monitoring" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket}"
    key    = "${coalesce(var.remote_state_infra_monitoring_key_stack, var.stackname)}/infra-monitoring.tfstate"
    region = "${var.aws_region}"
  }
}

resource "aws_s3_bucket" "database_backups" {
  bucket = "govuk-${var.aws_environment}-database-backups"
  region = "${var.aws_region}"

  tags {
    Name            = "govuk-${var.aws_environment}-database-backups"
    aws_environment = "${var.aws_environment}"
  }

  logging {
    target_bucket = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    target_prefix = "s3/govuk-${var.aws_environment}-database-backups/"
  }

  # The backup should only be stored for a long time in staging and production
  # They are not needed in Integration
  lifecycle_rule {
    id      = "mysql_lifecycle_rule"
    prefix  = "mysql/"
    enabled = "${var.integration_only == "false" ? true : false }"

    transition {
      storage_class = "STANDARD_IA"
      days          = "${var.standard_s3_storage_time}"
    }

    transition {
      storage_class = "GLACIER"
      days          = "${var.glacier_storage_time}"
    }

    expiration {
      days = 120
    }
  }

  lifecycle_rule {
    id      = "postgres_lifecycle_rule"
    prefix  = "postgres/"
    enabled = "${var.integration_only == "false" ? true : false }"

    transition {
      storage_class = "STANDARD_IA"
      days          = "${var.standard_s3_storage_time}"
    }

    transition {
      storage_class = "GLACIER"
      days          = "${var.glacier_storage_time}"
    }

    expiration {
      days = 120
    }
  }

  lifecycle_rule {
    id      = "mongo_daily_lifecycle_rule"
    prefix  = "mongodb/daily"
    enabled = "${var.integration_only == "false" ? true : false }"

    transition {
      storage_class = "STANDARD_IA"
      days          = "${var.standard_s3_storage_time}"
    }

    transition {
      storage_class = "GLACIER"
      days          = "${var.glacier_storage_time}"
    }

    expiration {
      days = 120
    }
  }

  lifecycle_rule {
    id      = "mongo_regular_lifecycle_rule"
    prefix  = "mongodb/regular"
    enabled = true

    expiration {
      days = "${var.expiration_time_whisper_mongo}"
    }
  }

  lifecycle_rule {
    id      = "whisper_lifecycle_rule"
    prefix  = "whisper/"
    enabled = true

    expiration {
      days = "${var.expiration_time_whisper_mongo}"
    }
  }

  # Integration specific lifecycle rules START. These rules are created in all
  # environments but are only enabled in Integration.

  lifecycle_rule {
    id      = "mysql_lifecycle_rule_integration"
    prefix  = "mysql/"
    enabled = "${var.integration_only}"

    expiration {
      days = "${var.expiration_time}"
    }
  }
  lifecycle_rule {
    id      = "postgres_lifecycle_rule_integration"
    prefix  = "postgres/"
    enabled = "${var.integration_only}"

    expiration {
      days = "${var.expiration_time}"
    }
  }
  lifecycle_rule {
    id      = "mongo_daily_lifecycle_rule_integration"
    prefix  = "mongodb/daily"
    enabled = "${var.integration_only}"

    expiration {
      days = "${var.expiration_time}"
    }
  }

  # Integraion lifecycle specific rules END

  versioning {
    enabled = true
  }
  replication_configuration {
    role = "${aws_iam_role.backup_replication_role.arn}"

    rules {
      id     = "main_replication_rule"
      prefix = ""
      status = "Enabled"

      destination {
        bucket        = "${aws_s3_bucket.database_backups_replica.arn}"
        storage_class = "STANDARD"
      }
    }
  }
}

# Bucket in the second region (Backup of the backup)
resource "aws_s3_bucket" "database_backups_replica" {
  bucket   = "govuk-${var.aws_environment}-database-backups-replica"
  region   = "${var.aws_backup_region}"
  provider = "aws.eu-london"

  versioning {
    enabled = true
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

  vars {
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
