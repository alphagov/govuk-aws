/**
* ## Project: fastly-datagovuk
*
* Manages the Fastly service for data.gov.uk
*/

variable "stackname" {
  type        = "string"
  description = "Stackname"
}

variable "aws_environment" {
  type        = "string"
  description = "AWS Environment"
}

variable "fastly_api_key" {
  type        = "string"
  description = "API key to authenticate with Fastly"
}

variable "logging_aws_access_key_id" {
  type        = "string"
  description = "IAM key ID with access to put logs into the S3 bucket"
}

variable "logging_aws_secret_access_key" {
  type        = "string"
  description = "IAM secret key with access to put logs into the S3 bucket"
}

variable "domain" {
  type        = "string"
  description = "The domain of the data.gov.uk service to manage"
}

variable "backend_domain" {
  type        = "string"
  description = "The domain of the data.gov.uk PaaS instance to forward requests to"
}

# Resources
# --------------------------------------------------------------
terraform {
  backend          "s3"             {}
  required_version = "= 0.11.7"
}

provider "fastly" {
  api_key = "${var.fastly_api_key}"
}

resource "fastly_service_v1" "datagovuk" {
  name = "${title(var.aws_environment)} data.gov.uk"

  domain {
    name = "${var.domain}"
  }

  domain {
    name = "www.${var.domain}"
  }

  backend {
    name               = "cname ${var.backend_domain}"
    address            = "${var.backend_domain}"
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

  vcl {
    name    = "datagovuk_vcl"
    content = "${file("datagovuk.vcl")}"
    main    = true
  }

  condition {
    name      = "education_standards"
    type      = "request"
    statement = "req.url ~ \"^/education-standards\""
  }

  header {
    name              = "education_standards"
    action            = "set"
    type              = "request"
    destination       = "url"
    source            = "regsub(req.url, \"^/education-standards\", \"\")"
    request_condition = "education_standards"
  }

  request_setting {
    name      = "Force TLS"
    force_ssl = true
  }

  s3logging {
    format             = "%h\\t%{%Y-%m-%d %H:%M:%S}t.%{msec_frac}t\\t%m\\t%U%q\\t%>s\\t%B\\t%{tls.client.protocol}V\\t%{fastly_info.state}V\\t%{Referer}i\\t%{User-Agent}i"
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
    s3_access_key      = "${var.logging_aws_access_key_id}"
    s3_secret_key      = "${var.logging_aws_secret_access_key}"
    timestamp_format   = ""
  }

  # The next four blocks handle the www.data.gov.uk -> data.gov.uk redirect
  condition {
    name      = "www.${var.domain} to ${var.domain} redirect request condition"
    statement = "req.http.host == \"www.${var.domain}\""
    type      = "REQUEST"
  }

  response_object {
    name              = "www.${var.domain} to ${var.domain} redirect synthetic response"
    status            = 301
    request_condition = "www.${var.domain} to ${var.domain} redirect request condition"
  }

  condition {
    name      = "www.${var.domain} to ${var.domain} redirect response condition"
    statement = "req.http.host == \"www.${var.domain}\" && resp.status == 301"
    type      = "RESPONSE"
  }

  header {
    name               = "www.${var.domain} to ${var.domain} redirect location header"
    action             = "set"
    type               = "response"
    destination        = "http.Location"
    source             = "\"https://${var.domain}\" + req.url"
    response_condition = "www.${var.domain} to ${var.domain} redirect response condition"
  }
}
