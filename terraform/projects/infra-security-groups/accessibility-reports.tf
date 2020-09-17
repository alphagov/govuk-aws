resource "aws_security_group" "accessibility-reports" {
  name = "${var.stackname}_accessibility-reports_access"

  vpc_id = "${data.terraform_remote_state.infra_vpc.vpc_id}"

  tags {
    Name = "accessibility-reports"
  }
}

resource "aws_security_group_rule" "accessibility-reports_ingress_office_ssh" {
  type        = "ingress"
  protocol    = "tcp"
  from_port   = 22
  to_port     = 22
  cidr_blocks = ["${var.office_ips}"]

  security_group_id = "${aws_security_group.accessibility-reports.id}"
}

resource "aws_security_group_rule" "accessibility-reports_egress_any_any" {
  type        = "egress"
  protocol    = "-1"
  from_port   = 0
  to_port     = 0
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.accessibility-reports.id}"
}
