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

resource "google_storage_bucket" "google-logging" {
  name          = "govuk-${var.google_environment}-gcp-logging"
  location      = "${var.location}"
  storage_class = "${var.storage_class}"
  project       = "${var.google_project_id}"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }

    condition {
      age = 30
    }
  }
}

resource "google_storage_bucket_acl" "google-logging-acl" {
  bucket = "${google_storage_bucket.google-logging.name}"

  role_entity = [
    "WRITER:group-cloud-storage-analytics@google.com",
  ]
}

# Outputs
# --------------------------------------------------------------

output "google_logging_bucket_id" {
  value       = "${google_storage_bucket.google-logging.id}"
  description = "Name of the Google logging bucket"
}
