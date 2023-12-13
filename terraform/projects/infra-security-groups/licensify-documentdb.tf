#
# == Manifest: Project: Security Groups: licensify-documentdb
#
# === Variables:
# stackname - string
#
# === Outputs:
#
#

resource "aws_security_group" "licensify_documentdb" {
  name        = "${var.stackname}_licensify-documentdb_access"
  vpc_id      = data.terraform_remote_state.infra_vpc.outputs.vpc_id
  description = "Access to licensify documentdb from its clients"

  tags = {
    Name = "${var.stackname}_licensify_documentdb_access"
  }
}

resource "aws_security_group_rule" "licensify-documentdb_ingress_db-admin_mongodb" {
  type        = "ingress"
  from_port   = 27017
  to_port     = 27017
  protocol    = "tcp"
  description = "allow db_admin to access licensify document db"

  # Which security group is the rule assigned to
  security_group_id = aws_security_group.licensify_documentdb.id

  # Which security group can use this rule
  source_security_group_id = aws_security_group.db-admin.id
}

resource "aws_security_group_rule" "licensify-documentdb_ingress_db-licensify_frontend_mongodb" {
  type        = "ingress"
  from_port   = 27017
  to_port     = 27017
  protocol    = "tcp"
  description = "allow licensify frontend nodes to access licensify document db"

  # Which security group is the rule assigned to
  security_group_id = aws_security_group.licensify_documentdb.id

  # Which security group can use this rule
  source_security_group_id = aws_security_group.licensify-frontend.id
}

resource "aws_security_group_rule" "licensify-documentdb_ingress_db-licensify_backend_mongodb" {
  type        = "ingress"
  from_port   = 27017
  to_port     = 27017
  protocol    = "tcp"
  description = "allow licensify backend nodes to access licensify document db"

  # Which security group is the rule assigned to
  security_group_id = aws_security_group.licensify_documentdb.id

  # Which security group can use this rule
  source_security_group_id = aws_security_group.licensify-backend.id
}
