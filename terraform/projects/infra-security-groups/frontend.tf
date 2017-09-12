#
# == Manifest: Project: Security Groups: frontend
#
# The frontend needs to be accessible on ports:
#   - 443 from the other VMs
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_frontend_id
# sg_frontend_elb_id

resource "aws_security_group" "frontend" {
  name        = "${var.stackname}_frontend_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the frontend host from its ELB"

  tags {
    Name = "${var.stackname}_frontend_access"
  }
}

resource "aws_security_group_rule" "allow_frontend_elb_in" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.frontend.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.frontend_elb.id}"
}

resource "aws_security_group" "frontend_elb" {
  name        = "${var.stackname}_frontend_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the frontend ELB"

  tags {
    Name = "${var.stackname}_frontend_elb_access"
  }
}

# Allow apps on frontend speak to themselves via the ELB
resource "aws_security_group_rule" "allow_frontend_to_frontend_elb_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.frontend_elb.id}"
  source_security_group_id = "${aws_security_group.frontend.id}"
}

# TODO test whether egress rules are needed on ELBs
resource "aws_security_group_rule" "allow_frontend_elb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.frontend_elb.id}"
}
