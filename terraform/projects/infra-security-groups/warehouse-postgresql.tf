#
# == Manifest: Project: Security Groups: warehouse-postgresql
#
# === Variables:
# stackname - string
#
# === Outputs:
#
#

resource "aws_security_group" "warehouse-postgresql-primary" {
  name        = "${var.stackname}_warehouse-postgresql-primary_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to warehouse-postgresql-primary from its clients"

  tags {
    Name = "${var.stackname}_warehouse-postgresql-primary_access"
  }
}

resource "aws_security_group_rule" "warehouse-postgresql-primary_ingress_backend_postgres" {
  type      = "ingress"
  from_port = 5432
  to_port   = 5432
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.warehouse-postgresql-primary.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.backend.id}"
}

resource "aws_security_group_rule" "warehouse-postgresql-primary_ingress_db-admin_postgres" {
  type      = "ingress"
  from_port = 5432
  to_port   = 5432
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.warehouse-postgresql-primary.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.warehouse-db-admin.id}"
}
