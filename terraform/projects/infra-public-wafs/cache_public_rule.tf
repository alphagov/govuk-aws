resource "aws_wafv2_web_acl" "cache_public" {
  name  = "cache_public_web_acl"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  # Rules are defined in https://github.com/alphagov/govuk-aws-data/blob/main/data/infra-public-wafs/cache_public_rule_override.tf
}

# Can be deleted once the new set has been associated with the rule and applied
resource "aws_wafv2_ip_set" "nat_gateway_ips" {
  name               = "nat_gateway_ips"
  description        = "The IP addresses used by our infra to talk to the public internet."
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = formatlist("%s/32", data.terraform_remote_state.infra_networking.outputs.nat_gateway_elastic_ips_list)
}

locals {
  # formatting into a CIDR block as expected by the aws_wafv2_ip_set below
  nat_gateway_ips = formatlist("%s/32", data.terraform_remote_state.infra_networking.outputs.nat_gateway_elastic_ips_list)
}

resource "aws_wafv2_ip_set" "govuk_requesting_ips" {
  name               = "govuk_requesting_ips"
  description        = "The IP addresses used by our infra to make requests that hit the cache LB."
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = concat(var.traffic_replay_ips, local.nat_gateway_ips, var.eks_egress_ips)
}

resource "aws_wafv2_ip_set" "external_partner_ips" {
  name               = "external_partner_ips"
  description        = "The IP addresses are used by our partners."
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = var.allow_external_ips
}

resource "aws_cloudwatch_log_group" "public_cache_waf" {
  # the name must start with aws-waf-logs
  # https://docs.aws.amazon.com/waf/latest/developerguide/logging-cw-logs.html#logging-cw-logs-naming
  name              = "aws-waf-logs-cache-public-${var.aws_environment}"
  retention_in_days = var.waf_log_retention_days

  tags = {
    Project       = var.stackname
    aws_stackname = var.stackname
  }
}

resource "aws_wafv2_web_acl_logging_configuration" "public_cache_waf" {
  log_destination_configs = [aws_cloudwatch_log_group.public_cache_waf.arn]
  resource_arn            = aws_wafv2_web_acl.cache_public.arn

  logging_filter {
    default_behavior = "DROP"

    filter {
      behavior = "KEEP"

      condition {
        action_condition {
          action = "COUNT"
        }
      }

      condition {
        action_condition {
          action = "BLOCK"
        }
      }

      requirement = "MEETS_ANY"
    }
  }
}
