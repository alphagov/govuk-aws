# this rule matches any request that contains the header X-Always-Block: true
# we use it as a simple sanity check / acceptance test from smokey to ensure that
# the waf is enabled and processing requests
#
resource "aws_wafv2_web_acl" "cache_public" {
  name  = "cache_public_web_acl"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

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
      cloudwatch_metrics_enabled = false
      metric_name                = "x-always-block-rule-group"
      sampled_requests_enabled   = false
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "cache-public-web-acl"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl_logging_configuration" "public_cache_web_acl_logging" {
  log_destination_configs = [data.terraform_remote_state.infra_public_services.outputs.kinesis_firehose_splunk_arn]
  resource_arn            = aws_wafv2_web_acl.cache_public.arn
}
