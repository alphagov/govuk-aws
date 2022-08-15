# this rule matches any request that contains the header X-Always-Block: true
# we use it as a simple sanity check / acceptance test from smokey to ensure that
# the waf is enabled and processing requests
#
resource "aws_wafv2_web_acl" "default" {
  name  = "x-always-block_web_acl"
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
    metric_name                = "x-always-block-web-acl"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl_logging_configuration" "default_web_acl_logging" {
  log_destination_configs = [data.terraform_remote_state.infra_public_services.outputs.kinesis_firehose_splunk_arn]
  resource_arn            = aws_wafv2_web_acl.default.arn
}

resource "aws_wafv2_regex_pattern_set" "x_always_block" {
  name        = "x-always-block_pattern"
  description = "Matches the text we expect in the header"
  scope       = "REGIONAL"

  regular_expression {
    regex_string = "true"
  }
}

resource "aws_wafv2_rule_group" "x_always_block" {
  name  = "x-always-block_rule_group"
  scope = "REGIONAL"

  # regex_pattern_set = 25
  # leaving a bit of head room as this number is immutable
  capacity = 50

  rule {
    name     = "x-always-block_rule"
    priority = 1

    action {
      block {}
    }

    statement {
      regex_pattern_set_reference_statement {
        arn = aws_wafv2_regex_pattern_set.x_always_block.arn

        field_to_match {
          single_header {
            name = "x-always-block"
          }
        }

        text_transformation {
          priority = 1
          type     = "NONE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "x-always-block-rule"
      sampled_requests_enabled   = false
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "x-always-block-rule-group"
    sampled_requests_enabled   = false
  }
}
