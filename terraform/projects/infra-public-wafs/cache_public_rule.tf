resource "aws_wafv2_web_acl" "cache_public" {
  name  = "cache_public_web_acl"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  # this rule matches any request that contains the header X-Always-Block: true
  # we use it as a simple sanity check / acceptance test from smokey to ensure that
  # the waf is enabled and processing requests
  rule {
    name     = "x-always-block_web_acl_rule"
    priority = 1

    override_action {
      none {}
    }

    statement {
      rule_group_reference_statement {
        arn = aws_wafv2_rule_group.x_always_block.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "x-always-block-rule-group"
      sampled_requests_enabled   = true
    }
  }

  # this rule matches any request that contains NAT gateway IPs in the True-Client-IP
  # header and allows it.
  rule {
    name     = "allow-govuk-infra"
    priority = 2

    action {
      allow {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.nat_gateway_ips.arn

        ip_set_forwarded_ip_config {
          fallback_behavior = "NO_MATCH"
          header_name       = "true-client-ip"
          position          = "FIRST"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "govuk-infra-cache-requests"
      sampled_requests_enabled   = true
    }
  }

  # allow Fastly healthchecks to pass unhindered
  rule {
    name     = "allow-fastly-healthchecks"
    priority = 3

    action {
      allow {}
    }

    statement {
      byte_match_statement {
        field_to_match {
          single_header {
            name = "rate-limit-token"
          }
        }

        positional_constraint = "EXACTLY"
        search_string         = var.fastly_rate_limit_token

        text_transformation {
          priority = 1
          type     = "NONE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "fastly-healthcheck-requests"
      sampled_requests_enabled   = true
    }
  }

  # set a base rate limit per IP looking back over the last 5 minutes
  # this is checked every 30s
  rule {
    name     = "cache-public-base-rate-limit"
    priority = 10

    action {
      count {}
    }

    statement {
      rate_based_statement {
        limit              = var.cache_public_base_rate_limit
        aggregate_key_type = "FORWARDED_IP"

        forwarded_ip_config {
          # We expect all requests to have this header set. As we're counting,
          #it's a good chance to verify that by matching any that don't
          fallback_behavior = "MATCH"
          header_name       = "true-client-ip"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "cache-public-base-rate-limit"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "cache-public-web-acl"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_ip_set" "nat_gateway_ips" {
  name               = "nat_gateway_ips"
  description        = "The IP addresses used by our infra to talk to the public internet."
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = formatlist("%s/32", data.terraform_remote_state.infra_networking.outputs.nat_gateway_elastic_ips_list)
}

resource "aws_wafv2_web_acl_logging_configuration" "public_cache_web_acl_logging" {
  log_destination_configs = [data.terraform_remote_state.infra_public_services.outputs.kinesis_firehose_splunk_arn]
  resource_arn            = aws_wafv2_web_acl.cache_public.arn
}
