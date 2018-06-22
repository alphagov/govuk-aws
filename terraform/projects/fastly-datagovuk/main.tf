/**
* ## Project: fastly-datagovuk
*
* Manages the Fastly service for data.gov.uk
*/

variable "aws_environment" {
  type        = "string"
  description = "AWS Environment"
}

variable "logging_aws_access_key_id" {
  type        = "string"
  description = "IAM key ID with access to put logs into the S3 bucket"
}

variable "logging_aws_secret_access_key" {
  type        = "string"
  description = "IAM secret key with access to put logs into the S3 bucket"
}

# Resources
# --------------------------------------------------------------
terraform {
  backend          "s3"             {}
  required_version = "= 0.11.7"
}

resource "fastly_service_v1" "datagovuk" {
  name = "${title(var.aws_environment)} data.gov.uk"

  domain {
    name = "data.gov.uk"
  }

  domain {
    name = "www.data.gov.uk"
  }

  backend {
    name               = "addr 46.43.41.10"
    address            = "46.43.41.10"
    port               = "443"
    use_ssl            = true
    auto_loadbalance   = false
    first_byte_timeout = 120000
    ssl_check_cert     = false
  }

  request_setting {
    name      = "Force TLS"
    force_ssl = true
  }

  s3logging {
    format             = "%h\\t%{%Y-%m-%d %H:%M:%S}t.%{msec_frac}t\\t%m\\t%U%q\\t%>s\\t%B\\t%{tls.client.protocol}V\\t%{fastly_info.state}V\\t%{Referer}i\\t%{User-Agent}i"
    bucket_name        = "govuk-analytics-logs-production"
    domain             = "s3-eu-west-1.amazonaws.com"
    format_version     = "2"
    gzip_level         = "9"
    message_type       = "blank"
    name               = "s3-dgu-logging"
    path               = "datagovuk/incoming/"
    period             = "600"
    redundancy         = "standard"
    response_condition = ""
    s3_access_key      = "${var.logging_aws_access_key_id}"
    s3_secret_key      = "${var.logging_aws_secret_access_key}"
    timestamp_format   = ""
  }
}
