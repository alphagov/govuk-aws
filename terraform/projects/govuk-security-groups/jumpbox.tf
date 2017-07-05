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
  vpc_id      = "${data.terraform_remote_state.govuk_vpc.vpc_id}"
  description = "Control access to the jumpbox"
}

resource "aws_security_group_rule" "allow_offsite_ssh_to_jumpbox" {
  type                     = "ingress"
  to_port                  = 22
  from_port                = 22
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.jumpbox.id}"
  source_security_group_id = "${aws_security_group.offsite_ssh.id}"
}
