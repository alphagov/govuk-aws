#
# == Manifest: Project: Security Groups: publishing-api
#
# The publishing-api needs to be accessible on ports:
#   - 443 from the other VMs
#
# === Variables:
# stackname - string
#
# === Outputs:
#
# sg_publishing-api_internal_id
# sg_publishing-api_elb_internal_id
# sg_publishing-api_external_id
# sg_publishing-api_elb_external_id
#
resource "aws_security_group" "publishing-api" {
  name        = "${var.stackname}_publishing-api_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the publishing-api host from its ELB"

  tags {
    Name = "${var.stackname}_publishing-api_access"
  }
}

resource "aws_security_group_rule" "publishing-api_ingress_publishing-api-elb-internal_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.publishing-api.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.publishing-api_elb_internal.id}"
}

resource "aws_security_group_rule" "publishing-api_ingress_publishing-api-elb-external_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.publishing-api.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.publishing-api_elb_external.id}"
}

resource "aws_security_group" "publishing-api_elb_internal" {
  name        = "${var.stackname}_publishing-api_elb_internal_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the publishing-api ELB"

  tags {
    Name = "${var.stackname}_publishing-api_elb_access"
  }
}

# TODO: Audit
resource "aws_security_group_rule" "publishing-api-elb-internal_ingress_management_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.publishing-api_elb_internal.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.management.id}"
}

resource "aws_security_group_rule" "publishing-api-elb-internal_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.publishing-api_elb_internal.id}"
}

resource "aws_security_group" "publishing-api_elb_external" {
  name        = "${var.stackname}_publishing-api_elb_external_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the publishing-api ELB"

  tags {
    Name = "${var.stackname}_publishing-api_elb_access"
  }
}

resource "aws_security_group_rule" "publishing-api-elb-external_ingress_office_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.publishing-api_elb_external.id}"
  cidr_blocks       = ["${var.office_ips}"]
}

resource "aws_security_group_rule" "publishing-api-elb-external_ingress_carrenza_https" {
  description = "Access from apps in Carrenza (6DG) to Pub API. Remove once everything is in AWS."
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.publishing-api_elb_external.id}"
  cidr_blocks       = ["${var.carrenza_env_ips}"]
}

resource "aws_security_group_rule" "publishing-api-elb-external_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.publishing-api_elb_external.id}"
}

resource "aws_security_group" "publishing-api_ithc_access" {
  count       = "${length(var.ithc_access_ips) > 0 ? 1 : 0}"
  name        = "${var.stackname}_publishing-api_ithc_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Control access to ITHC SSH"

  tags {
    Name = "${var.stackname}_publishing-api_ithc_access"
  }
}

resource "aws_security_group_rule" "ithc_ingress_publishing-api_ssh" {
  count             = "${length(var.ithc_access_ips) > 0 ? 1 : 0}"
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  cidr_blocks       = "${var.ithc_access_ips}"
  security_group_id = "${aws_security_group.publishing-api_ithc_access.id}"
}
