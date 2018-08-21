#
# == Manifest: Project: Security Groups: email-alert-api-postgresql
#
# === Variables:
# stackname - string
#
# === Outputs:
#
#

resource "aws_security_group" "email-alert-api-postgresql-primary" {
  name        = "${var.stackname}_email-alert-api-postgresql-primary_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to email-alert-api-postgresql-primary from its clients"

  tags {
    Name = "${var.stackname}_email-alert-api-postgresql-primary_access"
  }
}

resource "aws_security_group" "email-alert-api-postgresql-standby" {
  name        = "${var.stackname}_email-alert-api-postgresql-standby_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to email-alert-api-postgresql-standby from its clients"

  tags {
    Name = "${var.stackname}_email-alert-api-postgresql-standby_access"
  }
}

resource "aws_security_group_rule" "email-alert-api-postgresql-primary_ingress_backend_postgres" {
  type      = "ingress"
  from_port = 5432
  to_port   = 5432
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.email-alert-api-postgresql-primary.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.backend.id}"
}

resource "aws_security_group_rule" "email-alert-api-postgresql-primary_ingress_db-admin_postgres" {
  type      = "ingress"
  from_port = 5432
  to_port   = 5432
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.email-alert-api-postgresql-primary.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.email-alert-api-db-admin.id}"
}
