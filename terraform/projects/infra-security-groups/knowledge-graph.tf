resource "aws_security_group" "knowledge-graph" {
  name = "${var.stackname}_knowledge-graph_access"

  vpc_id = "${data.terraform_remote_state.infra_vpc.vpc_id}"

  tags {
    Name = "${var.stackname}_knowledge-graph_access"
  }
}

resource "aws_security_group_rule" "knowledge-graph_ingress_ssh" {
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 22
  to_port                  = 22
  source_security_group_id = "${aws_security_group.knowledge-graph_elb_external.id}"

  security_group_id = "${aws_security_group.knowledge-graph.id}"
}

resource "aws_security_group_rule" "knowledge-graph_ingress_https" {
  type      = "ingress"
  protocol  = "tcp"
  from_port = 7473
  to_port   = 7473

  source_security_group_id = "${aws_security_group.knowledge-graph_elb_external.id}"

  security_group_id = "${aws_security_group.knowledge-graph.id}"
}

resource "aws_security_group_rule" "knowledge-graph_ingress_bolt" {
  type      = "ingress"
  protocol  = "tcp"
  from_port = 7687
  to_port   = 7687

  source_security_group_id = "${aws_security_group.knowledge-graph_elb_external.id}"

  security_group_id = "${aws_security_group.knowledge-graph.id}"
}

resource "aws_security_group" "knowledge-graph_elb_external" {
  name = "${var.stackname}_knowledge-graph_elb_external_acess"

  vpc_id = "${data.terraform_remote_state.infra_vpc.vpc_id}"

  tags {
    Name = "${var.stackname}_knowledge-graph_elb_external_acess"
  }
}

#resource "aws_security_group_rule" "knowledge-graph-elb-external_ingress_ssh" {
#  type        = "ingress"
#  protocol    = "tcp"
#  from_port   = 22
#  to_port     = 22
#  cidr_blocks = ["${var.office_ips}"]
#  security_group_id = "${aws_security_group.knowledge-graph_elb_external.id}"
#}

resource "aws_security_group_rule" "knowledge-graph-elb-external_ingress_management_ssh" {
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 22
  to_port                  = 22
  source_security_group_id = "${aws_security_group.management.id}"

  security_group_id = "${aws_security_group.knowledge-graph_elb_external.id}"
}

resource "aws_security_group_rule" "knowledge-graph-elb-external_ingress_https" {
  type        = "ingress"
  protocol    = "tcp"
  from_port   = 7473
  to_port     = 7473
  cidr_blocks = ["${var.office_ips}"]

  security_group_id = "${aws_security_group.knowledge-graph_elb_external.id}"
}

resource "aws_security_group_rule" "knowledge-graph-elb-external_ingress_bolt" {
  type        = "ingress"
  protocol    = "tcp"
  from_port   = 7687
  to_port     = 7687
  cidr_blocks = ["${var.office_ips}"]

  security_group_id = "${aws_security_group.knowledge-graph_elb_external.id}"
}

resource "aws_security_group_rule" "knowledge-graph-elb-external_egress_ssh" {
  type        = "egress"
  protocol    = "tcp"
  from_port   = 22
  to_port     = 22
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.knowledge-graph_elb_external.id}"
}

resource "aws_security_group_rule" "knowledge-graph-elb-external_egress_https" {
  type        = "egress"
  protocol    = "tcp"
  from_port   = 7473
  to_port     = 7473
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.knowledge-graph_elb_external.id}"
}

resource "aws_security_group_rule" "knowledge-graph-elb-external_egress_bolt" {
  type        = "egress"
  protocol    = "tcp"
  from_port   = 7687
  to_port     = 7687
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.knowledge-graph_elb_external.id}"
}
