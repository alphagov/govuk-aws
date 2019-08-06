/**
* ## Project: infra-mirror-bucket
*
* This project creates two s3 buckets: a primary s3 bucket to store the govuk
* mirror files and a replica s3 bucket which tracks the primary s3 bucket.
*
* The primary bucket should be in London and the backup in Ireland.
*
*/

variable "aws_region" {
  type        = "string"
  description = "AWS region where primary s3 bucket is located"
  default     = "eu-west-2"
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

variable "remote_state_infra_monitoring_key_stack" {
  type        = "string"
  description = "Override stackname path to infra_monitoring remote state "
  default     = ""
}

variable "remote_state_infra_networking_key_stack" {
  type        = "string"
  description = "Override infra_networking remote state path"
  default     = ""
}

variable "office_ips" {
  type        = "list"
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
  type        = "list"
  description = "Extra CNAMEs (alternate domain names), if any, for the WWW CloudFront distribution."
  default     = []
}

variable "cloudfront_www_certificate_domain" {
  type        = "string"
  description = "The domain of the WWW CloudFront certificate to look up."
  default     = ""
}

variable "cloudfront_assets_distribution_aliases" {
  type        = "list"
  description = "Extra CNAMEs (alternate domain names), if any, for the Assets CloudFront distribution."
  default     = []
}

variable "cloudfront_assets_certificate_domain" {
  type        = "string"
  description = "The domain of the Assets CloudFront certificate to look up."
  default     = ""
}

variable "cloudfront_lambda_version" {
  type        = "string"
  description = "The version of the lambda to use with the cloudfront instance"
  default     = ""
}

# Resources
# --------------------------------------------------------------

# Set up the backend & provider for each region
terraform {
  backend          "s3"             {}
  required_version = "= 0.11.14"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "2.16.0"
}

provider "aws" {
  region  = "${var.aws_replica_region}"
  alias   = "aws_replica"
  version = "2.16.0"
}

provider "aws" {
  region  = "us-east-1"
  alias   = "aws_cloudfront_certificate"
  version = "2.16.0"
}

data "aws_caller_identity" "current" {}

data "terraform_remote_state" "infra_monitoring" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket}"
    key    = "${coalesce(var.remote_state_infra_monitoring_key_stack, var.stackname)}/infra-monitoring.tfstate"
    region = "${var.aws_replica_region}"
  }
}

data "terraform_remote_state" "infra_networking" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket}"
    key    = "${coalesce(var.remote_state_infra_networking_key_stack, var.stackname)}/infra-networking.tfstate"
    region = "${var.aws_replica_region}"
  }
}

resource "aws_s3_bucket" "govuk-mirror" {
  bucket = "govuk-${var.aws_environment}-mirror"

  tags {
    Name            = "govuk-${var.aws_environment}-mirror"
    aws_environment = "${var.aws_environment}"
  }

  logging {
    target_bucket = "${data.terraform_remote_state.infra_monitoring.aws_secondary_logging_bucket_id}"
    target_prefix = "s3/govuk-${var.aws_environment}-mirror/"
  }

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "main"
    enabled = true

    prefix = ""

    noncurrent_version_expiration {
      days = 5
    }
  }

  lifecycle_rule {
    id      = "government_uploads"
    enabled = true

    prefix = "www.gov.uk/government/uploads/"

    noncurrent_version_expiration {
      days = 8
    }
  }

  replication_configuration {
    role = "${aws_iam_role.govuk_mirror_replication_role.arn}"

    rules {
      id     = "govuk-mirror-replication-whole-bucket-rule"
      prefix = ""
      status = "Enabled"

      destination {
        bucket        = "${aws_s3_bucket.govuk-mirror-replica.arn}"
        storage_class = "STANDARD"
      }
    }
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket" "govuk-mirror-replica" {
  bucket   = "govuk-${var.aws_environment}-mirror-replica"
  region   = "${var.aws_replica_region}"
  provider = "aws.aws_replica"

  tags {
    Name            = "govuk-${var.aws_environment}-mirror-replica"
    aws_environment = "${var.aws_environment}"
  }

  logging {
    target_bucket = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    target_prefix = "s3/govuk-${var.aws_environment}-mirror-replica/"
  }

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_policy" "govuk_mirror_read_policy" {
  bucket = "${aws_s3_bucket.govuk-mirror.id}"
  policy = "${data.aws_iam_policy_document.s3_mirror_read_policy_doc.json}"
}

resource "aws_s3_bucket_policy" "govuk_mirror_replica_read_policy" {
  bucket   = "${aws_s3_bucket.govuk-mirror-replica.id}"
  policy   = "${data.aws_iam_policy_document.s3_mirror_replica_read_policy_doc.json}"
  provider = "aws.aws_replica"
}

# S3 backup replica role configuration
data "template_file" "s3_govuk_mirror_replication_role_template" {
  template = "${file("${path.module}/../../policies/s3_govuk_mirror_replication_role.tpl")}"
}

# Adding backup replication role
resource "aws_iam_role" "govuk_mirror_replication_role" {
  name               = "${var.stackname}-mirror-replication-role"
  assume_role_policy = "${data.template_file.s3_govuk_mirror_replication_role_template.rendered}"
}

