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

resource "aws_security_group_rule" "allow_mysql-primary_clients_in" {
  type      = "ingress"
  from_port = 3306
  to_port   = 3306
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.mysql-primary.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.backend.id}"
}
