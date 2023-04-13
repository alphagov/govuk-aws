# == Manifest: Project: Security Groups: mongo
#
# The Mongo instances needs to be accessible on ports:
#   - 27017 from other members of the cluster
#   - 27017 from clients
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_mongo_id
# sg_mongo_elb_id
#
resource "aws_security_group" "mongo" {
  name        = "${var.stackname}_mongo_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.outputs.vpc_id}"
  description = "Access to mongo"

  tags = {
    Name = "${var.stackname}_mongo_access"
  }
}

# the nodes need to speak among themselves for clustering
resource "aws_security_group_rule" "mongo_ingress_mongo_mongo" {
  type      = "ingress"
  from_port = 27017
  to_port   = 27017
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.mongo.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.mongo.id}"
}

resource "aws_security_group_rule" "mongo_ingress_frontend_mongo" {
  type      = "ingress"
  from_port = 27017
  to_port   = 27017
  protocol  = "tcp"

  security_group_id = "${aws_security_group.mongo.id}"

  source_security_group_id = "${aws_security_group.frontend.id}"
}

resource "aws_security_group_rule" "mongo_ingress_calculators-frontend_mongo" {
  type      = "ingress"
  from_port = 27017
  to_port   = 27017
  protocol  = "tcp"

  security_group_id = "${aws_security_group.mongo.id}"

  source_security_group_id = "${aws_security_group.calculators-frontend.id}"
}

resource "aws_security_group_rule" "mongo_ingress_backend_mongo" {
  type      = "ingress"
  from_port = 27017
  to_port   = 27017
  protocol  = "tcp"

  security_group_id = "${aws_security_group.mongo.id}"

  source_security_group_id = "${aws_security_group.backend.id}"
}

resource "aws_security_group_rule" "mongo_ingress_content-store_mongo" {
  type      = "ingress"
  from_port = 27017
  to_port   = 27017
  protocol  = "tcp"

  security_group_id = "${aws_security_group.mongo.id}"

  source_security_group_id = "${aws_security_group.content-store.id}"
}

resource "aws_security_group_rule" "mongo_ingress_draft-content-store_mongo" {
  type      = "ingress"
  from_port = 27017
  to_port   = 27017
  protocol  = "tcp"

  security_group_id = "${aws_security_group.mongo.id}"

  source_security_group_id = "${aws_security_group.draft-content-store.id}"
}
