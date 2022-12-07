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

variable "aws_account_id" {
  type = string
}

# Resources
# --------------------------------------------------------------

# Set up the backend & provider for each region
terraform {
  backend "s3" {}
  required_version = "= 1.3.4"
}

provider "aws" {
  region = var.aws_region
}

provider "archive" {
}

data "aws_caller_identity" "current" {}

#
# Api gateway
#

resource "aws_apigatewayv2_api" "csp_report" {
  name          = "CSP report"
  protocol_type = "HTTP"
  description   = "Receive CSP reports"
}

resource "aws_apigatewayv2_integration" "csp_report" {
  api_id           = aws_apigatewayv2_api.csp_report.id
  integration_type = "AWS_PROXY"

  description               = "Send CSP reports to firehose"
  integration_method        = "POST"
  integration_uri           = aws_lambda_function.CspReportsToFirehose.invoke_arn
}

resource "aws_apigatewayv2_route" "csp_report" {
  api_id    = aws_apigatewayv2_api.csp_report.id
  route_key = "POST /csp_report"

  target = "integrations/${aws_apigatewayv2_integration.csp_report.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id = aws_apigatewayv2_api.csp_report.id
  name   = "$default"
}

# Lambda
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.CspReportsToFirehose.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:${aws_apigatewayv2_api.csp_report.id}/*/${aws_apigatewayv2_route.csp_report.route_key}"
}

data "archive_file" "CspReportsToFirehose" {
  type        = "zip"
  source_file = "${path.module}/../../lambda/CspReportsToFirehose/index.mjs"
  output_path = "${path.module}/../../lambda/CspReportsToFirehose/CspReportsToFirehose.zip"
}

resource "aws_lambda_function" "CspReportsToFirehose" {
  filename         = data.archive_file.CspReportsToFirehose.output_path
  source_code_hash = data.archive_file.CspReportsToFirehose.output_base64sha256

  function_name = "CspReportsToFirehose"
  role          = aws_iam_role.CspReportsToFirehose_lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"
}


resource "aws_iam_role" "CspReportsToFirehose_lambda_role" {
  name = "CspToReportsFirehose"

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

resource "aws_iam_policy_attachment" "CspReportsToFirehose_lambda_attach" {
  name       = "CspReportsToFirehose-lambda-attachment"
  roles      = ["${aws_iam_role.CspReportsToFirehose_lambda_role.name}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

