#
# == Manifest: Project: Security Groups: pgbouncer
#
# === Variables:
# stackname - string
#
# === Outputs:
#
#

resource "aws_security_group_rule" "db-admin_ingress_backend_pgbouncer" {
  type      = "ingress"
  from_port = 6432
  to_port   = 6432
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.db-admin_elb.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.backend.id}"
}

resource "aws_security_group_rule" "db-admin_ingress_ckan_pgbouncer" {
  type      = "ingress"
  from_port = 6432
  to_port   = 6432
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.db-admin_elb.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.ckan.id}"
}

resource "aws_security_group_rule" "db-admin_ingress_email-alert-api_pgbouncer" {
  type      = "ingress"
  from_port = 6432
  to_port   = 6432
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.db-admin_elb.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.email-alert-api.id}"
}

resource "aws_security_group_rule" "db-admin_ingress_publishing-api_pgbouncer" {
  type      = "ingress"
  from_port = 6432
  to_port   = 6432
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.db-admin_elb.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.publishing-api.id}"
}
