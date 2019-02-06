#
# == Manifest: Project: Security Groups: elasticsearch5
#
# The elasticsearch5 needs to be accessible on ports:
#   - 9200 from the logging group
#   - 9300 from other cluster members (in the same SG)
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_elasticsearch5_id
# sg_elasticsearch5_elb_id
#

resource "aws_security_group" "elasticsearch5" {
  name        = "${var.stackname}_elasticsearch5_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to elasticsearch5"

  tags {
    Name = "${var.stackname}_elasticsearch5_access"
  }
}

# the nodes need to speak among themselves for clustering
resource "aws_security_group_rule" "elasticsearch5_ingress_elasticsearch5_elasticsearch-transport" {
  type      = "ingress"
  from_port = 9300
  to_port   = 9300
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.elasticsearch5.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.elasticsearch5.id}"
}

resource "aws_security_group_rule" "elasticsearch5_ingress_elasticsearch5-elb_elasticsearch-api" {
  type      = "ingress"
  from_port = 9200
  to_port   = 9200
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.elasticsearch5.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.elasticsearch5_elb.id}"
}

resource "aws_security_group" "elasticsearch5_elb" {
  name        = "${var.stackname}_elasticsearch5_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the elasticsearch5 ELB"

  tags {
    Name = "${var.stackname}_elasticsearch5_elb_access"
  }
}

resource "aws_security_group_rule" "elasticsearch5-elb_ingress_search_elasticsearch-api" {
  type      = "ingress"
  from_port = 9200
  to_port   = 9200
  protocol  = "tcp"

  security_group_id = "${aws_security_group.elasticsearch5_elb.id}"

  source_security_group_id = "${aws_security_group.search.id}"
}

resource "aws_security_group_rule" "elasticsearch5-elb_ingress_backend_elasticsearch-api" {
  type      = "ingress"
  from_port = 9200
  to_port   = 9200
  protocol  = "tcp"

  security_group_id = "${aws_security_group.elasticsearch5_elb.id}"

  source_security_group_id = "${aws_security_group.backend.id}"
}

resource "aws_security_group_rule" "elasticsearch5-elb_ingress_calculators-frontend_elasticsearch-api" {
  type      = "ingress"
  from_port = 9200
  to_port   = 9200
  protocol  = "tcp"

  security_group_id = "${aws_security_group.elasticsearch5_elb.id}"

  source_security_group_id = "${aws_security_group.calculators-frontend.id}"
}

resource "aws_security_group_rule" "elasticsearch5-elb_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.elasticsearch5_elb.id}"
}
