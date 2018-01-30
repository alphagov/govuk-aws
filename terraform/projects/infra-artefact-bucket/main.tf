/**
*  ## Project: artefact-bucket
*
* This creates 3 S3 buckets:
*
* artefact: The bucket that will hold the artefacts
* artefact_access_logs: Bucket for logs to go to
* artefact_replication_destination: Bucket in another region to replicate to
*
* It creates two IAM roles:
* artefact_writer: used by CI to write new artefacts, and deploy instances
* to write to "deployed-to-environment" branches
*
* artefact_reader: used by instances to fetch artefacts
*
*/
variable "aws_region" {
  type        = "string"
  description = "AWS region"
  default     = "eu-west-1"
}

variable "aws_secondary_region" {
  type        = "string"
  description = "Secondary region for cross-replication"
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

# Resources
# --------------------------------------------------------------
terraform {
  backend          "s3"             {}
  required_version = "= 0.11.2"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "1.0.0"
}

provider "aws" {
  alias   = "secondary"
  region  = "${var.aws_secondary_region}"
  version = "1.0.0"
}

data "terraform_remote_state" "infra_monitoring" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket}"
    key    = "${coalesce(var.remote_state_infra_monitoring_key_stack, var.stackname)}/infra-monitoring.tfstate"
    region = "eu-west-1"
  }
}

# Replication bucket (different region to the other buckets)
resource "aws_s3_bucket" "artefact_replication_destination" {
  provider = "aws.secondary"
  bucket   = "govuk-${var.aws_environment}-artefact-replication-destination"

  versioning {
    enabled = true
  }
}

# Main bucket
resource "aws_s3_bucket" "artefact" {
  bucket = "govuk-${var.aws_environment}-artefact"
  acl    = "private"

  tags {
    Name            = "govuk-${var.aws_environment}-artefact"
    aws_environment = "${var.aws_environment}"
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    target_prefix = "s3/govuk-${var.aws_environment}-artefact/"
  }

  replication_configuration {
    role = "${aws_iam_role.artefact_replication.arn}"

    rules {
      status = "Enabled"
      prefix = ""

      destination {
        bucket = "${aws_s3_bucket.artefact_replication_destination.arn}"
      }
    }
  }
}

# Artefact Writer
resource "aws_iam_policy" "artefact_writer" {
  name        = "govuk-${var.aws_environment}-artefact-writer-policy"
  policy      = "${data.template_file.artefact_writer_policy_template.rendered}"
  description = "Allows writing of the artefacts bucket"
}

# We require a user for the CI environment which is not in AWS
resource "aws_iam_user" "artefact_writer" {
  name = "govuk-${var.aws_environment}-artefact-writer"
}

resource "aws_iam_policy_attachment" "artefact_writer" {
  name       = "artefact-writer-policy-attachment"
  users      = ["${aws_iam_user.artefact_writer.name}"]
  policy_arn = "${aws_iam_policy.artefact_writer.arn}"
}

data "template_file" "artefact_writer_policy_template" {
  template = "${file("${path.module}/../../policies/artefact_writer_policy.tpl")}"

  vars {
    aws_environment = "${var.aws_environment}"
    artefact_bucket = "${aws_s3_bucket.artefact.id}"
  }
}

# Artefact Reader
resource "aws_iam_policy" "artefact_reader" {
  name        = "govuk-${var.aws_environment}-artefact-reader-policy"
  policy      = "${data.template_file.artefact_reader_policy_template.rendered}"
  description = "Allows writing of the artefacts bucket"
}

data "template_file" "artefact_reader_policy_template" {
  template = "${file("${path.module}/../../policies/artefact_reader_policy.tpl")}"

  vars {
    aws_environment = "${var.aws_environment}"
    artefact_bucket = "${aws_s3_bucket.artefact.id}"
  }
}

# Outputs
# --------------------------------------------------------------

output "write_artefact_bucket_policy_arn" {
  value       = "${aws_iam_policy.artefact_writer.arn}"
  description = "ARN of the write artefact-bucket policy"
}

output "read_artefact_bucket_policy_arn" {
  value       = "${aws_iam_policy.artefact_reader.arn}"
  description = "ARN of the read artefact-bucket policy"
}
