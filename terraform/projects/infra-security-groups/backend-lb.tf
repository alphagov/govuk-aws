#
# == Manifest: Project: Security Groups: backend-lb
#
# The backend-lb needs to be accessible on ports:
#   - 443 from the other VMs
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_backend-lb_id
# sg_backend-lb_elb_id
# sg_backend-lb_external_elb_id

resource "aws_security_group" "backend-lb" {
  name        = "${var.stackname}_backend-lb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the backend-lb host from its ELB"

  tags {
    Name = "${var.stackname}_backend-lb_access"
  }
}

resource "aws_security_group_rule" "allow_backend-lb_elb_in" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.backend-lb.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.backend-lb_elb.id}"
}

resource "aws_security_group_rule" "allow_backend-lb_external_elb_in" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.backend-lb.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.backend-lb_external_elb.id}"
}

resource "aws_security_group" "backend-lb_elb" {
  name        = "${var.stackname}_backend-lb_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the backend-lb ELB"

  tags {
    Name = "${var.stackname}_backend-lb_elb_access"
  }
}

resource "aws_security_group" "backend-lb_external_elb" {
  name        = "${var.stackname}_backend-lb_external_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the external backend-lb ELB"

  tags {
    Name = "${var.stackname}_backend-lb_external_elb_access"
  }
}

resource "aws_security_group_rule" "allow_public_to_backend-lb_external_elb" {
  type              = "ingress"
  to_port           = 443
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.backend-lb_external_elb.id}"
  cidr_blocks       = ["0.0.0.0/0", "${var.office_ips}"]
}

# TODO test whether egress rules are needed on ELBs
resource "aws_security_group_rule" "allow_backend-lb_elb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.backend-lb_elb.id}"
}

# TODO test whether egress rules are needed on ELBs
resource "aws_security_group_rule" "allow_backend-lb_external_elb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.backend-lb_external_elb.id}"
}
