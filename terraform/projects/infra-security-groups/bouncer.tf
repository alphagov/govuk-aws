#
# == Manifest: Project: Security Groups: bouncer
#
# The bouncer needs to be accessible on ports:
#   - 443 from the other VMs
#
# === Variables:
# stackname - string
# office_ips - array of CIDR blocks
#
# === Outputs:
# sg_bouncer_id
# sg_bouncer_elb_id

resource "aws_security_group" "bouncer" {
  name        = "${var.stackname}_bouncer_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the bouncer host from its ELB"

  tags {
    Name = "${var.stackname}_bouncer_access"
  }
}

resource "aws_security_group_rule" "bouncer_ingress_bouncer-elb_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.bouncer.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.bouncer_elb.id}"
}

resource "aws_security_group_rule" "bouncer_ingress_bouncer-internal-elb_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.bouncer.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.bouncer_internal_elb.id}"
}

resource "aws_security_group" "bouncer_elb" {
  name        = "${var.stackname}_bouncer_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the bouncer ELB"

  tags {
    Name = "${var.stackname}_bouncer_elb_access"
  }
}

resource "aws_security_group_rule" "bouncer-elb_ingress_fastly_http" {
  type              = "ingress"
  to_port           = 80
  from_port         = 80
  protocol          = "tcp"
  security_group_id = "${aws_security_group.bouncer_elb.id}"
  cidr_blocks       = ["${data.fastly_ip_ranges.fastly.cidr_blocks}", "${var.office_ips}"]
}

resource "aws_security_group_rule" "bouncer-elb_ingress_traffic-replay_http" {
  type              = "ingress"
  to_port           = 80
  from_port         = 80
  protocol          = "tcp"
  security_group_id = "${aws_security_group.bouncer_elb.id}"
  cidr_blocks       = ["${var.traffic_replay_ips}"]
}

resource "aws_security_group_rule" "bouncer-elb_ingress_fastly_https" {
  type              = "ingress"
  to_port           = 443
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.bouncer_elb.id}"
  cidr_blocks       = ["${data.fastly_ip_ranges.fastly.cidr_blocks}", "${var.office_ips}"]
}

resource "aws_security_group_rule" "bouncer-elb_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.bouncer_elb.id}"
}

resource "aws_security_group" "bouncer_internal_elb" {
  name        = "${var.stackname}_bouncer_internal_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the bouncer internal ELB"

  tags {
    Name = "${var.stackname}_bouncer_internal_elb_access"
  }
}

resource "aws_security_group_rule" "bouncer-external-elb_ingress_monitoring_https" {
  type                     = "ingress"
  to_port                  = 443
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.monitoring.id}"
  source_security_group_id = "${aws_security_group.bouncer_elb.id}"
}

resource "aws_security_group_rule" "bouncer-external-elb_ingress_monitoring_http" {
  type                     = "ingress"
  to_port                  = 80
  from_port                = 80
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.monitoring.id}"
  source_security_group_id = "${aws_security_group.bouncer_elb.id}"
}

resource "aws_security_group_rule" "bouncer-internal-elb_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.bouncer_internal_elb.id}"
}
