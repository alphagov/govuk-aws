resource "aws_security_group_rule" "foo_ingress_bar_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "foo"

  # Which security group can use this rule
  source_security_group_id = "bar"
}

resource "aws_security_group_rule" "allow_yellow_from_blue" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "foo"

  # Which security group can use this rule
  source_security_group_id = "bar"
}
