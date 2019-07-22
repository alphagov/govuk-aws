# As obtained from https://raw.githubusercontent.com/juiceinc/terraform-aws-juiceinc-waf/master/sqlinjection.tf
#
# SQL Injection is a built-in type of traffic that the WAF knows how to filter.  To my knowledge we are left to the mercy
# of their heuristics on the backend to correctly classify elements as containing malicious SQL.  We just specify which
# fields to match on and any transformations to do.

# As of this writing valid values for field_to_match are: HEADER (if using this also must set a data value), METHOD,
# QUERY_STRING, URI, BODY, SINGLE_QUERY_ARG, ALL_QUERY_ARGS.

# Valid values for text_transformation include: CMD_LINE, COMPRESS_WHITE_SPACE, HTML_ENTITY_DECODE, LOWERCASE, NONE, and
# URL_DECODE

# The following rule set was transcribed from the AWS example in their CloudFormation template.

resource "aws_wafregional_sql_injection_match_set" "sqli" {
  name = "SQLInjection"

  sql_injection_match_tuple {
    text_transformation = "URL_DECODE"

    field_to_match {
      type = "BODY"
    }
  }

  sql_injection_match_tuple {
    text_transformation = "HTML_ENTITY_DECODE"

    field_to_match {
      type = "BODY"
    }
  }

  sql_injection_match_tuple {
    text_transformation = "HTML_ENTITY_DECODE"

    field_to_match {
      type = "URI"
    }
  }

  sql_injection_match_tuple {
    text_transformation = "URL_DECODE"

    field_to_match {
      type = "URI"
    }
  }

  sql_injection_match_tuple {
    text_transformation = "URL_DECODE"

    field_to_match {
      type = "QUERY_STRING"
    }
  }

  sql_injection_match_tuple {
    text_transformation = "HTML_ENTITY_DECODE"

    field_to_match {
      type = "QUERY_STRING"
    }
  }

  sql_injection_match_tuple {
    text_transformation = "HTML_ENTITY_DECODE"

    field_to_match {
      type = "HEADER"
      data = "cookie"
    }
  }

  sql_injection_match_tuple {
    text_transformation = "URL_DECODE"

    field_to_match {
      type = "HEADER"
      data = "cookie"
    }
  }

  sql_injection_match_tuple {
    text_transformation = "HTML_ENTITY_DECODE"

    field_to_match {
      type = "HEADER"
      data = "authorization"
    }
  }

  sql_injection_match_tuple {
    text_transformation = "URL_DECODE"

    field_to_match {
      type = "HEADER"
      data = "authorization"
    }
  }
}

resource "aws_wafregional_rule" "sqli" {
  name        = "SQLInjection"
  metric_name = "SQLInjection"

  predicate {
    data_id = "${aws_wafregional_sql_injection_match_set.sqli.id}"
    negated = false
    type    = "SqlInjectionMatch"
  }
}
