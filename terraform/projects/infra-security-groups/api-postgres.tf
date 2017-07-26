#
# == Manifest: Project: Security Groups: api-postgres
#
# === Variables:
# stackname - string
#
# === Outputs:
#
#

resource "aws_security_group" "api-postgres-primary" {
  name        = "${var.stackname}_api-postgres-primary_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to api-postgres-primary from its clients"

  tags {
    Name = "${var.stackname}_api-postgres-primary_access"
  }
}

resource "aws_security_group_rule" "allow_api-postgres_clients_in" {
  type      = "ingress"
  from_port = 5432
  to_port   = 5432
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.api-postgres-primary.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.backend.id}"
}
