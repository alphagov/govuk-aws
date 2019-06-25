/*
* ## Module: s3-bucket-lifecycle
*
* This module creates s3 buckets with predefined lifecycle rules
*/

# Variables
#--------------------------------------------------------------
variable "aws_environment" {
  type        = "string"
  description = "AWS Environment"
}

variable "bucket_name" {
  type        = "string"
  description = "Name of bucket to create"
}

variable "target_bucketid_for_logs" {
  type        = "string"
  description = "ID for logging bucket"
}

variable "target_prefix_for_logs" {
  type        = "string"
  description = "Prefix for logs written to the s3 bucket"
}

# lifecycle rule 1 vars
variable "enable_current_expiration" {
  type        = "string"
  description = "Enables current object lifecycle rule"
  default     = "false"
}

variable "current_expiration_days" {
  type        = "string"
  description = "Number of days to keep current versions"
  default     = "5"
}

# lifecycle rule 2 vars
variable "enable_noncurrent_expiration" {
  type        = "string"
  description = "Enables this lifecycle rule"
  default     = "false"
}

variable "noncurrent_expiration_days" {
  type        = "string"
  description = "Number of days to keep noncurrent versions"
  default     = "5"
}

# Resources
#--------------------------------------------------------------

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.bucket_name}"

  tags {
    aws_environment = "${var.aws_environment}"
    Name            = "${var.bucket_name}"
    SourceCode      = "alphagov/govuk-aws/terraform/modules/aws/s3_bucket_lifecycle" #hardcoded path to this code, TODO: make this dynamic.
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = "${var.target_bucketid_for_logs}"
    target_prefix = "${var.target_prefix_for_logs}"
  }

  lifecycle_rule {
    id      = "Clean_up_incomplete_multipart_uploads_after_5_days" # lifecycle rule 0
    enabled = "true"

    abort_incomplete_multipart_upload_days = 5
  }

  lifecycle_rule {
    id      = "expire_current_objects"           # lifecycle rule 1
    enabled = "${var.enable_current_expiration}"

    expiration {
      days = "${var.current_expiration_days}"
    }
  }

  lifecycle_rule {
    id      = "expire_noncurrent_objects"           # lifecycle rule 2
    enabled = "${var.enable_noncurrent_expiration}"

    noncurrent_version_expiration {
      days = "${var.noncurrent_expiration_days}"
    }
  }
}

# Outputs
#--------------------------------------------------------------

output "bucket_id" {
  value = "${aws_s3_bucket.s3_bucket.id}"
}
