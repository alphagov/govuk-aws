#
# == Manifest: Project: Security Groups: documentdb
#
# === Variables:
# stackname - string
#
# === Outputs:
#
#

resource "aws_security_group" "documentdb" {
  name        = "${var.stackname}_documentdb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to documentdb from its clients"

  tags {
    Name = "${var.stackname}_documentdb_access"
  }
}

resource "aws_security_group_rule" "documentdb_ingress_jumpbox_mongodb" {
  type      = "ingress"
  from_port = 27017
  to_port   = 27017
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.documentdb.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.jumpbox.id}"
}

# TODO: Add an entry for the security group containing the Licensify instances.

