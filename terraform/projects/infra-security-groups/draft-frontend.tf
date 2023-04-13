#
# == Manifest: Project: Security Groups: draft-frontend
#
# The puppetmaster needs to be accessible on ports:
#   - 443 from the other VMs
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_draft-frontend_id
# sg_draft-frontend_elb_id

resource "aws_security_group" "draft-frontend" {
  name        = "${var.stackname}_draft-frontend_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.outputs.vpc_id}"
  description = "Access to the draft-frontend host from its ELB"

  tags = {
    Name = "${var.stackname}_draft-frontend_access"
  }
}

resource "aws_security_group_rule" "draft-frontend-elb_ingress_draft-frontend-elb_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.draft-frontend.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.draft-frontend_elb.id}"
}

resource "aws_security_group" "draft-frontend_elb" {
  name        = "${var.stackname}_draft-frontend_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.outputs.vpc_id}"
  description = "Access the draft-frontend ELB"

  tags = {
    Name = "${var.stackname}_draft-frontend_elb_access"
  }
}

# TODO: Audit
resource "aws_security_group_rule" "draft-frontend-elb_ingress_management_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.draft-frontend_elb.id}"
  source_security_group_id = "${aws_security_group.management.id}"
}

resource "aws_security_group_rule" "draft-frontend-elb_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.draft-frontend_elb.id}"
}

resource "aws_security_group" "draft-frontend_ithc_access" {
  count       = "${length(var.ithc_access_ips) > 0 ? 1 : 0}"
  name        = "${var.stackname}_draft-frontend_ithc_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.outputs.vpc_id}"
  description = "Control access to ITHC SSH"

  tags = {
    Name = "${var.stackname}_draft-frontend_ithc_access"
  }
}

resource "aws_security_group_rule" "ithc_ingress_draft-frontend_ssh" {
  count             = "${length(var.ithc_access_ips) > 0 ? 1 : 0}"
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  cidr_blocks       = "${var.ithc_access_ips}"
  security_group_id = "${aws_security_group.draft-frontend_ithc_access[0].id}"
}
