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
# sg_backend_elb_internal_id
# sg_backend_elb_external_id

resource "aws_security_group" "backend" {
  name        = "${var.stackname}_backend_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.outputs.vpc_id}"
  description = "Access to the backend host from its ELB"

  tags = {
    Name = "${var.stackname}_backend_access"
  }
}

resource "aws_security_group_rule" "backend_ingress_backend-elb-internal_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.backend.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.backend_elb_internal.id}"
}

resource "aws_security_group_rule" "backend_ingress_backend-elb-external_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.backend.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.backend_elb_external.id}"
}

resource "aws_security_group_rule" "support-api_ingress_elb_external_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.backend.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.support-api_external_elb.id}"
}

resource "aws_security_group_rule" "sidekiq-monitoring_ingress_elb_external_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.backend.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.sidekiq-monitoring_external_elb.id}"
}

resource "aws_security_group" "backend_elb_internal" {
  name        = "${var.stackname}_backend_elb_internal_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.outputs.vpc_id}"
  description = "Access the backend ELB"

  tags = {
    Name = "${var.stackname}_backend_elb_internal_access"
  }
}

# TODO: Audit
resource "aws_security_group_rule" "backend-elb-internal_ingress_management_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.backend_elb_internal.id}"
  source_security_group_id = "${aws_security_group.management.id}"
}

resource "aws_security_group" "backend_elb_external" {
  name        = "${var.stackname}_backend_elb_external_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.outputs.vpc_id}"
  description = "Access the backend ELB"

  tags = {
    Name = "${var.stackname}_backend_elb_external_access"
  }
}

# Allow public access to access backend services
resource "aws_security_group_rule" "backend-elb-external_ingress_public_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id = "${aws_security_group.backend_elb_external.id}"
  cidr_blocks       = flatten(["0.0.0.0/0", "${var.office_ips}"])
}

resource "aws_security_group_rule" "backend-elb-internal_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.backend_elb_internal.id}"
}

resource "aws_security_group_rule" "backend-elb-external_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.backend_elb_external.id}"
}

resource "aws_security_group" "backend_ithc_access" {
  count       = "${length(var.ithc_access_ips) > 0 ? 1 : 0}"
  name        = "${var.stackname}_backend_ithc_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.outputs.vpc_id}"
  description = "Control access to ITHC SSH"

  tags = {
    Name = "${var.stackname}_backend_ithc_access"
  }
}

resource "aws_security_group_rule" "ithc_ingress_backend_ssh" {
  count             = "${length(var.ithc_access_ips) > 0 ? 1 : 0}"
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  cidr_blocks       = "${var.ithc_access_ips}"
  security_group_id = "${aws_security_group.backend_ithc_access.id}"
}

resource "aws_security_group_rule" "ithc_ingress_backend_https" {
  count             = "${length(var.ithc_access_ips) > 0 ? 1 : 0}"
  type              = "ingress"
  to_port           = 443
  from_port         = 443
  protocol          = "tcp"
  cidr_blocks       = "${var.ithc_access_ips}"
  security_group_id = "${aws_security_group.backend_ithc_access.id}"
}
