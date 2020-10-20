#
# == Manifest: Project: Security Groups: email-alert-api
#
# The email-alert-api needs to be accessible on ports:
#   - 443 from the other VMs
#
# === Variables:
# stackname - string
#
# === Outputs:
#
# sg_email-alert-api_internal_id
# sg_email-alert-api_elb_internal_id
# sg_email-alert-api_external_id
# sg_email-alert-api_elb_external_id
#
resource "aws_security_group" "email-alert-api" {
  name        = "${var.stackname}_email-alert-api_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the email-alert-api host from its ELB"

  tags {
    Name = "${var.stackname}_email-alert-api_access"
  }
}

resource "aws_security_group_rule" "email-alert-api_ingress_email-alert-api-elb-internal_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.email-alert-api.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.email-alert-api_elb_internal.id}"
}

resource "aws_security_group_rule" "email-alert-api_ingress_email-alert-api-elb-external_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.email-alert-api.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.email-alert-api_elb_external.id}"
}

resource "aws_security_group" "email-alert-api_elb_internal" {
  name        = "${var.stackname}_email-alert-api_elb_internal_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the email-alert-api ELB"

  tags {
    Name = "${var.stackname}_email-alert-api_elb_access"
  }
}

# TODO: Audit
resource "aws_security_group_rule" "email-alert-api-elb-internal_ingress_management_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.email-alert-api_elb_internal.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.management.id}"
}

resource "aws_security_group_rule" "email-alert-api-elb-internal_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.email-alert-api_elb_internal.id}"
}

resource "aws_security_group" "email-alert-api_elb_external" {
  name        = "${var.stackname}_email-alert-api_elb_external_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the email-alert-api ELB"

  tags {
    Name = "${var.stackname}_email-alert-api_elb_access"
  }
}

resource "aws_security_group_rule" "email-alert-api-elb-external_ingress_any_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.email-alert-api_elb_external.id}"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "email-alert-api-elb-external_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.email-alert-api_elb_external.id}"
}

resource "aws_security_group" "email-alert-api_paas_access" {
  count       = "${length(var.paas_egress_ips) > 0 ? 1 : 0}"
  name        = "${var.stackname}_email-alert-api_paas_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Control access from the GOV.UK PaaS"

  tags {
    Name = "${var.stackname}_email-alert-api_paas_access"
  }
}

resource "aws_security_group_rule" "paas_ingress_email-alert-api_ssh" {
  count             = "${length(var.paas_egress_ips) > 0 ? 1 : 0}"
  type              = "ingress"
  to_port           = 443
  from_port         = 443
  protocol          = "tcp"
  cidr_blocks       = "${var.paas_egress_ips}"
  security_group_id = "${aws_security_group.email-alert-api_paas_access.id}"
}

resource "aws_security_group" "email-alert-api_ithc_access" {
  count       = "${length(var.ithc_access_ips) > 0 ? 1 : 0}"
  name        = "${var.stackname}_email-alert-api_ithc_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Control access to ITHC SSH"

  tags {
    Name = "${var.stackname}_email-alert-api_ithc_access"
  }
}

resource "aws_security_group_rule" "ithc_ingress_email-alert-api_ssh" {
  count             = "${length(var.ithc_access_ips) > 0 ? 1 : 0}"
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  cidr_blocks       = "${var.ithc_access_ips}"
  security_group_id = "${aws_security_group.email-alert-api_ithc_access.id}"
}
