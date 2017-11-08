#
# == Manifest: Project: Security Groups: mysql-primary
#
# === Variables:
# stackname - string
#
# === Outputs:
#
#

resource "aws_security_group" "mysql-primary" {
  name        = "${var.stackname}_mysql-primary_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to mysql-primary from its clients"

  tags {
    Name = "${var.stackname}_mysql-primary_access"
  }
}

resource "aws_security_group_rule" "allow_mysql-primary_from_backend" {
  type      = "ingress"
  from_port = 3306
  to_port   = 3306
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.mysql-primary.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.backend.id}"
}

resource "aws_security_group_rule" "allow_mysql-primary_from_whitehall-backend" {
  type      = "ingress"
  from_port = 3306
  to_port   = 3306
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.mysql-primary.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.whitehall-backend.id}"
}

resource "aws_security_group_rule" "allow_mysql-primary_from_whitehall-frontend" {
  type      = "ingress"
  from_port = 3306
  to_port   = 3306
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.mysql-primary.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.whitehall-frontend.id}"
}

resource "aws_security_group_rule" "allow_mysql-primary_db-admin_in" {
  type      = "ingress"
  from_port = 3306
  to_port   = 3306
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.mysql-primary.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.db-admin.id}"
}

resource "aws_security_group" "mysql-replica" {
  name        = "${var.stackname}_mysql-replica_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to mysql-replica from its clients"

  tags {
    Name = "${var.stackname}_mysql-replica_access"
  }
}

# Contacts is the only application that reads from the MySQL replica
resource "aws_security_group_rule" "allow_frontend_to_mysql-replica_3306" {
  type      = "ingress"
  from_port = 3306
  to_port   = 3306
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.mysql-replica.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.frontend.id}"
}
