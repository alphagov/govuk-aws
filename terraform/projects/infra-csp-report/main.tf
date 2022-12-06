/**
* ## Project: infra-csp-report
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
# Api gateway
#

resource "aws_api_gateway_rest_api" "csp_report" {
  name        = "CSP report"
  description = "Receive CSP reports"
}

resource "aws_api_gateway_resource" "csp_report" {
  rest_api_id = aws_api_gateway_rest_api.csp_report.id
  parent_id   = aws_api_gateway_rest_api.csp_report.root_resource_id
  path_part   = "csp-report"
}

resource "aws_api_gateway_method" "post" {
  rest_api_id   = aws_api_gateway_rest_api.csp_report.id
  resource_id   = aws_api_gateway_resource.csp_report.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "Post_Integration" {
  rest_api_id             = aws_api_gateway_rest_api.csp_report.id
  resource_id             = aws_api_gateway_resource.csp_report.id
  http_method             = aws_api_gateway_method.post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.CspReportsToFirehose.invoke_arn
}

# Lambda
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.CspReportsToFirehose.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.myregion}:${var.accountId}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.method.http_method}${aws_api_gateway_resource.resource.path}"
}

data "archive_file" "CspReportsToFirehose" {
  type        = "zip"
  source_file = "${path.module}/../../lambda/CspReportsToFirehose/index.mjs"
  output_path = "${path.module}/../../lambda/CspReportsToFirehose/CspReportsToFirehose.zip"
}

resource "aws_lambda_function" "CspReportsToFirehose" {
  filename         = "${data.archive_file.CspReportsToFirehose.output_path}"
  source_code_hash = "${data.archive_file.CspReportsToFirehose.output_base64sha256}"

  function_name = "CspReportsToFirehose"
  role          = "${aws_iam_role.CspReportsToFirehose_lambda_role.arn}"
  handler       = "index.handler"
  runtime       = "nodejs18.x"
}

resource "aws_iam_role" "CspReportsToFirehose_lambda_role" {
  name = "CspToReportsFirehose"

  assume_role_policy = <<POLICY
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
POLICY
}
