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

variable "stackname" {
  type        = "string"
  description = "Stackname"
}

terraform {
  backend          "s3"             {}
  required_version = "= 0.11.14"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "2.33.0"
}

resource "aws_lambda_function" "govuk_csp_forwarder_lambda_function" {
  # Use the replication bucket since it is located in eu-west-2 like the rest
  # of the govuk-tools account contents
  s3_bucket = "govuk-integration-artefact-replication-destination"

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

# API Gateway setup to make the lambda function available over HTTP
resource "aws_api_gateway_rest_api" "govuk_csp_forwarder_api_gateway" {
  name        = "GovukCspForwarder"
  description = "API gateway for GOV.UK CSP Forwarder"
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = "${aws_api_gateway_rest_api.govuk_csp_forwarder_api_gateway.id}"
  parent_id   = "${aws_api_gateway_rest_api.govuk_csp_forwarder_api_gateway.root_resource_id}"
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = "${aws_api_gateway_rest_api.govuk_csp_forwarder_api_gateway.id}"
  resource_id   = "${aws_api_gateway_resource.proxy.id}"
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = "${aws_api_gateway_rest_api.govuk_csp_forwarder_api_gateway.id}"
  resource_id = "${aws_api_gateway_method.proxy.resource_id}"
  http_method = "${aws_api_gateway_method.proxy.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.govuk_csp_forwarder_lambda_function.invoke_arn}"
}

resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id   = "${aws_api_gateway_rest_api.govuk_csp_forwarder_api_gateway.id}"
  resource_id   = "${aws_api_gateway_rest_api.govuk_csp_forwarder_api_gateway.root_resource_id}"
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_root" {
  rest_api_id = "${aws_api_gateway_rest_api.govuk_csp_forwarder_api_gateway.id}"
  resource_id = "${aws_api_gateway_method.proxy_root.resource_id}"
  http_method = "${aws_api_gateway_method.proxy_root.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.govuk_csp_forwarder_lambda_function.invoke_arn}"
}

resource "aws_api_gateway_deployment" "govuk_csp_forwarder_api_gateway_deployment" {
  depends_on = [
    "aws_api_gateway_integration.lambda",
    "aws_api_gateway_integration.lambda_root",
  ]

  rest_api_id = "${aws_api_gateway_rest_api.govuk_csp_forwarder_api_gateway.id}"
  stage_name  = "production"
}

resource "aws_lambda_permission" "govuk_csp_forwarder_api_gateway_invoke_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.govuk_csp_forwarder_lambda_function.arn}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_deployment.govuk_csp_forwarder_api_gateway_deployment.execution_arn}/*/*"
}

output "govuk_csp_forwarder_report_url" {
  value = "${aws_api_gateway_deployment.govuk_csp_forwarder_api_gateway_deployment.invoke_url}"
}
