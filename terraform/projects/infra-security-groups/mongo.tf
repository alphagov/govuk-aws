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
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to mongo"

  tags {
    Name = "${var.stackname}_mongo_access"
  }
}

# the nodes need to speak among themselves for clustering
resource "aws_security_group_rule" "allow_mongo_cluster_in" {
  type      = "ingress"
  from_port = 27017
  to_port   = 27017
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.mongo.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.mongo.id}"
}

resource "aws_security_group_rule" "mongo_elb_in" {
  type      = "ingress"
  from_port = 27017
  to_port   = 27017
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.mongo.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.mongo_elb.id}"
}

resource "aws_security_group" "mongo_elb" {
  name        = "${var.stackname}_mongo_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the Router Mongo cluster"

  tags {
    Name = "${var.stackname}_mongo_elb_access"
  }
}

resource "aws_security_group_rule" "allow_mongo_to_mongo_elb" {
  type      = "ingress"
  from_port = 27017
  to_port   = 27017
  protocol  = "tcp"

  security_group_id = "${aws_security_group.mongo_elb.id}"

  source_security_group_id = "${aws_security_group.mongo.id}"
}

resource "aws_security_group_rule" "allow_frontend_to_mongo_elb" {
  type      = "ingress"
  from_port = 27017
  to_port   = 27017
  protocol  = "tcp"

  security_group_id = "${aws_security_group.mongo_elb.id}"

  source_security_group_id = "${aws_security_group.frontend.id}"
}

resource "aws_security_group_rule" "allow_backend_to_mongo_elb" {
  type      = "ingress"
  from_port = 27017
  to_port   = 27017
  protocol  = "tcp"

  security_group_id = "${aws_security_group.mongo_elb.id}"

  source_security_group_id = "${aws_security_group.backend.id}"
}

resource "aws_security_group_rule" "allow_mongo_elb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.mongo_elb.id}"
}
