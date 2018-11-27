resource "aws_security_group" "vpn" {
  name        = "${var.stackname}_vpn"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "This is the group use to access AWS from Carrenza"

  tags {
    Name = "${var.stackname}_vpn_access"
  }
}

resource "aws_security_group_rule" "vpn_ingress_icmp_icmp" {
  type      = "ingress"
  from_port = 8
  to_port   = 0
  protocol  = "icmp"

  security_group_id = "${aws_security_group.vpn.id}"

  cidr_blocks = "${var.carrenza_subnet_cidr}"
}

resource "aws_security_group_rule" "vpn_ingress_http_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  security_group_id = "${aws_security_group.vpn.id}"

  cidr_blocks = "${var.carrenza_subnet_cidr}"
}

resource "aws_security_group_rule" "vpn_ingress_https_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id = "${aws_security_group.vpn.id}"

  cidr_blocks = "${var.carrenza_subnet_cidr}"
}
