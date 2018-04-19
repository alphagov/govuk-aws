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
  backend          "s3"             {}
  required_version = "= 0.11.7"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "1.14.0"
}

provider "aws" {
  region  = "${var.aws_backup_region}"
  alias   = "aws_secondary"
  version = "1.14.0"
}

data "terraform_remote_state" "infra_monitoring" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket}"
    key    = "${coalesce(var.remote_state_infra_monitoring_key_stack, var.stackname)}/infra-monitoring.tfstate"
    region = "eu-west-1"
  }
}

resource "aws_s3_bucket" "govuk-mirror-1" {
  bucket = "govuk-${var.aws_environment}-mirror-1"

  tags {
    Name            = "govuk-${var.aws_environment}-mirror-1"
    aws_environment = "${var.aws_environment}"
  }

  logging {
    target_bucket = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    target_prefix = "s3/govuk-${var.aws_environment}-mirror-1/"
  }

  versioning {
    enabled = true
  }

  replication_configuration {
    role = "${aws_iam_role.govuk_mirror_1_replication_role.arn}"

    rules {
      prefix = ""
      status = "Enabled"

      destination {
        bucket        = "${aws_s3_bucket.govuk-mirror-2.arn}"
        storage_class = "STANDARD"
      }
    }
  }
}

resource "aws_s3_bucket" "govuk-mirror-2" {
  bucket   = "govuk-${var.aws_environment}-mirror-2"
  region   = "${var.aws_backup_region}"
  provider = "aws.aws_secondary"

  tags {
    Name            = "govuk-${var.aws_environment}-mirror-2"
    aws_environment = "${var.aws_environment}"
  }

  logging {
    target_bucket = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    target_prefix = "s3/govuk-${var.aws_environment}-mirror-2/"
  }

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_policy" "govuk_mirror_1_read_policy" {
  bucket = "${aws_s3_bucket.govuk-mirror-1.id}"
  policy = "${data.aws_iam_policy_document.s3_mirrors_read_policy_doc.json}"
}

resource "aws_s3_bucket_policy" "govuk_mirror_2_read_policy" {
  bucket = "${aws_s3_bucket.govuk-mirror-2.id}"
  policy = "${data.aws_iam_policy_document.s3_mirrors_read_policy_doc.json}"
}

# S3 backup replica role configuration
data "template_file" "s3_govuk_mirror_1_replication_role_template" {
  template = "${file("${path.module}/../../policies/s3_mirror_replica_role.tpl")}"
}

# Adding backup replication role
resource "aws_iam_role" "govuk_mirror_1_replication_role" {
  name               = "${var.stackname}-mirror-1-replication-role"
  assume_role_policy = "${data.template_file.s3_govuk_mirror_1_replication_role_template.rendered}"
}

data "template_file" "" s3_govuk_mirror_1_replication_policy_template "" {
  template = "${file("${path.module}/../../policies/s3_role_replica_policy.tpl")}"

  vars {
    govuk_s3_bucket = "arn:aws:s3:::${govuk-mirror-1}.bucket.arn"
    govuk_s3_backup = "arn:aws:s3:::${govuk-mirror-2}.bucket.arn"
    aws_account_id  = "${data.aws_caller_identity.current.account_id}"
  }
}

# Adding backup replication policy
resource "aws_iam_policy" "govuk_mirror_1_replication_policy" {
  name        = "govuk-${var.aws_environment}-backup-bucket-replication-policy"
  policy      = "${data.template_file.s3_backup_replica_policy_template.rendered}"
  description = "Allows replication of the backup buckets"
}

# Combine the role and policy
resource "aws_iam_policy_attachment" "govuk_mirror_1_replication_policy_attachment" {
  name       = "s3-govuk-mirror-1-replication-policy-attachment"
  roles      = ["${aws_iam_role.govuk-mirror-1-replication-role.name}"]
  policy_arn = "${aws_iam_policy.govuk-mirror-1-replication-policy.arn}"
}
