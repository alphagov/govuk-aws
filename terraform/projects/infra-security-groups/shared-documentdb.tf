#
# == Manifest: Project: Security Groups: shared_documentdb
#
# === Variables:
# stackname - string
#
# === Outputs:
#
#

resource "aws_security_group" "shared-documentdb" {
  name        = "${var.stackname}_shared_documentdb_access"
  vpc_id      = data.terraform_remote_state.infra_vpc.outputs.vpc_id
  description = "Access to Shared Documentdb from its clients"

  tags = {
    Name = "${var.stackname}_shared_documentdb_access"
  }
}

resource "aws_security_group_rule" "shared-documentdb_ingress_db-admin_mongodb" {
  type      = "ingress"
  from_port = 27017
  to_port   = 27017
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = aws_security_group.shared-documentdb.id

  # Which security group can use this rule
  source_security_group_id = aws_security_group.db-admin.id
}
