#
# == Manifest: Project: Security Groups: backend
#
# The backend needs to be accessible on ports:
#   - 443 from the other VMs
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_backend_id
# sg_backend_elb_id

resource "aws_security_group" "backend" {
  name        = "${var.stackname}_backend_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the backend host from its ELB"

  tags {
    Name = "${var.stackname}_backend_access"
  }
}

resource "aws_security_group_rule" "allow_backend_elb_in" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.backend.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.backend_elb.id}"
}

resource "aws_security_group" "backend_elb" {
  name        = "${var.stackname}_backend_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the backend ELB"

  tags {
    Name = "${var.stackname}_backend_elb_access"
  }
}

resource "aws_security_group_rule" "allow_backend-lb_in_backend_elb" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.backend_elb.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.backend-lb.id}"
}

# TODO: replace this with ingress from the backend LBs when we build them.
resource "aws_security_group_rule" "allow_management_to_backend_elb" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.backend_elb.id}"
  source_security_group_id = "${aws_security_group.management.id}"
}

# TODO test whether egress rules are needed on ELBs
resource "aws_security_group_rule" "allow_backend_elb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.backend_elb.id}"
}

resource "aws_security_group" "backend_external_elb" {
  name        = "${var.stackname}_backend_external_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the external backend ELB"

  tags {
    Name = "${var.stackname}_backend_external_elb_access"
  }
}

resource "aws_security_group_rule" "allow_public_to_backend_external_elb" {
  type              = "ingress"
  to_port           = 443
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.backend_external_elb.id}"
  cidr_blocks       = ["0.0.0.0/0", "${var.office_ips}"]
}

# TODO test whether egress rules are needed on ELBs
resource "aws_security_group_rule" "allow_backend_external_elb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.backend_external_elb.id}"
}
