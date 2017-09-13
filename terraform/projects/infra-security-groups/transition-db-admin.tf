#
# == Manifest: Project: Security Groups: transition-transition-db-admin
#
# The transition-transition-db-admin needs to be accessible on ports:
#   - 22 from the other VMs
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_transition-db-admin_id
# sg_transition-db-admin_elb_id

resource "aws_security_group" "transition-db-admin" {
  name        = "${var.stackname}_transition-db-admin_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the transition-db-admin host from its ELB"

  tags {
    Name = "${var.stackname}_transition-db-admin_access"
  }
}

resource "aws_security_group_rule" "allow_transition-db-admin_elb_in" {
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.transition-db-admin.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.transition-db-admin_elb.id}"
}

resource "aws_security_group" "transition-db-admin_elb" {
  name        = "${var.stackname}_transition-db-admin_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the transition-db-admin ELB"

  tags {
    Name = "${var.stackname}_transition-db-admin_elb_access"
  }
}

resource "aws_security_group_rule" "allow_management_to_transition-db-admin_elb" {
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.transition-db-admin_elb.id}"
  source_security_group_id = "${aws_security_group.management.id}"
}

# TODO test whether egress rules are needed on ELBs
resource "aws_security_group_rule" "allow_transition-db-admin_elb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.transition-db-admin_elb.id}"
}
