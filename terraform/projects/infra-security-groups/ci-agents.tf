#
# == Manifest: Project: Security Groups: ci-agents
#
# The ci-agents needs to be accessible on ports:
#   - 443 from the other VMs
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_ci-agent-1_id
# sg_ci-agent-1_elb_id

resource "aws_security_group" "ci-agent-1" {
  name        = "${var.stackname}_ci-agent-1_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the ci-agent-1 host from its ELB"

  tags {
    Name = "${var.stackname}_ci-agent-1_access"
  }
}

resource "aws_security_group_rule" "ci-agent-1_ingress_ci-agent-1-elb_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.ci-agent-1.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.ci-agent-1_elb.id}"
}

resource "aws_security_group" "ci-agent-1_elb" {
  name        = "${var.stackname}_ci-agent-1_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the CI agent 1 ELB"

  tags {
    Name = "${var.stackname}_ci-agent-1_elb_access"
  }
}

resource "aws_security_group_rule" "ci-agent-1-elb_ingress_management_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.ci-agent-1_elb.id}"
  source_security_group_id = "${aws_security_group.management.id}"
}

resource "aws_security_group_rule" "ci-agent-1-elb_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.ci-agent-1_elb.id}"
}
