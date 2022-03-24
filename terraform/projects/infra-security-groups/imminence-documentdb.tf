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

# Allow imminence apps in the backend group to access the imminence documentdb cluster
# See source_security_group_id for how to tighten this.
resource "aws_security_group_rule" "imminence-documentdb_ingress_backend_imminence_apps" {
  type      = "ingress"
  from_port = 27017
  to_port   = 27017
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.imminence-documentdb.id}"

  # Which security group can use this rule
  # When a specialised imminence backend groups is made, update this to
  # lock it down to just that, not all apps in the backend group
  # source_security_group_id = "${aws_security_group.imminence-backend.id}"
  source_security_group_id = "${aws_security_group.backend.id}"
}
