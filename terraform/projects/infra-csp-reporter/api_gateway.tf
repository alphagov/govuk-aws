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
