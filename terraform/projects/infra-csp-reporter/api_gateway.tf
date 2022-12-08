resource "aws_apigatewayv2_api" "csp_reporter" {
  name          = "CSP reporter"
  protocol_type = "HTTP"
  description   = "Receive CSP reports"

  tags = {
    aws_environment = var.aws_environment
    project         = local.project_name
  }
}

resource "aws_apigatewayv2_domain_name" "csp_reporter" {
  domain_name = var.domain_name

  domain_name_configuration {
    certificate_arn = var.certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }

  tags = {
    aws_environment = var.aws_environment
    project         = local.project_name
  }
}

resource "aws_apigatewayv2_api_mapping" "csp_reporter" {
  api_id      = aws_apigatewayv2_api.csp_reporter.id
  domain_name = aws_apigatewayv2_domain_name.csp_reporter.id
  stage       = aws_apigatewayv2_stage.default.id
}

resource "aws_apigatewayv2_integration" "csp_reporter" {
  api_id           = aws_apigatewayv2_api.csp_reporter.id
  integration_type = "AWS_PROXY"

  description            = "Receive Content Security Policy reports and post them to Firehose for storage"
  integration_method     = "POST"
  integration_uri        = aws_lambda_function.lambda.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "report_route" {
  api_id    = aws_apigatewayv2_api.csp_reporter.id
  route_key = "POST /report"

  target = "integrations/${aws_apigatewayv2_integration.csp_reporter.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.csp_reporter.id
  name        = "$default"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.csp_reporter_log_group.arn
    # Using Apache Common Log Format (see: https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-logging.html)
    format = "$context.identity.sourceIp - - [$context.requestTime] \"$context.httpMethod $context.routeKey $context.protocol\" $context.status $context.responseLength $context.requestId"
  }
}

resource "aws_cloudwatch_log_group" "csp_reporter_log_group" {
  name              = "/aws/apigateway/csp-reporter"
  retention_in_days = 30

  tags = {
    aws_environment = var.aws_environment
    project         = local.project_name
  }
}

resource "aws_lambda_permission" "gateway_invoke_csp_reports_to_firehose_function" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${aws_apigatewayv2_api.csp_reporter.id}/*/*/report"
}

resource "aws_route53_record" "csp_reporter" {
  name    = "csp-reporter.${data.terraform_remote_state.infra_root_dns_zones.outputs.external_root_domain_name}"
  type    = "A"
  zone_id = data.terraform_remote_state.infra_root_dns_zones.outputs.external_root_zone_id

  alias {
    name                   = aws_apigatewayv2_domain_name.csp_reporter.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.csp_reporter.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}

output "api_gateway_api_endpoint" {
  value       = aws_apigatewayv2_api.csp_reporter.api_endpoint
  description = "API endpoint of the API"
}
