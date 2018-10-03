#
# == Manifest: Project: Security Groups: ubuntutest
#
# Security groups for connecting from the ubuntutest ELB to the ubuntutest
#
# === Variables:
#
# stackname - string
#
# === Outputs:
# sg_ubuntutest_id

resource "aws_security_group" "ubuntutest" {
  name        = "${var.stackname}_ubuntutest_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Control access to the ubuntutest"

  tags {
    Name = "${var.stackname}_ubuntutest_access"
  }
}

resource "aws_security_group_rule" "ubuntutest_ingress_offsite-ssh_ssh" {
  type                     = "ingress"
  to_port                  = 22
  from_port                = 22
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.ubuntutest.id}"
  source_security_group_id = "${aws_security_group.offsite_ssh.id}"
}
