resource "aws_security_group" "related-links" {
  name = "related-links_access"

  vpc_id = "${data.terraform_remote_state.infra_vpc.outputs.vpc_id}"

  tags = {
    Name = "related-links"
  }
}

resource "aws_security_group_rule" "related-links_ingress_jenkins_ssh" {
  type      = "ingress"
  protocol  = "tcp"
  from_port = 22
  to_port   = 22

  source_security_group_id = "${aws_security_group.deploy.id}"

  security_group_id = "${aws_security_group.related-links.id}"
}

resource "aws_security_group_rule" "related-links_egress_any_any" {
  type        = "egress"
  protocol    = "-1"
  from_port   = 0
  to_port     = 0
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.related-links.id}"
}
