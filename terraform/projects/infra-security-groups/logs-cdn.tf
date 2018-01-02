#
# == Manifest: Project: Security Groups: logs-cdn
#
# The logs-cdn needs to be accessible on ports:
#   - 6514-6515
#
# === Variables:
# stackname - string
# office_ips - array of CIDR blocks
#
# === Outputs:
# sg_logs-cdn_id
# sg_logs-cdn_elb_id

resource "aws_security_group" "logs-cdn" {
  name        = "${var.stackname}_logs-cdn_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the logs-cdn host from its ELB"

  tags {
    Name = "${var.stackname}_logs-cdn_access"
  }
}

resource "aws_security_group_rule" "logs-cdn_ingress_logs-cdn-elb_syslog-tls" {
  type      = "ingress"
  from_port = 6514
  to_port   = 6516
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.logs-cdn.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.logs-cdn_elb.id}"
}

resource "aws_security_group" "logs-cdn_elb" {
  name        = "${var.stackname}_logs-cdn_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the logs-cdn ELB"

  tags {
    Name = "${var.stackname}_logs-cdn_elb_access"
  }
}

resource "aws_security_group_rule" "logs-cdn-elb_ingress_fastly_syslog-tls" {
  type              = "ingress"
  to_port           = 6516
  from_port         = 6514
  protocol          = "tcp"
  security_group_id = "${aws_security_group.logs-cdn_elb.id}"
  cidr_blocks       = ["${data.fastly_ip_ranges.fastly.cidr_blocks}"]
}

resource "aws_security_group_rule" "logs-cdn-elb_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.logs-cdn_elb.id}"
}
