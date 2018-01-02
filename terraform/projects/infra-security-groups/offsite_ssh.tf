#
# == Manifest: Project: Security Groups: SSH
#
# This security group allows SSH access on port 22 from the office IPs
#
# In normal operation it should only be applied to the jumpbox but
# will also be added to the puppetmaster during recovery.
#
# === Variables:
# stackname - string
# office_ips - array of CIDR blocks
#

resource "aws_security_group" "offsite_ssh" {
  name        = "${var.stackname}_ssh_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to SSH and egress"

  tags {
    Name = "${var.stackname}_ssh_access"
  }
}

resource "aws_security_group_rule" "offsite-ssh_ingress_office-and-carrenza_ssh" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["${concat(var.office_ips, var.carrenza_integration_ips)}"]

  security_group_id = "${aws_security_group.offsite_ssh.id}"
}

resource "aws_security_group_rule" "offsite-ssh_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.offsite_ssh.id}"
}
