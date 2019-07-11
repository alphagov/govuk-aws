#
# == Manifest: Project: Security Groups: content-data-api-postgresql
#
# === Variables:
# stackname - string
#
# === Outputs:
#
#

resource "aws_security_group" "content-data-api-postgresql-primary" {
  name        = "${var.stackname}_content-data-api-postgresql-primary_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to content-data-api-postgresql-primary from its clients"

  tags {
    Name = "${var.stackname}_content-data-api-postgresql-primary_access"
  }
}

resource "aws_security_group_rule" "content-data-api-postgresql-primary_ingress_backend_postgres" {
  type      = "ingress"
  from_port = 5432
  to_port   = 5432
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.content-data-api-postgresql-primary.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.backend.id}"
}

resource "aws_security_group_rule" "content-data-api-postgresql-primary_ingress_db-admin_postgres" {
  type      = "ingress"
  from_port = 5432
  to_port   = 5432
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.content-data-api-postgresql-primary.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.content-data-api-db-admin.id}"
}

resource "aws_security_group" "content-data-api-postgresql-primary_ithc_access" {
  name        = "${var.stackname}_content-data-api-postgresql-primary_ithc_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Control access to ITHC SSH"

  tags {
    Name = "${var.stackname}_content-data-api-postgresql-primary_ithc_access"
  }
}

resource "aws_security_group_rule" "ithc_ingress_content-data-api-postgresql-primary_ssh" {
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  cidr_blocks       = "${var.ithc_access_ips}"
  security_group_id = "${aws_security_group.content-data-api-postgresql-primary_ithc_access.id}"
}
