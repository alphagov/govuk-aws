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
  integration_uri           = aws_lambda_function.lambda.invoke_arn
  payload_format_version    = "2.0"
}

resource "aws_apigatewayv2_route" "csp_report" {
  api_id    = aws_apigatewayv2_api.csp_report.id
  route_key = "POST /csp_report"

  target = "integrations/${aws_apigatewayv2_integration.csp_report.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.csp_report.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_domain_name" "csp_report" {
  domain_name = "csp-report.${data.terraform_remote_state.infra_root_dns_zones.outputs.external_root_domain_name}"

  domain_name_configuration {
    certificate_arn = "${data.terraform_remote_state.infra_certificates.outputs.external_certificate_arn}"
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_route53_record" "csp_report" {
  name    = aws_apigatewayv2_domain_name.csp_report.domain_name
  type    = "A"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.outputs.external_root_zone_id}"

  alias {
    name                   = aws_apigatewayv2_domain_name.csp_report.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.csp_report.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}
