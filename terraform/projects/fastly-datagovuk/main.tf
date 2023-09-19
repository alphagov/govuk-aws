/**
* ## Project: fastly-datagovuk
*
* Manages the Fastly service for data.gov.uk
*/

# Resources
# --------------------------------------------------------------
terraform {
  backend "s3" {}
  required_version = "= 0.12.30"
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

  request_setting {
    name      = "Force TLS"
    force_ssl = true
  }

  s3logging {
    # Apache log format documentation: https://www.loggly.com/ultimate-guide/apache-logging-basics/
    format             = "%h\\t%%{%Y-%m-%d %H:%M:%S}t.%%{msec_frac}t\\t%m\\t%U%q\\t%>s\\t%B\\t%%{tls.client.protocol}V\\t%%{fastly_info.state}V\\t%%{Referer}i\\t%%{User-Agent}i"
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
