/**
* ## Project: infra-google-mirror-bucket
*
* This project creates a multi-region EU bucket in google cloud, i.e. gcs.
*
*
*/

variable "google_project_id" {
  type        = "string"
  description = "Google project ID"
  default     = "eu-west2"
}

variable "google_region" {
  type        = "string"
  description = "Google region the provider"
  default     = "eu-west2"
}

variable "google_environment" {
  type        = "string"
  description = "Google environment, which is govuk environment. e.g: staging"
  default     = ""
}

variable "location" {
  type        = "string"
  description = "location where to put the gcs bucket"
  default     = "eu"
}

variable "storage_class" {
  type        = "string"
  description = "the type of storage used for the gcs bucket"
  default     = "multi_regional"
}

variable "remote_state_bucket" {
  type        = "string"
  description = "GCS bucket we store our terraform state in"
}

variable "remote_state_infra_google_monitoring_prefix" {
  type        = "string"
  description = "GCS bucket prefix where the infra-google-monitoring state files are stored"
}

variable "govuk_mirror_google_reader_aws_access_key_id" {
  type        = "string"
  description = "AWS access key ID used by google transfer service to access s3 govuk mirror bucket"
}

variable "govuk_mirror_google_reader_aws_secret_access_key" {
  type        = "string"
  description = "AWS secret access key used by google transfer service to access s3 govuk mirror bucket"
}

# Resources
# --------------------------------------------------------------

terraform {
  backend "gcs" {}
  required_version = "= 0.11.15"
}

provider "google" {
  region  = "${var.google_region}"
  version = "= 2.4.1"
  project = "${var.google_project_id}"
}

data "terraform_remote_state" "infra_google_monitoring" {
  backend = "gcs"

  config {
    bucket  = "${var.remote_state_bucket}"
    prefix  = "${var.remote_state_infra_google_monitoring_prefix}"
    project = "${var.google_project_id}"
  }
}

data "google_storage_transfer_project_service_account" "default" {
  project = "${var.google_project_id}"
}

resource "google_storage_bucket" "govuk-mirror" {
  name          = "govuk-${var.google_environment}-mirror"
  location      = "${var.location}"
  storage_class = "${var.storage_class}"
  project       = "${var.google_project_id}"

  logging {
    log_bucket = "${data.terraform_remote_state.infra_google_monitoring.google_logging_bucket_id}"
  }

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }

    condition {
      age        = 8
      with_state = "ARCHIVED"
    }
  }
}

resource "google_storage_bucket_iam_member" "s3-sync-bucket" {
  bucket = "govuk-${var.google_environment}-mirror"
  role   = "roles/storage.admin"
  member = "serviceAccount:${data.google_storage_transfer_project_service_account.default.email}"

  depends_on = [
    "google_storage_bucket.govuk-mirror",
  ]
}

resource "google_storage_transfer_job" "s3-bucket-daily-sync" {
  description = "daily sync of the primary govuk-${var.google_environment}-mirror S3 bucket"
  project     = "${var.google_project_id}"

  transfer_spec {
    transfer_options {
      delete_objects_unique_in_sink = true
    }

    aws_s3_data_source {
      bucket_name = "govuk-${var.google_environment}-mirror"

      aws_access_key {
        access_key_id     = "${var.govuk_mirror_google_reader_aws_access_key_id}"
        secret_access_key = "${var.govuk_mirror_google_reader_aws_secret_access_key}"
      }
    }

    gcs_data_sink {
      bucket_name = "govuk-${var.google_environment}-mirror"
    }
  }

  schedule {
    schedule_start_date {
      year  = 2019
      month = 5
      day   = 20
    }

    schedule_end_date {
      year  = 9999
      month = 12
      day   = 31
    }

    start_time_of_day {
      hours   = 18
      minutes = 00
      seconds = 0
      nanos   = 0
    }
  }

  depends_on = [
    "google_storage_bucket_iam_member.s3-sync-bucket",
  ]
}
