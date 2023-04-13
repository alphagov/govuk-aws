#
# == Manifest: Project: Security Groups: whitehall-backend
#
# The whitehall-backend needs to be accessible on ports:
#   - 443 from the other VMs
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_whitehall-backend_id
# sg_whitehall-backend_elb_id

resource "aws_security_group" "whitehall-backend" {
  name        = "${var.stackname}_whitehall-backend_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.outputs.vpc_id}"
  description = "Access to the whitehall-backend host from its ELB"

  tags = {
    Name = "${var.stackname}_whitehall-backend_access"
  }
}

resource "aws_security_group_rule" "whitehall-backend_ingress_whitehall-backend-internal-elb_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.whitehall-backend.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.whitehall-backend_internal_elb.id}"
}

resource "aws_security_group_rule" "whitehall-backend_ingress_whitehall-backend-external-elb_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.whitehall-backend.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.whitehall-backend_external_elb.id}"
}

resource "aws_security_group" "whitehall-backend_internal_elb" {
  name        = "${var.stackname}_whitehall-backend_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.outputs.vpc_id}"
  description = "Access the whitehall-backend ELB"

  tags = {
    Name = "${var.stackname}_whitehall-backend_internal_elb_access"
  }
}

# TODO: Audit
resource "aws_security_group_rule" "whitehall-backend-internal-elb_ingress_management_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.whitehall-backend_internal_elb.id}"
  source_security_group_id = "${aws_security_group.management.id}"
}

resource "aws_security_group_rule" "whitehall-backend-internal-elb_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.whitehall-backend_internal_elb.id}"
}

resource "aws_security_group" "whitehall-backend_external_elb" {
  name        = "${var.stackname}_whitehall-backend_external_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.outputs.vpc_id}"
  description = "Access the whitehall-backend external ELB"

  tags = {
    Name = "${var.stackname}_whitehall-backend_external_elb_access"
  }
}

resource "aws_security_group_rule" "whitehall-backend-external-elb_ingress_public_https" {
  type              = "ingress"
  to_port           = 443
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.whitehall-backend_external_elb.id}"
  cidr_blocks       = flatten(["0.0.0.0/0", "${var.office_ips}"])
}

resource "aws_security_group_rule" "whitehall-backend-external-elb_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.whitehall-backend_external_elb.id}"
}

resource "aws_security_group" "whitehall_ithc_access" {
  count       = "${length(var.ithc_access_ips) > 0 ? 1 : 0}"
  name        = "${var.stackname}_whitehall_ithc_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.outputs.vpc_id}"
  description = "Control access to ITHC SSH"

  tags = {
    Name = "${var.stackname}_whitehall_ithc_access"
  }
}

resource "aws_security_group_rule" "ithc_ingress_whitehall_ssh" {
  count             = "${length(var.ithc_access_ips) > 0 ? 1 : 0}"
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  cidr_blocks       = "${var.ithc_access_ips}"
  security_group_id = "${aws_security_group.whitehall_ithc_access.id}"
}
