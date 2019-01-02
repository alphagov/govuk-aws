#
# == Manifest: Project: Security Groups: feedback
#
# The feedback lb needs to be accessible on ports:
#   - 443 from the other VMs
#
# === Variables:
# stackname - string
# carrenza_env_ips - list
#
# === Outputs:
# sg_feedback_elb_id

resource "aws_security_group_rule" "frontend_ingress_feedback-elb_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.frontend.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.feedback_elb.id}"
}

resource "aws_security_group" "feedback_elb" {
  name        = "${var.stackname}_feedback_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the feedback ELB"

  tags {
    Name = "${var.stackname}_feedback_elb_access"
  }
}

# Allow support (in carrenza) to communicate with feedback (in aws) during migration
resource "aws_security_group_rule" "feedback-elb_ingress_carrenza_env_ips_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id = "${aws_security_group.feedback_elb.id}"
  cidr_blocks       = "${var.carrenza_env_ips}"
}

resource "aws_security_group_rule" "feedback-elb_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.feedback_elb.id}"
}
