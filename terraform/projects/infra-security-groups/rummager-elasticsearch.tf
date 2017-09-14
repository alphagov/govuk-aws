#
# == Manifest: Project: Security Groups: rummager-elasticsearch
#
# The rummager-elasticsearch needs to be accessible on ports:
#   - 9200 from the logging group
#   - 9300 from other cluster members (in the same SG)
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_rummager-elasticsearch_id
# sg_rummager-elasticsearch_elb_id
#

resource "aws_security_group" "rummager-elasticsearch" {
  name        = "${var.stackname}_rummager-elasticsearch_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to rummager-elasticsearch"

  tags {
    Name = "${var.stackname}_rummager-elasticsearch_access"
  }
}

# the nodes need to speak among themselves for clustering
resource "aws_security_group_rule" "allow_rummager-elasticsearch_cluster_in" {
  type      = "ingress"
  from_port = 9300
  to_port   = 9300
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.rummager-elasticsearch.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.rummager-elasticsearch.id}"
}

resource "aws_security_group_rule" "rummager-elasticsearch_elb_in" {
  type      = "ingress"
  from_port = 9200
  to_port   = 9200
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.rummager-elasticsearch.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.rummager-elasticsearch_elb.id}"
}

resource "aws_security_group" "rummager-elasticsearch_elb" {
  name        = "${var.stackname}_rummager-elasticsearch_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the rummager-elasticsearch ELB"

  tags {
    Name = "${var.stackname}_rummager-elasticsearch_elb_access"
  }
}

resource "aws_security_group_rule" "allow_search_to_rummager-elasticsearch_elb" {
  type      = "ingress"
  from_port = 9200
  to_port   = 9200
  protocol  = "tcp"

  security_group_id = "${aws_security_group.rummager-elasticsearch_elb.id}"

  source_security_group_id = "${aws_security_group.search.id}"
}

resource "aws_security_group_rule" "allow_backend_to_rummager-elasticsearch_elb" {
  type      = "ingress"
  from_port = 9200
  to_port   = 9200
  protocol  = "tcp"

  security_group_id = "${aws_security_group.rummager-elasticsearch_elb.id}"

  source_security_group_id = "${aws_security_group.backend.id}"
}

resource "aws_security_group_rule" "allow_calculators-frontend_to_rummager-elasticsearch_elb" {
  type      = "ingress"
  from_port = 9200
  to_port   = 9200
  protocol  = "tcp"

  security_group_id = "${aws_security_group.rummager-elasticsearch_elb.id}"

  source_security_group_id = "${aws_security_group.calculators-frontend.id}"
}

# TODO test whether egress rules are needed on ELBs
resource "aws_security_group_rule" "allow_rummager-elasticsearch_elb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.rummager-elasticsearch_elb.id}"
}
