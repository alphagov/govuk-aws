#
# == Manifest: Project: Security Groups: router_documentdb
#
# === Variables:
# stackname - string
#
# === Outputs:
#
#

resource "aws_security_group" "router-documentdb" {
  name        = "${var.stackname}_router_documentdb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to router Documentdb from its clients"

  tags {
    Name = "${var.stackname}_router_documentdb_access"
  }
}

resource "aws_security_group_rule" "router-documentdb_ingress_db-admin_mongodb" {
  type      = "ingress"
  from_port = 27017
  to_port   = 27017
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.router-documentdb.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.db-admin.id}"
}

# Allow router apps on backend machines to access the router documentdb cluster
resource "aws_security_group_rule" "router-documentdb_ingress_backend_router_apps" {
  type      = "ingress"
  from_port = 27017
  to_port   = 27017
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.router-documentdb.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.router-backend.id}"
}
