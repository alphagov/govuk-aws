resource "aws_security_group" "vpn" {
  count       = "${length(var.carrenza_vpn_subnet_cidr) > 0 ? 1 : 0}"
  name        = "${var.stackname}_vpn"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "This is the group used to access AWS from Carrenza"

  tags {
    Name = "${var.stackname}_vpn_access"
  }
}

resource "aws_security_group_rule" "vpn_ingress_aws_carrenza" {
  count     = "${length(var.carrenza_vpn_subnet_cidr) > 0 ? 1 : 0}"
  type      = "ingress"
  from_port = 8
  to_port   = 0
  protocol  = "icmp"

  security_group_id = "${aws_security_group.vpn.id}"

  cidr_blocks = "${var.carrenza_vpn_subnet_cidr}"
}

resource "aws_security_group_rule" "vpn_egress_carrenza_aws" {
  count     = "${length(var.carrenza_vpn_subnet_cidr) > 0 ? 1 : 0}"
  type      = "egress"
  from_port = 8
  to_port   = 0
  protocol  = "icmp"

  security_group_id = "${aws_security_group.vpn.id}"

  cidr_blocks = "${var.carrenza_vpn_subnet_cidr}"
}

resource "aws_security_group_rule" "vpn_ingress_http_http" {
  count     = "${length(var.carrenza_vpn_subnet_cidr) > 0 ? 1 : 0}"
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  security_group_id = "${aws_security_group.vpn.id}"

  cidr_blocks = "${var.carrenza_vpn_subnet_cidr}"
}

resource "aws_security_group_rule" "vpn_ingress_https_https" {
  count     = "${length(var.carrenza_vpn_subnet_cidr) > 0 ? 1 : 0}"
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id = "${aws_security_group.vpn.id}"

  cidr_blocks = "${var.carrenza_vpn_subnet_cidr}"
}
