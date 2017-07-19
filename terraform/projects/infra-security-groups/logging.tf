#
# == Manifest: Project: Security Groups: logging
#
# The logging needs to be accessible on ports:
#   - 514 from the other VMs
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_logging_id
# sg_logging_elb_id

resource "aws_security_group" "logging" {
  name        = "${var.stackname}_logging_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the logging host from its ELB"

  tags {
    Name = "${var.stackname}_logging_access"
  }
}

# All VMs will need to talk to the logging.
resource "aws_security_group_rule" "allow_logging_elb_in" {
  type      = "ingress"
  from_port = 514
  to_port   = 514
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.logging.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.logging_elb.id}"
}

# TODO: add rule for kibana from backends once those are created.

resource "aws_security_group" "logging_elb" {
  name        = "${var.stackname}_logging_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the logging ELB"

  tags {
    Name = "${var.stackname}_logging_elb_access"
  }
}

resource "aws_security_group_rule" "allow_management_to_logging" {
  type      = "ingress"
  from_port = 514
  to_port   = 514
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.logging_elb.id}"
  source_security_group_id = "${aws_security_group.management.id}"
}

# TODO test whether egress rules are needed on ELBs
resource "aws_security_group_rule" "allow_logging_elb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.logging_elb.id}"
}
