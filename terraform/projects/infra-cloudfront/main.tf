terraform {
  backend "s3" {}
  required_version = "~> 1.1.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.49"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_cloudfront_distribution" "lambda_at_edge_test_distribution" {
  enabled = true

  origin {
    origin_id = "backend"
    domain_name = "www.staging.publishing.service.gov.uk" # TODO: extract to a variable

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    viewer_protocol_policy = "redirect-to-https"
    target_origin_id = "backend"

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }

    lambda_function_association {
      event_type   = "viewer-request"
      lambda_arn   = aws_lambda_function.lambda_at_edge_test_request_handler.qualified_arn
      include_body = true
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

data "archive_file" "handlers" {
  type        = "zip"
  source_dir  = "${path.module}/../../lambda/CloudfrontHandlers"
  output_path = "${path.module}/../../lambda/CloudfrontHandlers.zip"
}

resource "aws_iam_role" "lambda_at_edge_test_role" {
  name = "lambda_at_edge_test_role"

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

resource "aws_lambda_function" "lambda_at_edge_test_request_handler" {
  filename         = data.archive_file.handlers.output_path
  source_code_hash = data.archive_file.handlers.output_base64sha256

  function_name = "lambda_at_edge_test_request_handler"
  role          = aws_iam_role.lambda_at_edge_test_role.arn
  handler       = "viewerRequest.handler"
  runtime       = "nodejs16.x"
  publish       = true
}
