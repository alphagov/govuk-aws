/**
* ## Project: infra-cloudfront
*
*/

variable "aws_region" {
  type        = string
  description = "AWS region where primary s3 bucket is located"
  default     = "eu-west-2"
}

variable "aws_environment" {
  type        = string
  description = "AWS Environment"
}

variable "stackname" {
  type        = string
  description = "Stackname"
}

variable "remote_state_bucket" {
  type        = string
  description = "S3 bucket we store our terraform state in"
}

variable "remote_state_infra_monitoring_key_stack" {
  type        = string
  description = "Override stackname path to infra_monitoring remote state "
  default     = ""
}

variable "remote_state_infra_networking_key_stack" {
  type        = string
  description = "Override infra_networking remote state path"
  default     = ""
}

variable "office_ips" {
  type        = list
  description = "An array of CIDR blocks that will be allowed offsite access."
}

variable "cloudfront_create" {
  description = "Create Cloudfront resources."
  default     = false
}

variable "cloudfront_enable" {
  description = "Enable Cloudfront distributions."
  default     = false
}

variable "cloudfront_www_distribution_aliases" {
  type        = list
  description = "Extra CNAMEs (alternate domain names), if any, for the WWW CloudFront distribution."
  default     = []
}

variable "cloudfront_www_certificate_domain" {
  type        = string
  description = "The domain of the WWW CloudFront certificate to look up."
  default     = ""
}

variable "cloudfront_assets_distribution_aliases" {
  type        = list
  description = "Extra CNAMEs (alternate domain names), if any, for the Assets CloudFront distribution."
  default     = []
}

variable "cloudfront_assets_certificate_domain" {
  type        = string
  description = "The domain of the Assets CloudFront certificate to look up."
  default     = ""
}

variable "notify_cloudfront_domain" {
  type        = string
  description = "The domain of the Notify CloudFront to proxy /alerts requests to."
  default     = ""
}

variable "lifecycle_main" {
  type        = string
  description = "Number of days for the lifecycle rule for the mirror"
  default     = "5"
}

variable "lifecycle_government_uploads" {
  type        = string
  description = "Number of days for the lifecycle rule for the mirror in the case where the prefix path is www.gov.uk/government/uploads/"
  default     = "8"
}

variable "remote_state_infra_vpc_key_stack" {
  type        = string
  description = "Override infra_vpc remote state path"
  default     = ""
}

# Resources
# --------------------------------------------------------------

# Set up the backend & provider for each region
terraform {
  backend          "s3"             {}
  required_version = "= 1.3.4"
}

provider "aws" {
  region  = "${var.aws_region}"
}

provider "archive" {
}

data "aws_caller_identity" "current" {}

#
# CloudFront
#

resource "aws_cloudfront_distribution" "www_distribution" {

  aliases = ["www2.staging.publishing.service.gov.uk"]
  web_acl_id = "arn:aws:wafv2:us-east-1:696911096973:global/webacl/cdn_poc_govuk/8fcb1569-44ff-4dd8-b634-748ca3e2b255"
  origin {
    domain_name = "govuk-cache-public-cdn-504820716.eu-west-1.elb.amazonaws.com"
    origin_id   = "cache cdn lb"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
    custom_header {
      name  = "x-amzn-waf-cdn"
      value = "0e0fdb76-3422-11ed-a261-0242ac120002"
    }
  }

  origin {
    domain_name = "d1lmz31mme1483.cloudfront.net"
    origin_id   = "notify alerts"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = "${var.cloudfront_enable}"
  is_ipv6_enabled     = true
  comment             = "WWW"


  default_cache_behavior {
    allowed_methods          = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods           = ["GET", "HEAD"]
    target_origin_id         = "cache cdn lb"
    compress                 = "true"
    cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    origin_request_policy_id = "b33a356b-8c7e-46a6-bb6d-7fec3a3488d7"

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
  }

 ordered_cache_behavior {
    path_pattern     = "/assets/*"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "cache cdn lb"
    compress                 = "true"
    cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    origin_request_policy_id = "b33a356b-8c7e-46a6-bb6d-7fec3a3488d7"
    viewer_protocol_policy = "redirect-to-https"
  }

 ordered_cache_behavior {
    path_pattern     = "/alerts"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "notify alerts"
    compress                 = "true"
    cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    origin_request_policy_id = "b33a356b-8c7e-46a6-bb6d-7fec3a3488d7"
    viewer_protocol_policy = "redirect-to-https"
  }

 ordered_cache_behavior {
    path_pattern     = "/alerts/*"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "notify alerts"
    compress                 = "true"
    cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    origin_request_policy_id = "b33a356b-8c7e-46a6-bb6d-7fec3a3488d7"
    viewer_protocol_policy = "redirect-to-https"
  }
 
ordered_cache_behavior {
    path_pattern     = "*.png"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "cache cdn lb"
    compress                 = "true"
    cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    origin_request_policy_id = "b33a356b-8c7e-46a6-bb6d-7fec3a3488d7"
    viewer_protocol_policy = "redirect-to-https"
  }

ordered_cache_behavior {
    path_pattern     = "*.jpg"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "cache cdn lb"
    compress                 = "true"
    cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    origin_request_policy_id = "b33a356b-8c7e-46a6-bb6d-7fec3a3488d7"
    viewer_protocol_policy = "redirect-to-https"
  }

ordered_cache_behavior {
    path_pattern     = "*.jpeg"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "cache cdn lb"
    compress                 = "true"
    cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    origin_request_policy_id = "b33a356b-8c7e-46a6-bb6d-7fec3a3488d7"
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = "arn:aws:acm:us-east-1:696911096973:certificate/642e34ef-71e2-439d-99f7-e79baf9ed482"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.1_2016"
  }

  custom_error_response {
    error_code            = 403
    response_code         = 503
    response_page_path    = "/error/503.html"
    error_caching_min_ttl = 300
  }

  custom_error_response {
    error_code            = 404
    response_code         = 503
    response_page_path    = "/error/503.html"
    error_caching_min_ttl = 300
  }

  tags = {
    Project         = "${var.stackname}"
    aws_environment = "${var.aws_environment}"
  }
}

