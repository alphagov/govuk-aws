#
# == Manifest: Project: Security Groups: apt
#
# The apt needs to be accessible on ports:
#   - 80/tcp (Internal access)
#   - 443/tcp (External access)
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_apt_id
# sg_apt_external_elb_id
# sg_apt_internal_elb_id

resource "aws_security_group" "apt" {
  name        = "${var.stackname}_apt_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the apt host from its ELB"

  tags {
    Name = "${var.stackname}_apt_access"
  }
}

resource "aws_security_group_rule" "apt_ingress_apt-external-elb_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.apt.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.apt_external_elb.id}"
}

resource "aws_security_group_rule" "apt_ingress_apt-internal-elb_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.apt.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.apt_internal_elb.id}"
}

resource "aws_security_group" "apt_external_elb" {
  name        = "${var.stackname}_apt_external_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the apt External ELB"

  tags {
    Name = "${var.stackname}_apt_external_elb_access"
  }
}

resource "aws_security_group_rule" "apt-external-elb_ingress_office_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id = "${aws_security_group.apt_external_elb.id}"
  cidr_blocks       = ["${var.office_ips}"]
}

resource "aws_security_group_rule" "apt-external-elb_ingress_fastly_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id = "${aws_security_group.apt_external_elb.id}"
  cidr_blocks       = ["${data.fastly_ip_ranges.fastly.cidr_blocks}"]
}

resource "aws_security_group_rule" "apt-external-elb_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.apt_external_elb.id}"
}

resource "aws_security_group" "apt_internal_elb" {
  name        = "${var.stackname}_apt_internal_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the apt Internal ELB"

  tags {
    Name = "${var.stackname}_apt_internal_elb_access"
  }
}

resource "aws_security_group_rule" "apt-internal-elb_ingress_management_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.apt_internal_elb.id}"
  source_security_group_id = "${aws_security_group.management.id}"
}

resource "aws_security_group_rule" "apt-internal-elb_ingress_management_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.apt_internal_elb.id}"
  source_security_group_id = "${aws_security_group.management.id}"
}

resource "aws_security_group_rule" "apt-internal-elb_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.apt_internal_elb.id}"
}
