/**
* ## Module: govuk-csp-forwarder
*
* Configures a role and Lambda function to collect Content Security Policy
* reports, filter them and forward them to Sentry.
*/
variable "aws_region" {
  type        = "string"
  description = "AWS region"
  default     = "eu-west-2"
}

variable "aws_environment" {
  type        = "string"
  description = "AWS Environment"
}

variable "stackname" {
  type        = "string"
  description = "Stackname"
}

terraform {
  backend          "s3"             {}
  required_version = "= 0.11.7"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "1.40.0"
}

provider "aws" {
  region  = "eu-west-1"
  version = "1.40.0"
  alias   = "eu-west-1-region"
}

resource "aws_lambda_function" "govuk_csp_forwarder_lambda_function" {
  provider      = "aws.eu-west-1-region"
  s3_bucket     = "govuk-integration-artefact"
  s3_key        = "govuk-csp-forwarder/release/csp_forwarder.zip"
  function_name = "govuk-csp-forwarder"
  role          = "${aws_iam_role.govuk_csp_forwarder_lambda_role.arn}"
  handler       = "csp_forwarder"
  runtime       = "go1.x"
}

resource "aws_iam_role" "govuk_csp_forwarder_lambda_role" {
  name = "govuk_csp_forwarder_lambda_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
