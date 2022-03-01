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
# sg_locations-api_id
# sg_locations-api_elb_id

resource "aws_security_group" "locations-api" {
  name        = "${var.stackname}_locations-api_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the locations-api host from its public ELB and internal LB"

  tags {
    Name = "${var.stackname}_locations-api_access"
  }
}

resource "aws_security_group_rule" "locations-api_ingress_locations-api-elb_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.locations-api.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.locations-api_external_elb.id}"
}

resource "aws_security_group_rule" "locations-api_ingress_locations-api-internal-lb_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.locations-api.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.locations-api_internal_lb.id}"
}

resource "aws_security_group" "locations-api_external_elb" {
  name        = "${var.stackname}_locations-api_external_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the public locations-api ELB"

  tags {
    Name = "${var.stackname}_locations-api_elb_access"
  }
}

resource "aws_security_group_rule" "locations-api-elb_ingress_office_https" {
  count     = "${(var.aws_environment == "integration") || (var.aws_environment == "staging") ? 1 : 0}"
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id = "${aws_security_group.locations-api_external_elb.id}"
  cidr_blocks       = ["${var.office_ips}"]
}

resource "aws_security_group_rule" "locations-api-elb_ingress_public_https" {
  count     = "${var.aws_environment == "production"? 1 : 0}"
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id = "${aws_security_group.locations-api_external_elb.id}"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "locations-api-elb_ingress_office_http" {
  count     = "${(var.aws_environment == "integration") || (var.aws_environment == "staging") ? 1 : 0}"
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  security_group_id = "${aws_security_group.locations-api_external_elb.id}"
  cidr_blocks       = ["${var.office_ips}"]
}

resource "aws_security_group_rule" "locations-api-elb_ingress_public_http" {
  count     = "${var.aws_environment == "production"? 1 : 0}"
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  security_group_id = "${aws_security_group.locations-api_external_elb.id}"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "locations-api-elb_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.locations-api_external_elb.id}"
}

# Internal Loadbalancer
resource "aws_security_group" "locations-api_internal_lb" {
  name        = "${var.stackname}_locations-api_lb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the locations-api LB"

  tags {
    Name = "${var.stackname}_locations-api_internal_lb_access"
  }
}

resource "aws_security_group_rule" "locations-api-internal-lb_ingress_management_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.locations-api_internal_lb.id}"
  source_security_group_id = "${aws_security_group.management.id}"
}

resource "aws_security_group_rule" "locations-api-internal-lb_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.locations-api_internal_lb.id}"
}

resource "aws_security_group_rule" "locations-api-elb_ingress_ithc_https" {
  count     = "${length(var.ithc_access_ips) > 0 ? 1 : 0}"
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id = "${aws_security_group.locations-api_external_elb.id}"
  cidr_blocks       = ["${var.ithc_access_ips}"]
}

resource "aws_security_group" "locations_api_ithc_access" {
  count       = "${length(var.ithc_access_ips) > 0 ? 1 : 0}"
  name        = "${var.stackname}_locations_api_ithc_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Control access to ITHC SSH"

  tags {
    Name = "${var.stackname}_locations_api_ithc_access"
  }
}

resource "aws_security_group_rule" "ithc_ingress_locations_api_ssh" {
  count             = "${length(var.ithc_access_ips) > 0 ? 1 : 0}"
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  cidr_blocks       = "${var.ithc_access_ips}"
  security_group_id = "${aws_security_group.locations_api_ithc_access.id}"
}
