#
# == Manifest: Project: Security Groups: whitehall-frontend
#
# The whitehall-frontend needs to be accessible on ports:
#   - 443 from the other VMs
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_whitehall-frontend_id
# sg_whitehall-frontend_elb_id

resource "aws_security_group" "whitehall-frontend" {
  name        = "${var.stackname}_whitehall-frontend_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the whitehall-frontend host from its ELB"

  tags {
    Name = "${var.stackname}_whitehall-frontend_access"
  }
}

resource "aws_security_group_rule" "whitehall-frontend_ingress_whitehall-frontend-elb_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.whitehall-frontend.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.whitehall-frontend_elb.id}"
}

resource "aws_security_group_rule" "whitehall-frontend_ingress_whitehall-frontend-external-elb_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.whitehall-frontend.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.whitehall-frontend_external_elb.id}"
}

resource "aws_security_group" "whitehall-frontend_elb" {
  name        = "${var.stackname}_whitehall-frontend_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the whitehall-frontend ELB"

  tags {
    Name = "${var.stackname}_whitehall-frontend_elb_access"
  }
}

# TODO: Audit
resource "aws_security_group_rule" "whitehall-frontend-elb_ingress_management_443" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.whitehall-frontend_elb.id}"
  source_security_group_id = "${aws_security_group.management.id}"
}

resource "aws_security_group_rule" "whitehall-frontend-elb_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.whitehall-frontend_elb.id}"
}

# whitehall-frontend-external-elb exists only to serve Worldwide API to apps in
# Carrenza. (Traffic from end users to whitehall-frontend is proxied via the
# Router app to the internal-facing whitehall-frontend-internal-elb.)
resource "aws_security_group" "whitehall-frontend_external_elb" {
  name        = "${var.stackname}_whitehall-frontend_external_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the whitehall-frontend external ELB, for Worldwide API clients in Carrenza."

  tags {
    Name = "${var.stackname}_whitehall-frontend_external_elb_access"
  }
}

resource "aws_security_group_rule" "whitehall-frontend-external-elb_ingress_public_https" {
  type              = "ingress"
  to_port           = 443
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.whitehall-frontend_external_elb.id}"
  cidr_blocks       = ["${var.carrenza_env_ips}", "${var.office_ips}"]
}

resource "aws_security_group_rule" "whitehall-frontend-external-elb_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.whitehall-frontend_external_elb.id}"
}

resource "aws_security_group" "whitehall-frontend_ithc_access" {
  count       = "${length(var.ithc_access_ips) > 0 ? 1 : 0}"
  name        = "${var.stackname}_whitehall-frontend_ithc_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Control access to ITHC SSH"

  tags {
    Name = "${var.stackname}_whitehall-frontend_ithc_access"
  }
}

resource "aws_security_group_rule" "ithc_ingress_whitehall-frontend_ssh" {
  count             = "${length(var.ithc_access_ips) > 0 ? 1 : 0}"
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  cidr_blocks       = "${var.ithc_access_ips}"
  security_group_id = "${aws_security_group.whitehall-frontend_ithc_access.id}"
}
