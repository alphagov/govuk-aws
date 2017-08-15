#
# == Manifest: Project: Security Groups: exception_handler
#
# The exception_handler needs to be accessible on ports:
#   - 443/tcp internally & externally (to/from external ELBs)
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_exception_handler_id
# sg_exception_handler_elb_id

resource "aws_security_group" "exception_handler" {
  name        = "${var.stackname}_exception_handler_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the exception_handler host from its ELB"

  tags {
    Name = "${var.stackname}_exception_handler_access"
  }
}

resource "aws_security_group_rule" "allow_exception_handler_internal_elb_in" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.exception_handler.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.exception_handler_internal_elb.id}"
}

resource "aws_security_group" "exception_handler_internal_elb" {
  name        = "${var.stackname}_exception_handler_internal_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the exception_handler Internal ELB"

  tags {
    Name = "${var.stackname}_exception_handler_internal_elb_access"
  }
}

resource "aws_security_group_rule" "allow_management_to_exception_handler_elb" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.exception_handler_internal_elb.id}"
  source_security_group_id = "${aws_security_group.management.id}"
}

resource "aws_security_group_rule" "allow_backend-lb_https_to_exception_handler_elb" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.exception_handler_internal_elb.id}"
  source_security_group_id = "${aws_security_group.backend-lb.id}"
}

# TODO: test and remove
resource "aws_security_group_rule" "allow_exception_handler_internal_elb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.exception_handler_internal_elb.id}"
}
