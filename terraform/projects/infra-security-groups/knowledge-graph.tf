resource "aws_security_group" "knowledge-graph" {
  name = "${var.stackname}_knowledge-graph_access"

  vpc_id = "${data.terraform_remote_state.infra_vpc.vpc_id}"

  tags {
    Name = "${var.stackname}_knowledge-graph_access"
  }
}

resource "aws_security_group_rule" "knowledge-graph_ingress_knowledge-graph-elb_ssh" {
  type      = "ingress"
  protocol  = "tcp"
  from_port = 22
  to_port   = 22

  source_security_group_id = "${aws_security_group.knowledge-graph_elb_external.id}"

  security_group_id = "${aws_security_group.knowledge-graph.id}"
}

resource "aws_security_group_rule" "knowledge-graph_ingress_knowledge-graph-elb_https" {
  type      = "ingress"
  protocol  = "tcp"
  from_port = 7473
  to_port   = 7473

  source_security_group_id = "${aws_security_group.knowledge-graph_elb_external.id}"

  security_group_id = "${aws_security_group.knowledge-graph.id}"
}

resource "aws_security_group_rule" "knowledge-graph_ingress_knowledge-graph-visualisation-elb_https" {
  type      = "ingress"
  protocol  = "tcp"
  from_port = 3000
  to_port   = 3000

  source_security_group_id = "${aws_security_group.knowledge-graph_elb_external.id}"

  security_group_id = "${aws_security_group.knowledge-graph.id}"
}

resource "aws_security_group_rule" "knowledge-graph_ingress_knowledge-graph-elb_bolt" {
  type      = "ingress"
  protocol  = "tcp"
  from_port = 7687
  to_port   = 7687

  source_security_group_id = "${aws_security_group.knowledge-graph_elb_external.id}"

  security_group_id = "${aws_security_group.knowledge-graph.id}"
}

resource "aws_security_group_rule" "knowledge-graph_egress_any_any" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.knowledge-graph.id}"
}

resource "aws_security_group" "knowledge-graph_elb_external" {
  name = "${var.stackname}_knowledge-graph_elb_external_access"

  vpc_id = "${data.terraform_remote_state.infra_vpc.vpc_id}"

  tags {
    Name = "${var.stackname}_knowledge-graph_elb_external_access"
  }
}

resource "aws_security_group_rule" "knowledge-graph-elb-external_ingress_office_ssh" {
  type        = "ingress"
  protocol    = "tcp"
  from_port   = 22
  to_port     = 22
  cidr_blocks = ["${var.office_ips}"]

  security_group_id = "${aws_security_group.knowledge-graph_elb_external.id}"
}

resource "aws_security_group_rule" "knowledge-graph-elb-external_ingress_office_https" {
  type        = "ingress"
  protocol    = "tcp"
  from_port   = 7473
  to_port     = 7473
  cidr_blocks = ["${var.office_ips}"]

  security_group_id = "${aws_security_group.knowledge-graph_elb_external.id}"
}

resource "aws_security_group_rule" "knowledge-graph-visualisation-elb-external_ingress_office_https" {
  type        = "ingress"
  protocol    = "tcp"
  from_port   = 443
  to_port     = 443
  cidr_blocks = ["${var.office_ips}"]

  security_group_id = "${aws_security_group.knowledge-graph_elb_external.id}"
}

resource "aws_security_group_rule" "knowledge-graph-elb-external_ingress_office_bolt" {
  type        = "ingress"
  protocol    = "tcp"
  from_port   = 7687
  to_port     = 7687
  cidr_blocks = ["${var.office_ips}"]

  security_group_id = "${aws_security_group.knowledge-graph_elb_external.id}"
}

resource "aws_security_group_rule" "knowledge-graph-elb-external_egress_any_ssh" {
  type        = "egress"
  protocol    = "tcp"
  from_port   = 22
  to_port     = 22
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.knowledge-graph_elb_external.id}"
}

resource "aws_security_group_rule" "knowledge-graph-elb-external_egress_any_https" {
  type        = "egress"
  protocol    = "tcp"
  from_port   = 7473
  to_port     = 7473
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.knowledge-graph_elb_external.id}"
}

resource "aws_security_group_rule" "knowledge-graph-visualisation-elb-external_egress_any_https" {
  type        = "egress"
  protocol    = "tcp"
  from_port   = 443
  to_port     = 443
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.knowledge-graph_elb_external.id}"
}

resource "aws_security_group_rule" "knowledge-graph-elb-external_egress_any_bolt" {
  type        = "egress"
  protocol    = "tcp"
  from_port   = 7687
  to_port     = 7687
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.knowledge-graph_elb_external.id}"
}
