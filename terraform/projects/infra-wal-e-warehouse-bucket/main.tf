/**
* ## Project: wal-e-warehouse-bucket
*
* This creates an s3 bucket
*
* wal-e-warehouse: The bucket that will hold database backups
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
  backend          "s3"             {}
  required_version = "= 0.11.7"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "1.40.0"
}

provider "aws" {
  alias   = "eu-london"
  region  = "${var.aws_backup_region}"
  version = "1.40.0"
}

data "terraform_remote_state" "infra_monitoring" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket}"
    key    = "${coalesce(var.remote_state_infra_monitoring_key_stack, var.stackname)}/infra-monitoring.tfstate"
    region = "eu-west-1"
  }
}

resource "aws_s3_bucket" "wal_e_warehouse" {
  bucket = "govuk-${var.aws_environment}-wal-e-warehouse"
  region = "${var.aws_region}"

  tags {
    Name            = "govuk-${var.aws_environment}-wal-e-warehouse"
    aws_environment = "${var.aws_environment}"
  }

  logging {
    target_bucket = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    target_prefix = "s3/govuk-${var.aws_environment}-wal-e-warehouse/"
  }

  lifecycle_rule {
    prefix  = "postgres/"
    enabled = true

    transition {
      storage_class = "STANDARD_IA"
      days          = 30
    }

    transition {
      storage_class = "GLACIER"
      days          = 90
    }

    expiration {
      days = 120
    }
  }

  versioning {
    enabled = true
  }

  replication_configuration {
    role = "${aws_iam_role.wal_e_warehouse_replication_role.arn}"

    rules {
      prefix = ""
      status = "Enabled"

      destination {
        bucket        = "${aws_s3_bucket.wal_e_warehouse_replica.arn}"
        storage_class = "STANDARD"
      }
    }
  }
}

# Bucket in the second region (Backup of the backup)
resource "aws_s3_bucket" "wal_e_warehouse_replica" {
  bucket   = "govuk-${var.aws_environment}-wal-e-warehouse-replica"
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
resource "aws_iam_role" "wal_e_warehouse_replication_role" {
  name               = "${var.stackname}-wal-e-warehouse-bucket-replication-role"
  assume_role_policy = "${data.template_file.s3_backup_replica_assume_role_template.rendered}"
}

# S3 backup replica policy configuration
data "template_file" "s3_backup_replica_policy_template" {
  template = "${file("${path.module}/../../policies/s3_backup_replica_policy.json")}"

  vars {
    govuk_s3_bucket = "${aws_s3_bucket.wal_e_warehouse.arn}"
    govuk_s3_backup = "${aws_s3_bucket.wal_e_warehouse_replica.arn}"
  }
}

# Adding backup replication policy
resource "aws_iam_policy" "wal_e_warehouse_replication_policy" {
  name        = "govuk-${var.aws_environment}-wal-e-warehouse-bucket-replication-policy"
  policy      = "${data.template_file.s3_backup_replica_policy_template.rendered}"
  description = "Allows replication of the warehouse wal-e buckets"
}

# Combine the role and policy
resource "aws_iam_policy_attachment" "wal_e_warehouse_replication_policy_attachment" {
  name       = "s3-wal-e-warehouse-bucket-replication-policy-attachment"
  roles      = ["${aws_iam_role.wal_e_warehouse_replication_role.name}"]
  policy_arn = "${aws_iam_policy.wal_e_warehouse_replication_policy.arn}"
}
