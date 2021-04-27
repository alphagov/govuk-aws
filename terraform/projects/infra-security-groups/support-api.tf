#
# == Manifest: Project: Security Groups: support-api
#
# The puppetmaster needs to be accessible on ports:
#   - 443 from the other VMs
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_support-api_elb_id

resource "aws_security_group" "support-api_external_elb" {
  name        = "${var.stackname}_support-api_external_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the support-api external ELB"

  tags {
    Name = "${var.stackname}_support-api_external_elb_access"
  }
}

resource "aws_security_group_rule" "support-api_ingress_external-elb_https" {
  count     = "${length(var.carrenza_env_ips) > 0 ? 1 : 0}"
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id = "${aws_security_group.support-api_external_elb.id}"
  cidr_blocks       = ["${var.carrenza_env_ips}"]
}

resource "aws_security_group_rule" "support-api_egress_external_elb_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.support-api_external_elb.id}"
}

resource "aws_security_group_rule" "ithc_ingress_support-api_https" {
  count             = "${length(var.ithc_access_ips) > 0 ? 1 : 0}"
  type              = "ingress"
  to_port           = 443
  from_port         = 443
  protocol          = "tcp"
  cidr_blocks       = "${var.ithc_access_ips}"
  security_group_id = "${aws_security_group.support-api_external_elb.id}"
}
