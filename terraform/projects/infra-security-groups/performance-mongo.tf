# == Manifest: Project: Security Groups: performance-mongo
#
# The Router Mongo instances needs to be accessible on ports:
#   - 27017 from other members of the cluster
#   - 27017 from performance-backend
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_performance-mongo_id
# sg_performance-mongo_elb_id
#
resource "aws_security_group" "performance-mongo" {
  name        = "${var.stackname}_performance-mongo_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to performance-mongo"

  tags {
    Name = "${var.stackname}_performance-mongo_access"
  }
}

# the nodes need to speak among themselves for clustering
resource "aws_security_group_rule" "allow_performance-mongo_cluster_in" {
  type      = "ingress"
  from_port = 27017
  to_port   = 27017
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.performance-mongo.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.performance-mongo.id}"
}

resource "aws_security_group_rule" "performance-mongo_elb_in" {
  type      = "ingress"
  from_port = 27017
  to_port   = 27017
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.performance-mongo.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.performance-mongo_elb.id}"
}

resource "aws_security_group" "performance-mongo_elb" {
  name        = "${var.stackname}_performance-mongo_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the Router Mongo cluster"

  tags {
    Name = "${var.stackname}_performance-mongo_elb_access"
  }
}

resource "aws_security_group_rule" "allow_performance-mongo_to_performance-mongo_elb" {
  type      = "ingress"
  from_port = 27017
  to_port   = 27017
  protocol  = "tcp"

  security_group_id = "${aws_security_group.performance-mongo_elb.id}"

  source_security_group_id = "${aws_security_group.performance-mongo.id}"
}

resource "aws_security_group_rule" "allow_performance-backend_to_performance-mongo_elb" {
  type      = "ingress"
  from_port = 27017
  to_port   = 27017
  protocol  = "tcp"

  security_group_id = "${aws_security_group.performance-mongo_elb.id}"

  source_security_group_id = "${aws_security_group.performance-backend.id}"
}

# TODO test whether egress rules are needed on ELBs
resource "aws_security_group_rule" "allow_performance-mongo_elb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.performance-mongo_elb.id}"
}
