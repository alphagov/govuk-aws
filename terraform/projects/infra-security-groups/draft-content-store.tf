#
# == Manifest: Project: Security Groups: draft-content-store
#
# The puppetmaster needs to be accessible on ports:
#   - 443 from the other VMs
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_draft-content-store_id
# sg_draft-content-store_elb_id

resource "aws_security_group" "draft-content-store" {
  name        = "${var.stackname}_draft-content-store_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the draft-content-store host from its ELB"

  tags {
    Name = "${var.stackname}_draft-content-store_access"
  }
}

resource "aws_security_group_rule" "draft-content-store_ingress_draft-content-store-internal-elb_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.draft-content-store.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.draft-content-store_internal_elb.id}"
}

resource "aws_security_group_rule" "draft-content-store_ingress_draft-content-store-external-elb_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.draft-content-store.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.draft-content-store_external_elb.id}"
}

resource "aws_security_group" "draft-content-store_internal_elb" {
  name        = "${var.stackname}_draft-content-store_internal_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the draft-content-store internal ELB"

  tags {
    Name = "${var.stackname}_draft-content-store_internal_elb_access"
  }
}

# TODO: Audit
resource "aws_security_group_rule" "draft-content-store-internal-elb_ingress_management_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.draft-content-store_internal_elb.id}"
  source_security_group_id = "${aws_security_group.management.id}"
}

# TODO test whether egress rules are needed on ELBs
resource "aws_security_group_rule" "draft-content-store-internal-elb_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.draft-content-store_internal_elb.id}"
}

resource "aws_security_group" "draft-content-store_external_elb" {
  name        = "${var.stackname}_draft-content-store_external_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the draft-content-store external ELB"

  tags {
    Name = "${var.stackname}_draft-content-store_external_elb_access"
  }
}

# TODO: Audit
resource "aws_security_group_rule" "draft-content-store-external-elb_ingress_office_https" {
  count     = "${length(var.carrenza_draft_frontend_ips) > 0 ? 1 : 0}"
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id = "${aws_security_group.draft-content-store_external_elb.id}"
  cidr_blocks       = ["${var.carrenza_draft_frontend_ips}"]
}

resource "aws_security_group_rule" "draft-content-store-external-elb_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.draft-content-store_external_elb.id}"
}
