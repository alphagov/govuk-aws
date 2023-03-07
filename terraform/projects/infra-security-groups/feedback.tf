#
# == Manifest: Project: Security Groups: feedback
#
# The feedback lb needs to be accessible on ports:
#   - 443 from the other VMs
#
# === Variables:
# stackname - string
# carrenza_vpn_subnet_cidr - list
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
  vpc_id      = "${data.terraform_remote_state.infra_vpc.outputs.vpc_id}"
  description = "Access the feedback ELB"

  tags = {
    Name = "${var.stackname}_feedback_elb_access"
  }
}

# Allow support (in carrenza) to communicate with feedback (in aws) during migration
resource "aws_security_group_rule" "feedback-elb_ingress_carrenza_env_ips_https" {
  count             = "${length(var.carrenza_vpn_subnet_cidr) > 0 ? 1 : 0}"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.feedback_elb.id}"
  cidr_blocks       = var.carrenza_vpn_subnet_cidr
}

resource "aws_security_group_rule" "feedback-elb_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.feedback_elb.id}"
}

resource "aws_security_group" "feedback_ithc_access" {
  count       = "${length(var.ithc_access_ips) > 0 ? 1 : 0}"
  name        = "${var.stackname}_feedback_ithc_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.outputs.vpc_id}"
  description = "Control access to ITHC SSH"

  tags = {
    Name = "${var.stackname}_feedback_ithc_access"
  }
}

resource "aws_security_group_rule" "ithc_ingress_feedback_ssh" {
  count             = "${length(var.ithc_access_ips) > 0 ? 1 : 0}"
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  cidr_blocks       = "${var.ithc_access_ips}"
  security_group_id = "${aws_security_group.feedback_ithc_access[0].id}"
}
