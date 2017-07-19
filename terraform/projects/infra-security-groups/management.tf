#
# == Manifest: Project: Security Groups: management
#
# This is the general management security group. All VMs need to have this
# attached to them.
#
# It provides general access for management systems (e.g. puppet, icinga)
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_management_id

resource "aws_security_group" "management" {
  name        = "${var.stackname}_management_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Group used to allow access by management systems"

  tags {
    Name = "${var.stackname}_management_access"
  }
}

resource "aws_security_group_rule" "allow_ssh_from_jumpbox" {
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.management.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.jumpbox.id}"
}

resource "aws_security_group_rule" "allow_nrpe_ingress_from_monitoring" {
  type      = "ingress"
  from_port = 5666
  to_port   = 5666
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.management.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.monitoring.id}"
}

resource "aws_security_group_rule" "allow_icmp_ingress_from_monitoring" {
  type      = "ingress"
  from_port = 8
  to_port   = 0
  protocol  = "icmp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.management.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.monitoring.id}"
}

resource "aws_security_group_rule" "allow_mangement_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.management.id}"
}
