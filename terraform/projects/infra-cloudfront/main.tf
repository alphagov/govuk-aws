/**
* ## Project: infra-cloudfront
*
* This project creates a cloudfront distribution for GOV.UK
* 
**/


variable "aws_region" {
  type        = "string"
  description = "AWS region where the cloudfront distribution is located"
  default     = "eu-west-1"
}

variable "aws_replica_region" {
  type        = "string"
  description = "AWS region where replica s3 bucket is located"
  default     = "eu-west-1"
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

variable "cloudfront_create" {
  description = "Create Cloudfront resources."
  default     = false
}

variable "cloudfront_enable" {
  description = "Enable Cloudfront distributions."
  default     = false
}

variable "cloudfront_www_certificate_domain" {
  type        = "string"
  description = "The domain of the WWW CloudFront certificate to look up."
  default     = ""
}

variable "cloudfront_www_distribution_aliases" {
  type        = "list"
  description = "Extra CNAMEs (alternate domain names), if any, for the WWW CloudFront distribution."
  default     = [".staging.govuk.digital"]
}

variable "lifecycle_main" {
  type        = "string"
  description = "Number of days for the lifecycle rule for the mirror"
  default     = "5"
}

variable "lifecycle_government_uploads" {
  type        = "string"
  description = "Number of days for the lifecycle rule for the mirror in the case where the prefix path is www.gov.uk/government/uploads/"
  default     = "8"
}



# Data
# --------------------------------------------------------------
#  

data "terraform_remote_state" "infra_vpc" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket}"
    key    = "${coalesce(var.remote_state_infra_vpc_key_stack, var.stackname)}/infra-vpc.tfstate"
    region = "${var.aws_replica_region}"
  }
}

data "aws_acm_certificate" "www" {
  count = "${var.cloudfront_create}"

  domain   = "${var.cloudfront_www_certificate_domain}"
  statuses = ["ISSUED"]
  provider = "aws.aws_cloudfront_certificate"
}



# Resources
# --------------------------------------------------------------
# Set up the backend for CloudFront 


provider "aws" {
  region  = "${var.aws_region}"
  version = "2.46.0"
}
 

# - ACM certificate

# resource "aws_acm_certificate" "cert" {
#   domain_name               = ""
#   subject_alternative_names = ""
#   validation_method         = ""
#   tags                      = ""
# }


# - S3 Buckets for Logs 
resource "aws_s3_bucket" "govuk-cloudfront-logs" {
  bucket   = "govuk-${var.aws_environment}-cloudfront-logs"
  region   = "${var.aws_replica_region}"
  provider = "aws.aws_replica"

  tags {
    Name            = "govuk-${var.aws_environment}-cloudfront-logs"
    aws_environment = "${var.aws_environment}"
  }

  logging {
    target_bucket = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    target_prefix = "s3/govuk-${var.aws_environment}-govuk-cloudfront-logs/"
  }

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "main"
    enabled = true

    prefix = ""

    noncurrent_version_expiration {
      days = "${var.lifecycle_main}"
    }
  }


# - WAF 





#
# CloudFront with Application Load Balancer as Origin 
#

resource "aws_cloudfront_distribution" "govuk_cdn_distribution" { 
  count = "${var.cloudfront_create}"

  origin {
    domain_name = "${aws_lb.cache_public_lb_id}.${var.aws_region}.elb.amazonaws.com"
    origin_id   = "${var.aws_environment}_GOV.UK"  

    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols = ["TLSv1.2"]
    }
  
    # custom_header {
    #   name  = "x-amzn-waf-cdn"
    #   value = random_id.xxx.b64
    # }
  }

  default_cache_behavior {
  allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
  cached_methods   = ["GET", "HEAD"]
  target_origin_id = "${var.aws_environment}_GOV.UK"

  forwarded_values {
    query_string = true

    cookies {
      forward = "all"
    }

    headers = ["Origin", "Access-Control-Request-Method", "Access-Control-Request-Headers"] //add "aws_cloudfront_origin_request_policy" "AllViewerHeaderCookies" here potentially 
  }

  aliases = ["${var.cloudfront_www_distribution_aliases}"]


  enabled             = "${var.cloudfront_enable}"
  is_ipv6_enabled     = true
  web_acl_id          = ""
  comment             = "${var.aws_environment}_GOV.UK" #change name 
  default_root_object = ""

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # logging_config {
  #   include_cookies = false
  #   bucket          = ""             # "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}.s3.amazonaws.com"
  #   prefix          = "cloudfront/"
  # }
 

  # viewer_certificate {
  #   acm_certificate_arn      = "" # "${data.aws_acm_certificate.XXXXXXXXXXXX.arn}" #find the correct arn for .staging.publishing.service.gov.uk + might create resource first 
  #   ssl_support_method       = "sni-only"
  #   minimum_protocol_version = "TLSv1.1_2016"
  # }


  tags = {
    Project         = "${var.stackname}"
    aws_environment = "${var.aws_environment}"
  }



resource "aws_cloudfront_origin_request_policy" "AllViewerHeaderCookies" {
  name    = "AllViewerHeaderCookies"
  comment = "Policy will forward all parameters in viewer requests to origin"
  cookies_config {
    cookie_behavior = "All"
    }
  }
  headers_config {
    header_behavior = "All_viewer_headers"
  }
  query_strings_config {
    query_string_behavior = "All"
  }
}



# Cache Behavior
# --------------------------------------------------------------
# 

  viewer_protocol_policy = "redirect-to-https"
  min_ttl                = 0
  default_ttl            = 86400
  max_ttl                = 31536000
  }

  # Precedence 0
  ordered_cache_behavior {
    path_pattern     = "/assets/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "govuk-cache-public"

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # Precedence 1
  ordered_cache_behavior {
    path_pattern     = "*.png"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id =  

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # Precedence 2
  ordered_cache_behavior {
    path_pattern     = "*.jpg"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id =    # "govuk-cache-public"

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }



  # Precedence 3
  ordered_cache_behavior {
    path_pattern     = "*.jpeg"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id =    # "govuk-cache-public"

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

}
