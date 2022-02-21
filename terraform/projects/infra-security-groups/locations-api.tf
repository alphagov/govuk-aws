#
# == Manifest: Project: Security Groups: locations-api
#
# The locations-api needs to be accessible on ports:
#   - 443 from the other VMs
#
# === Variables:
# stackname - string
#
# === Outputs:
#
# sg_locations-api_internal_id
# sg_locations-api_elb_internal_id
# sg_locations-api_external_id
# sg_locations-api_elb_external_id
#
resource "aws_security_group" "locations-api" {
  name        = "${var.stackname}_locations-api_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the locations-api host from its ELB"

  tags {
    Name = "${var.stackname}_locations-api_access"
  }
}

resource "aws_security_group_rule" "locations-api_ingress_locations-api-elb-internal_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.locations-api.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.locations-api_elb_internal.id}"
}

resource "aws_security_group" "locations-api_elb_internal" {
  name        = "${var.stackname}_locations-api_elb_internal_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the locations-api ELB"

  tags {
    Name = "${var.stackname}_locations-api_elb_access"
  }
}

# TODO: Audit
resource "aws_security_group_rule" "locations-api-elb-internal_ingress_management_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.locations-api_elb_internal.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.management.id}"
}

resource "aws_security_group_rule" "locations-api-elb-internal_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.locations-api_elb_internal.id}"
}

resource "aws_security_group" "locations-api_ithc_access" {
  count       = "${length(var.ithc_access_ips) > 0 ? 1 : 0}"
  name        = "${var.stackname}_locations-api_ithc_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Control access to ITHC SSH"

  tags {
    Name = "${var.stackname}_locations-api_ithc_access"
  }
}

resource "aws_security_group_rule" "ithc_ingress_locations-api_ssh" {
  count             = "${length(var.ithc_access_ips) > 0 ? 1 : 0}"
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  cidr_blocks       = "${var.ithc_access_ips}"
  security_group_id = "${aws_security_group.locations-api_ithc_access.id}"
}
