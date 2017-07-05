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
  description = "Access to SSH"
}

resource "aws_security_group_rule" "allow_offsite_ssh" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["${var.office_ips}"]

  security_group_id = "${aws_security_group.offsite_ssh.id}"
}
