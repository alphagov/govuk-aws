#
# == Manifest: Project: Security Groups: search-api
#
# Search API needs to be accessible on ports:
#   - 443 from the other VMs
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_search-api_elb_id

resource "aws_security_group" "search-api_external_elb" {
  name        = "${var.stackname}_search-api_external_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the search-api external ELB"

  tags {
    Name = "${var.stackname}_search-api_external_elb_access"
  }
}

resource "aws_security_group_rule" "search-api_ingress_carrenza_external-elb_https" {
  count     = "${length(var.carrenza_env_ips) > 0 ? 1 : 0}"
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id = "${aws_security_group.search-api_external_elb.id}"
  cidr_blocks       = ["${var.carrenza_env_ips}"]
}

resource "aws_security_group_rule" "search-api_ingress_concourse_external-elb_https" {
  count     = "${length(var.concourse_ips) > 0 ? 1 : 0}"
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id = "${aws_security_group.search-api_external_elb.id}"
  cidr_blocks       = ["${var.concourse_ips}"]
}

resource "aws_security_group_rule" "search-api_egress_external_elb_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.search-api_external_elb.id}"
}

resource "aws_security_group" "search-api_ithc_access" {
  count       = "${length(var.ithc_access_ips) > 0 ? 1 : 0}"
  name        = "${var.stackname}_search-api_ithc_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Control access to ITHC SSH"

  tags {
    Name = "${var.stackname}_search-api_ithc_access"
  }
}

resource "aws_security_group_rule" "ithc_ingress_search-api_ssh" {
  count             = "${length(var.ithc_access_ips) > 0 ? 1 : 0}"
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  cidr_blocks       = "${var.ithc_access_ips}"
  security_group_id = "${aws_security_group.search-api_ithc_access.id}"
}