data "template_file" "s3_govuk_mirror_replication_policy_template" {
  template = "${file("${path.module}/../../policies/s3_govuk_mirror_replication_policy.tpl")}"

  vars {
    govuk_mirror_arn         = "${aws_s3_bucket.govuk-mirror.arn}"
    govuk_mirror_replica_arn = "${aws_s3_bucket.govuk-mirror-replica.arn}"
    aws_account_id           = "${data.aws_caller_identity.current.account_id}"
  }
}

# Adding backup replication policy
resource "aws_iam_policy" "govuk_mirror_replication_policy" {
  name        = "govuk-${var.aws_environment}-mirror-buckets-replication-policy"
  policy      = "${data.template_file.s3_govuk_mirror_replication_policy_template.rendered}"
  description = "Allows replication of the mirror buckets"
}

# Combine the role and policy
resource "aws_iam_policy_attachment" "govuk_mirror_replication_policy_attachment" {
  name       = "s3-govuk-mirror-replication-policy-attachment"
  roles      = ["${aws_iam_role.govuk_mirror_replication_role.name}"]
  policy_arn = "${aws_iam_policy.govuk_mirror_replication_policy.arn}"
}

data "template_file" "s3_govuk_mirror_read_policy_template" {
  template = "${file("${path.module}/../../policies/s3_govuk_mirror_read_policy.tpl")}"

  vars {
    govuk_mirror_arn = "${aws_s3_bucket.govuk-mirror.arn}"
  }
}

resource "aws_iam_policy" "govuk_mirror_read_policy" {
  name        = "govuk-${var.aws_environment}-mirror-read-policy"
  policy      = "${data.template_file.s3_govuk_mirror_read_policy_template.rendered}"
  description = "Allow the listing and reading of the primary govuk mirror bucket"
}

resource "aws_iam_user" "govuk_mirror_google_reader" {
  name = "govuk_mirror_google_reader"
}

resource "aws_iam_policy_attachment" "govuk_mirror_read_policy_attachment" {
  name       = "s3-govuk-mirror-read-policy-attachment"
  users      = ["${aws_iam_user.govuk_mirror_google_reader.name}"]
  policy_arn = "${aws_iam_policy.govuk_mirror_read_policy.arn}"
}

#
# CloudFront
#
resource "aws_cloudfront_origin_access_identity" "mirror_access_identity" {
  comment = "S3 WWW"
}

data "aws_acm_certificate" "www" {
  count = "${var.cloudfront_create}"

  domain   = "${var.cloudfront_www_certificate_domain}"
  statuses = ["ISSUED"]
  provider = "aws.aws_cloudfront_certificate"
}

data "aws_acm_certificate" "assets" {
  count = "${var.cloudfront_create}"

  domain   = "${var.cloudfront_assets_certificate_domain}"
  statuses = ["ISSUED"]
  provider = "aws.aws_cloudfront_certificate"
}

resource "aws_cloudfront_distribution" "www_distribution" {
  count = "${var.cloudfront_create}"

  origin {
    domain_name = "${aws_s3_bucket.govuk-mirror.bucket_domain_name}"
    origin_id   = "S3 www"
    origin_path = "/www.gov.uk"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.mirror_access_identity.cloudfront_access_identity_path}"
    }
  }

  enabled             = "${var.cloudfront_enable}"
  is_ipv6_enabled     = true
  comment             = "WWW"
  default_root_object = "index.html"

  logging_config {
    include_cookies = false
    bucket          = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}.s3.amazonaws.com"
    prefix          = "cloudfront/"
  }

  aliases = ["${var.cloudfront_www_distribution_aliases}"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3 www"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    lambda_function_association {
      event_type   = "viewer-request"
      lambda_arn   = "${aws_lambda_function.url_rewrite.arn}:${var.cloudfront_lambda_version}"
      include_body = false
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = "${data.aws_acm_certificate.www.arn}"
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

resource "aws_cloudfront_distribution" "assets_distribution" {
  count = "${var.cloudfront_create}"

  origin {
    domain_name = "${aws_s3_bucket.govuk-mirror.bucket_domain_name}"
    origin_id   = "S3-govuk-${var.aws_environment}-mirror/assets.publishing.service.gov.uk"
    origin_path = "/assets.publishing.service.gov.uk"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.mirror_access_identity.cloudfront_access_identity_path}"
    }
  }

  enabled         = "${var.cloudfront_enable}"
  is_ipv6_enabled = true
  comment         = "Assets"

  logging_config {
    include_cookies = false
    bucket          = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}.s3.amazonaws.com"
    prefix          = "cloudfront/"
  }

  aliases = ["${var.cloudfront_assets_distribution_aliases}"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-govuk-${var.aws_environment}-mirror/assets.publishing.service.gov.uk"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }

      headers = ["Origin", "Access-Control-Request-Method", "Access-Control-Request-Headers"]
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = "${data.aws_acm_certificate.assets.arn}"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.1_2016"
  }

  tags = {
    Project         = "${var.stackname}"
    aws_environment = "${var.aws_environment}"
  }
}

resource "aws_iam_role" "basic_lambda_role" {
  name = "basic_lambda_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com",
          "edgelambda.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "basic_lambda_attach" {
  name       = "basic-lambda-attachment"
  roles      = ["${aws_iam_role.basic_lambda_role.name}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "url_rewrite" {
  filename      = "../../lambda/CloudfrontUrlRewrite/CloudfrontUrlRewrite.zip"
  function_name = "url_rewrite"
  role          = "${aws_iam_role.basic_lambda_role.arn}"
  handler       = "index.handler"
  runtime       = "nodejs8.10"
  provider      = "aws.aws_cloudfront_certificate"
}
