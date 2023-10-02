
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
  web_acl_arn  = aws_wafv2_web_acl.licensify_backend_public.arn
}

resource "aws_shield_protection" "licensify_frontend_public_lb" {
  name         = "${var.stackname}-licensify-frontend-public_shield"
  resource_arn = data.terraform_remote_state.infra_public_services.outputs.licensify_frontend_public_lb_id
}

resource "aws_wafv2_web_acl_association" "licensify_frontend_web_acl" {
  resource_arn = data.terraform_remote_state.infra_public_services.outputs.licensify_frontend_public_lb_id
  web_acl_arn  = aws_wafv2_web_acl.licensify_frontend_public.arn
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
