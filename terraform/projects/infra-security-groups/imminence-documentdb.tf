#
# == Manifest: Project: Security Groups: imminence_documentdb
#
# === Variables:
# stackname - string
#
# === Outputs:
#
#

resource "aws_security_group" "imminence-documentdb" {
  name        = "${var.stackname}_imminence_documentdb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to Imminence Documentdb from its clients"

  tags {
    Name = "${var.stackname}_imminence_documentdb_access"
  }
}

resource "aws_security_group_rule" "imminence-documentdb_ingress_db-admin_mongodb" {
  type      = "ingress"
  from_port = 27017
  to_port   = 27017
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.imminence-documentdb.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.db-admin.id}"
}

# Allow imminence apps on backend machines to access the imminence documentdb cluster
resource "aws_security_group_rule" "imminence-documentdb_ingress_backend_imminence_apps" {
  type      = "ingress"
  from_port = 27017
  to_port   = 27017
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.imminence-documentdb.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.imminence-backend.id}"
}
