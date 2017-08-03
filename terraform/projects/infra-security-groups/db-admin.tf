#
# == Manifest: Project: Security Groups: db-admin
#
# The db-admin needs to be accessible on ports:
#   - 22 from the other VMs
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_db-admin_id
# sg_db-admin_elb_id

resource "aws_security_group" "db-admin" {
  name        = "${var.stackname}_db-admin_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the db-admin host from its ELB"

  tags {
    Name = "${var.stackname}_db-admin_access"
  }
}

resource "aws_security_group_rule" "allow_db-admin_elb_in" {
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.db-admin.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.db-admin_elb.id}"
}

resource "aws_security_group" "db-admin_elb" {
  name        = "${var.stackname}_db-admin_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the db-admin ELB"

  tags {
    Name = "${var.stackname}_db-admin_elb_access"
  }
}

resource "aws_security_group_rule" "allow_management_to_db-admin_elb" {
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.db-admin_elb.id}"
  source_security_group_id = "${aws_security_group.management.id}"
}

# TODO test whether egress rules are needed on ELBs
resource "aws_security_group_rule" "allow_db-admin_elb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.db-admin_elb.id}"
}
