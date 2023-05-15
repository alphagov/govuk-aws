#
# == Manifest: Project: Security Groups: transition-postgresql
#
# === Variables:
# stackname - string
#
# === Outputs:
#
#

resource "aws_security_group" "transition-postgresql-primary" {
  name        = "${var.stackname}_transition-postgresql-primary_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.outputs.vpc_id}"
  description = "Access to transition-postgresql-primary from its clients"

  tags = {
    Name = "${var.stackname}_transition-postgresql-primary_access"
  }
}

resource "aws_security_group" "transition-postgresql-standby" {
  name        = "${var.stackname}_transition-postgresql-standby_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.outputs.vpc_id}"
  description = "Access to transition-postgresql-standby from its clients"

  tags = {
    Name = "${var.stackname}_transition-postgresql-standby_access"
  }
}

resource "aws_security_group_rule" "transition-postgresql-primary_ingress_db-admin_postgres" {
  type      = "ingress"
  from_port = 5432
  to_port   = 5432
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.transition-postgresql-primary.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.transition-db-admin.id}"
}
