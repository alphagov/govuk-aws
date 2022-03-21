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

    regex_pattern_set_id = aws_wafregional_regex_pattern_set.x_always_block.id
    text_transformation  = "NONE"
  }
}

resource "aws_wafregional_rule" "x_always_block" {
  name        = "XAlwaysBlock"
  metric_name = "XAlwaysBlock"

  predicate {
    data_id = aws_wafregional_regex_match_set.x_always_block.id
    negated = false
    type    = "RegexMatch"
  }
}
