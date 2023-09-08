/**
* ## Project: fastly-datagovuk
*
* Manages the Fastly service for data.gov.uk
*/
variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-1"
}

variable "stackname" {
  type        = string
  description = "Stackname"
}

variable "aws_environment" {
  type        = string
  description = "AWS Environment"
}

variable "fastly_api_key" {
  type        = string
  description = "API key to authenticate with Fastly"
}

variable "logging_aws_access_key_id" {
  type        = string
  description = "IAM key ID with access to put logs into the S3 bucket"
}

variable "logging_aws_secret_access_key" {
  type        = string
  description = "IAM secret key with access to put logs into the S3 bucket"
}

variable "domain" {
  type        = string
  description = "The domain of the data.gov.uk service to manage"
}

variable "backend_domain" {
  type        = string
  description = "The domain of the data.gov.uk PaaS instance to forward requests to"
}

# Resources
# --------------------------------------------------------------
terraform {
  backend "s3" {}
  required_version = "= 0.11.15"
}

provider "fastly" {
  api_key = var.fastly_api_key
  version = "~> 0.26.0"
}

data "external" "fastly" {
  program = ["/bin/bash", "${path.module}/fastly.sh"]
}

resource "fastly_service_v1" "datagovuk" {
  name = "${title(var.aws_environment)} data.gov.uk"

  domain {
    name = var.domain
  }

  domain {
    name = "www.${var.domain}"
  }

  backend {
    name               = "cname ${var.backend_domain}"
    address            = var.backend_domain
    port               = "443"
    use_ssl            = true
    auto_loadbalance   = false
    first_byte_timeout = 120000
    ssl_check_cert     = false
  }

  backend {
    name               = "cname dfe-app1.codeenigma.net"
    address            = "dfe-app1.codeenigma.net"
    port               = "443"
    use_ssl            = true
    auto_loadbalance   = false
    first_byte_timeout = 120000
    ssl_check_cert     = false
    request_condition  = "education_standards"
  }

  backend {
    name               = "cname contracts-finder-archive"
    address            = "34.249.103.20"
    port               = "80"
    use_ssl            = false
    auto_loadbalance   = false
    first_byte_timeout = 120000
    ssl_check_cert     = false
    request_condition  = "contracts_finder_archive"
  }

  vcl {
    name    = "datagovuk_vcl"
    content = file(data.external.fastly.result.fastly)
    main    = true
  }

  condition {
    name      = "education_standards"
    type      = "REQUEST"
    statement = "req.url ~ \"^/education-standards\""
  }

  header {
    name              = "education_standards_url"
    action            = "set"
    type              = "request"
    destination       = "url"
    source            = "regsub(req.url, \"^/education-standards\", \"\")"
    request_condition = "education_standards"
  }

  header {
    name              = "education_standards_host"
    action            = "set"
    type              = "request"
    destination       = "http.host"
    source            = "\"dfe-app1.codeenigma.net\""
    request_condition = "education_standards"
  }

  condition {
    name      = "contracts_finder_archive"
    type      = "REQUEST"
    statement = "req.url ~ \"^/data/contracts-finder-archive\""
  }

  header {
    name              = "contracts_finder_archive_url"
    action            = "set"
    type              = "request"
    destination       = "url"
    source            = "regsub(req.url, \"^/data/contracts-finder-archive\", \"\")"
    request_condition = "contracts_finder_archive"
  }

  header {
    name              = "contracts_finder_archive_host"
    action            = "set"
    type              = "request"
    destination       = "http.host"
    source            = "\"34.249.103.20\""
    request_condition = "contracts_finder_archive"
  }

  header {
    name              = "contracts_finder_archive_script_name"
    action            = "set"
    type              = "request"
    destination       = "http.X-Script-Name"
    source            = "\"/data/contracts-finder-archive\""
    request_condition = "contracts_finder_archive"
  }

  request_setting {
    name      = "Force TLS"
    force_ssl = true
  }

  s3logging {
    # Apache log format documentation: https://www.loggly.com/ultimate-guide/apache-logging-basics/
    format = join("\t",
      [
        "%h",
        "%%{%Y-%m-%d %H:%M:%S}t.%%{msec_frac}t",
        "%m",
        "%U%q",
        "%>s",
        "%B",
        "%%{tls.client.protocol}V",
        "${fastly_info.state}V",
        "%\"Referer\"i",
        "%\"User-Agent\"i",
      ]
    )
    bucket_name        = "govuk-${var.aws_environment}-fastly-logs"
    domain             = "s3-eu-west-1.amazonaws.com"
    format_version     = "2"
    gzip_level         = "9"
    message_type       = "blank"
    name               = "s3-dgu-logging"
    path               = "datagovuk/"
    period             = "600"
    redundancy         = "standard"
    response_condition = ""
    s3_access_key      = var.logging_aws_access_key_id
    s3_secret_key      = var.logging_aws_secret_access_key
    timestamp_format   = ""
  }

  # The next four blocks handle the data.gov.uk -> www.data.gov.uk redirect
  condition {
    name      = "${var.domain} to www.${var.domain} redirect request condition"
    statement = "req.http.host == \"${var.domain}\""
    type      = "REQUEST"
  }

  response_object {
    name              = "${var.domain} to www.${var.domain} redirect synthetic response"
    status            = 301
    request_condition = "${var.domain} to www.${var.domain} redirect request condition"
  }

  condition {
    name      = "${var.domain} to www.${var.domain} redirect response condition"
    statement = "req.http.host == \"${var.domain}\" && resp.status == 301"
    type      = "RESPONSE"
  }

  header {
    name               = "${var.domain} to www.${var.domain} redirect location header"
    action             = "set"
    type               = "response"
    destination        = "http.Location"
    source             = "\"https://www.${var.domain}\" + req.url"
    response_condition = "${var.domain} to www.${var.domain} redirect response condition"
  }
}
