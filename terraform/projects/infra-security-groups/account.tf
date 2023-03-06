#
# == Manifest: Project: Security Groups: account
#
# app-account needs to be accessible on ports:
#   - 443 from the other VMs
#
# === Variables:
# stackname - string
#
# === Outputs:
#
# sg_account_id
# sg_account_elb_internal_id
# sg_account_elb_external_id
#
resource "aws_security_group" "account" {
  name        = "${var.stackname}_account_access"
  vpc_id      = "${data.terraform_remote_state.outputs.infra_vpc.vpc_id}"
  description = "Access to the account host from its ELB"

  tags = {
    Name = "${var.stackname}_account_access"
  }
}

resource "aws_security_group_rule" "account_ingress_account-elb-internal_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.account.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.account_elb_internal.id}"
}

resource "aws_security_group_rule" "account_ingress_account-elb-external_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.account.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.account_elb_external.id}"
}

resource "aws_security_group" "account_elb_internal" {
  name        = "${var.stackname}_account_elb_internal_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.outputs.vpc_id}"
  description = "Access the account ELB"

  tags = {
    Name = "${var.stackname}_account_elb_access"
  }
}

# TODO: Audit
resource "aws_security_group_rule" "account-elb-internal_ingress_management_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.account_elb_internal.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.management.id}"
}

resource "aws_security_group_rule" "account-elb-internal_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.account_elb_internal.id}"
}

resource "aws_security_group" "account_elb_external" {
  name        = "${var.stackname}_account_elb_external_access"
  vpc_id      = "${data.terraform_remote_state.outputs.infra_vpc.vpc_id}"
  description = "Access the account ELB"

  tags = {
    Name = "${var.stackname}_account_elb_access"
  }
}

resource "aws_security_group_rule" "account-elb-external_ingress_any_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.account_elb_external.id}"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "account-elb-external_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.account_elb_external.id}"
}

resource "aws_security_group" "account_ithc_access" {
  count       = "${length(var.ithc_access_ips) > 0 ? 1 : 0}"
  name        = "${var.stackname}_account_ithc_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.outputs.vpc_id}"
  description = "Control access to ITHC SSH"

  tags = {
    Name = "${var.stackname}_account_ithc_access"
  }
}

resource "aws_security_group_rule" "ithc_ingress_account_ssh" {
  count             = "${length(var.ithc_access_ips) > 0 ? 1 : 0}"
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  cidr_blocks       = "${var.ithc_access_ips}"
  security_group_id = "${aws_security_group.account_ithc_access.id}"
}
