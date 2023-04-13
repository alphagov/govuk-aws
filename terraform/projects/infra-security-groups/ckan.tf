#
# == Manifest: Project: Security Groups: ckan
#
# CKAN needs to be accessible on ports:
#   - 80 from its ELB
#   - 22 from db-admin
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_ckan_id
# sg_ckan_elb_internal_id
# sg_ckan_elb_external_id

resource "aws_security_group" "ckan" {
  name        = "${var.stackname}_ckan_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.outputs.vpc_id}"
  description = "Access to the ckan host from its ELB"

  tags = {
    Name = "${var.stackname}_ckan_access"
  }
}

resource "aws_security_group_rule" "ckan_ingress_ckan-elb-internal_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.ckan.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.ckan_elb_internal.id}"
}

resource "aws_security_group_rule" "ckan_ingress_ckan-elb-external_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.ckan.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.ckan_elb_external.id}"
}

resource "aws_security_group" "ckan_elb_internal" {
  name        = "${var.stackname}_ckan_elb_internal_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.outputs.vpc_id}"
  description = "Access the ckan ELB"

  tags = {
    Name = "${var.stackname}_ckan_elb_internal_access"
  }
}

# TODO: Audit
resource "aws_security_group_rule" "ckan-elb-internal_ingress_management_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.ckan_elb_internal.id}"
  source_security_group_id = "${aws_security_group.management.id}"
}

resource "aws_security_group" "ckan_elb_external" {
  name        = "${var.stackname}_ckan_elb_external_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.outputs.vpc_id}"
  description = "Access the ckan ELB"

  tags = {
    Name = "${var.stackname}_ckan_elb_external_access"
  }
}

# Allow public access to access ckan services
resource "aws_security_group_rule" "ckan-elb-external_ingress_public_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id = "${aws_security_group.ckan_elb_external.id}"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ckan-elb-internal_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.ckan_elb_internal.id}"
}

resource "aws_security_group_rule" "ckan-elb-external_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.ckan_elb_external.id}"
}

# Allow SSH access from db-admin for data sync
resource "aws_security_group_rule" "ckan_ingress_db-admin_ssh" {
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.ckan.id}"
  source_security_group_id = "${aws_security_group.db-admin.id}"
}

resource "aws_security_group" "ckan_ithc_access" {
  count       = "${length(var.ithc_access_ips) > 0 ? 1 : 0}"
  name        = "${var.stackname}_ckan_ithc_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.outputs.vpc_id}"
  description = "Control access to ITHC SSH"

  tags = {
    Name = "${var.stackname}_ckan_ithc_access"
  }
}

resource "aws_security_group_rule" "ithc_ingress_ckan_ssh" {
  count             = "${length(var.ithc_access_ips) > 0 ? 1 : 0}"
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  cidr_blocks       = "${var.ithc_access_ips}"
  security_group_id = "${aws_security_group.ckan_ithc_access[0].id}"
}
