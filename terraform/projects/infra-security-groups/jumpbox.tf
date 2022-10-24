#
# == Manifest: Project: Security Groups: jumpbox
#
# Security groups for connecting from the jumpbox ELB to the jumpbox
#
# === Variables:
#
# stackname - string
#
# === Outputs:
# sg_jumpbox_id

resource "aws_security_group" "jumpbox" {
  name        = "${var.stackname}_jumpbox_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Control access to the jumpbox"

  tags {
    Name = "${var.stackname}_jumpbox_access"
  }
}

resource "aws_security_group_rule" "jumpbox_ingress_offsite-ssh_ssh" {
  type                     = "ingress"
  to_port                  = 22
  from_port                = 22
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.jumpbox.id}"
  source_security_group_id = "${aws_security_group.offsite_ssh.id}"
}

resource "aws_security_group" "jumpbox_ithc_access" {
  count       = "${length(var.ithc_access_ips) > 0 ? 1 : 0}"
  name        = "${var.stackname}_jumpbox_ithc_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Control access to ITHC SSH"

  tags {
    Name = "${var.stackname}_jumpbox_ithc_access"
  }
}

resource "aws_security_group_rule" "ithc_ingress_jumpbox_ssh" {
  count             = "${length(var.ithc_access_ips) > 0 ? 1 : 0}"
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  cidr_blocks       = "${var.ithc_access_ips}"
  security_group_id = "${aws_security_group.jumpbox_ithc_access.id}"
}
