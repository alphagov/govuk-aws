# == Manifest: Project: Security Groups: api-mongo
#
# The Router Mongo instances needs to be accessible on ports:
#   - 27017 from other members of the cluster
#   - 27017 from content-store
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_api-mongo_id
# sg_api-mongo_elb_id
#
resource "aws_security_group" "api-mongo" {
  name        = "${var.stackname}_api-mongo_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to api-mongo"

  tags {
    Name = "${var.stackname}_api-mongo_access"
  }
}

# the nodes need to speak among themselves for clustering
resource "aws_security_group_rule" "allow_api-mongo_cluster_in" {
  type      = "ingress"
  from_port = 27017
  to_port   = 27017
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.api-mongo.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.api-mongo.id}"
}

resource "aws_security_group_rule" "api-mongo_elb_in" {
  type      = "ingress"
  from_port = 27017
  to_port   = 27017
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.api-mongo.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.api-mongo_elb.id}"
}

resource "aws_security_group" "api-mongo_elb" {
  name        = "${var.stackname}_api-mongo_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the Router Mongo cluster"

  tags {
    Name = "${var.stackname}_api-mongo_elb_access"
  }
}

resource "aws_security_group_rule" "allow_api-mongo_to_api-mongo_elb" {
  type      = "ingress"
  from_port = 27017
  to_port   = 27017
  protocol  = "tcp"

  security_group_id = "${aws_security_group.api-mongo_elb.id}"

  # TODO: does anything other than icinga and logging need this?
  source_security_group_id = "${aws_security_group.api-mongo.id}"
}

resource "aws_security_group_rule" "allow_content-store_to_api-mongo_elb" {
  type      = "ingress"
  from_port = 27017
  to_port   = 27017
  protocol  = "tcp"

  security_group_id = "${aws_security_group.api-mongo_elb.id}"

  # TODO: does anything other than icinga and logging need this?
  source_security_group_id = "${aws_security_group.content-store.id}"
}

# TODO test whether egress rules are needed on ELBs
resource "aws_security_group_rule" "allow_api-mongo_elb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.api-mongo_elb.id}"
}
