# this rule matches any request that contains the header X-Always-Block: true
# we use it as a simple sanity check / acceptance test from smokey to ensure that
# the waf is enabled and processing requests
#
resource "aws_wafregional_regex_pattern_set" "x_always_block" {
  name                  = "XAlwaysBlock"
  regex_pattern_strings = ["true"]
}

resource "aws_wafregional_regex_match_set" "x_always_block" {
  name = "XAlwaysBlock"

  regex_match_tuple {
    field_to_match {
      data = "X-Always-Block"
      type = "HEADER"
    }

    regex_pattern_set_id = "${aws_wafregional_regex_pattern_set.x_always_block.id}"
    text_transformation  = "NONE"
  }
}

resource "aws_wafregional_rule" "x_always_block" {
  name        = "XAlwaysBlock"
  metric_name = "XAlwaysBlock"

  predicate {
    data_id = "${aws_wafregional_regex_match_set.x_always_block.id}"
    negated = false
    type    = "RegexMatch"
  }
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
        arn = "${aws_wafv2_regex_pattern_set.x_always_block.arn}"

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
