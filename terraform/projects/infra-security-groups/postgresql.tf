#
# == Manifest: Project: Security Groups: postgresql
#
# === Variables:
# stackname - string
#
# === Outputs:
#
#

resource "aws_security_group" "postgresql-primary" {
  name        = "${var.stackname}_postgresql-primary_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to postgresql-primary from its clients"

  tags {
    Name = "${var.stackname}_postgresql-primary_access"
  }
}

resource "aws_security_group_rule" "postgresql-primary_ingress_backend_postgres" {
  type      = "ingress"
  from_port = 5432
  to_port   = 5432
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.postgresql-primary.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.backend.id}"
}

resource "aws_security_group_rule" "postgresql-primary_ingress_ckan_postgres" {
  type      = "ingress"
  from_port = 5432
  to_port   = 5432
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.postgresql-primary.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.ckan.id}"
}

resource "aws_security_group_rule" "postgresql-primary_ingress_email-alert-api_postgres" {
  type      = "ingress"
  from_port = 5432
  to_port   = 5432
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.postgresql-primary.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.email-alert-api.id}"
}

resource "aws_security_group_rule" "postgresql-primary_ingress_publishing-api_postgres" {
  type      = "ingress"
  from_port = 5432
  to_port   = 5432
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.postgresql-primary.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.publishing-api.id}"
}

resource "aws_security_group_rule" "postgresql-primary_ingress_db-admin_postgres" {
  type      = "ingress"
  from_port = 5432
  to_port   = 5432
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.postgresql-primary.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.db-admin.id}"
}

resource "aws_security_group_rule" "postgresql-primary_ingress_data-science-data_postgres" {
  type      = "ingress"
  from_port = 5432
  to_port   = 5432
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.postgresql-primary.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.data-science-data.id}"
}
