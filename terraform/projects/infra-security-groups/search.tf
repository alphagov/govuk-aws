#
# == Manifest: Project: Security Groups: search
#
# The search needs to be accessible on ports:
#   - 443 from the other VMs
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_search_id
# sg_search_elb_id

resource "aws_security_group" "search" {
  name        = "${var.stackname}_search_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the search host from its ELB"

  tags {
    Name = "${var.stackname}_search_access"
  }
}

resource "aws_security_group_rule" "search_ingress_search-elb_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.search.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.search_elb.id}"
}

resource "aws_security_group" "search_elb" {
  name        = "${var.stackname}_search_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the search ELB"

  tags {
    Name = "${var.stackname}_search_elb_access"
  }
}

resource "aws_security_group_rule" "search-api_ingress_elb_external_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.search.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.search-api_external_elb.id}"
}

# TODO: Audit
resource "aws_security_group_rule" "search-elb_ingress_management_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.search_elb.id}"
  source_security_group_id = "${aws_security_group.management.id}"
}

resource "aws_security_group_rule" "search-elb_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.search_elb.id}"
}

resource "aws_security_group" "search_ithc_access" {
  count       = "${length(var.ithc_access_ips) > 0 ? 1 : 0}"
  name        = "${var.stackname}_search_ithc_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Control access to ITHC SSH"

  tags {
    Name = "${var.stackname}_search_ithc_access"
  }
}

resource "aws_security_group_rule" "ithc_ingress_search_ssh" {
  count             = "${length(var.ithc_access_ips) > 0 ? 1 : 0}"
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  cidr_blocks       = "${var.ithc_access_ips}"
  security_group_id = "${aws_security_group.search_ithc_access.id}"
}
