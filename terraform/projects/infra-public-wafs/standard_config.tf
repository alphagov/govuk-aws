
resource "aws_shield_protection" "account_public_lb" {
  name         = "${var.stackname}-account-public-lb_shield"
  resource_arn = data.terraform_remote_state.infra_public_services.outputs.account_public_lb_id
}

resource "aws_wafv2_web_acl_association" "account_public_web_acl" {
  resource_arn = data.terraform_remote_state.infra_public_services.outputs.account_public_lb_id
  web_acl_arn  = aws_wafv2_web_acl.default.arn
}

resource "aws_shield_protection" "backend_public_lb" {
  name         = "${var.stackname}-backend-public-lb_shield"
  resource_arn = data.terraform_remote_state.infra_public_services.outputs.backend_public_lb_id
}

resource "aws_wafv2_web_acl_association" "backend_public_web_acl" {
  resource_arn = data.terraform_remote_state.infra_public_services.outputs.backend_public_lb_id
  web_acl_arn  = aws_wafv2_web_acl.backend_public.arn
}

resource "aws_shield_protection" "bouncer_public_lb" {
  name         = "${var.stackname}-bouncer-public-lb_shield"
  resource_arn = data.terraform_remote_state.infra_public_services.outputs.bouncer_public_lb_id
}

resource "aws_wafv2_web_acl_association" "bouncer_public_web_acl" {
  resource_arn = data.terraform_remote_state.infra_public_services.outputs.bouncer_public_lb_id
  web_acl_arn  = aws_wafv2_web_acl.bouncer_public.arn
}

resource "aws_wafv2_web_acl_association" "cache_public_web_acl" {
  resource_arn = data.terraform_remote_state.infra_public_services.outputs.cache_public_lb_id
  web_acl_arn  = aws_wafv2_web_acl.cache_public.arn
}

resource "aws_shield_protection" "cache_public_lb" {
  name         = "${var.stackname}-cache-public-lb_shield"
  resource_arn = data.terraform_remote_state.infra_public_services.outputs.cache_public_lb_id
}

resource "aws_shield_protection" "ckan_public_lb" {
  name         = "${var.stackname}-ckan-public-lb_shield"
  resource_arn = data.terraform_remote_state.infra_public_services.outputs.ckan_public_lb_id
}

resource "aws_wafv2_web_acl_association" "ckan_public_web_acl" {
  resource_arn = data.terraform_remote_state.infra_public_services.outputs.ckan_public_lb_id
  web_acl_arn  = aws_wafv2_web_acl.default.arn
}

resource "aws_shield_protection" "deploy_public_lb" {
  name         = "${var.stackname}-deploy-public-lb_shield"
  resource_arn = data.terraform_remote_state.infra_public_services.outputs.deploy_public_lb_id
}

resource "aws_wafv2_web_acl_association" "deploy_public_web_acl" {
  resource_arn = data.terraform_remote_state.infra_public_services.outputs.deploy_public_lb_id
  web_acl_arn  = aws_wafv2_web_acl.default.arn
}

resource "aws_shield_protection" "draft_cache_public_lb" {
  name         = "${var.stackname}-draft-cache-public-lb_shield"
  resource_arn = data.terraform_remote_state.infra_public_services.outputs.draft_cache_public_lb_id
}

resource "aws_wafv2_web_acl_association" "draft_cache_public_web_acl" {
  resource_arn = data.terraform_remote_state.infra_public_services.outputs.draft_cache_public_lb_id
  web_acl_arn  = aws_wafv2_web_acl.default.arn
}

resource "aws_shield_protection" "email_alert_api_public_lb" {
  name         = "${var.stackname}-email-alert-api-public-lb_shield"
  resource_arn = data.terraform_remote_state.infra_public_services.outputs.email_alert_api_public_lb_id
}

resource "aws_wafv2_web_acl_association" "email_alert_api_public_web_acl" {
  resource_arn = data.terraform_remote_state.infra_public_services.outputs.email_alert_api_public_lb_id
  web_acl_arn  = aws_wafv2_web_acl.default.arn
}

resource "aws_shield_protection" "graphite_public_lb" {
  name         = "${var.stackname}-graphite-public-lb_shield"
  resource_arn = data.terraform_remote_state.infra_public_services.outputs.graphite_public_lb_id
}

resource "aws_wafv2_web_acl_association" "graphite_public_web_acl" {
  resource_arn = data.terraform_remote_state.infra_public_services.outputs.graphite_public_lb_id
  web_acl_arn  = aws_wafv2_web_acl.default.arn
}

resource "aws_shield_protection" "licensify_backend_public_lb" {
  name         = "${var.stackname}-licensify-backend-public_shield"
  resource_arn = data.terraform_remote_state.infra_public_services.outputs.licensify_backend_public_lb_id
}

resource "aws_wafv2_web_acl_association" "licensify_backend_public_web_acl" {
  resource_arn = data.terraform_remote_state.infra_public_services.outputs.licensify_backend_public_lb_id
  web_acl_arn  = aws_wafv2_web_acl.default.arn
}

resource "aws_shield_protection" "licensify_frontend_public_lb" {
  name         = "${var.stackname}-licensify-frontend-public_shield"
  resource_arn = data.terraform_remote_state.infra_public_services.outputs.licensify_frontend_public_lb_id
}

resource "aws_wafv2_web_acl_association" "licensify_frontend_web_acl" {
  resource_arn = data.terraform_remote_state.infra_public_services.outputs.licensify_frontend_public_lb_id
  web_acl_arn  = aws_wafv2_web_acl.default.arn
}

resource "aws_shield_protection" "monitoring_public_lb" {
  name         = "${var.stackname}-monitoring-public-lb_shield"
  resource_arn = data.terraform_remote_state.infra_public_services.outputs.monitoring_public_lb_id
}

resource "aws_wafv2_web_acl_association" "monitoring_public_web_acl" {
  resource_arn = data.terraform_remote_state.infra_public_services.outputs.monitoring_public_lb_id
  web_acl_arn  = aws_wafv2_web_acl.default.arn
}

resource "aws_shield_protection" "prometheus_public_lb" {
  name         = "${var.stackname}-prometheus-public-lb_shield"
  resource_arn = data.terraform_remote_state.infra_public_services.outputs.prometheus_public_lb_id
}

resource "aws_wafv2_web_acl_association" "prometheus_public_web_acl" {
  resource_arn = data.terraform_remote_state.infra_public_services.outputs.prometheus_public_lb_id
  web_acl_arn  = aws_wafv2_web_acl.default.arn
}

resource "aws_shield_protection" "sidekiq_monitoring_public_lb" {
  name         = "${var.stackname}-sidekiq-monitoring-public-lb_shield"
  resource_arn = data.terraform_remote_state.infra_public_services.outputs.sidekiq_monitoring_public_lb_id
}

resource "aws_wafv2_web_acl_association" "sidekiq_monitoring_public_web_acl" {
  resource_arn = data.terraform_remote_state.infra_public_services.outputs.sidekiq_monitoring_public_lb_id
  web_acl_arn  = aws_wafv2_web_acl.default.arn
}

resource "aws_shield_protection" "whitehall_backend_public_lb" {
  name         = "${var.stackname}-whitehall-backend-public-lb_shield"
  resource_arn = data.terraform_remote_state.infra_public_services.outputs.whitehall_backend_public_lb_id
}

resource "aws_wafv2_web_acl_association" "whitehall_backend_public_web_acl" {
  resource_arn = data.terraform_remote_state.infra_public_services.outputs.whitehall_backend_public_lb_id
  web_acl_arn  = aws_wafv2_web_acl.default.arn
}
