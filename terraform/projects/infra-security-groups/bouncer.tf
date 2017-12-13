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

resource "aws_security_group_rule" "allow_bouncer_elb_in" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.bouncer.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.bouncer_elb.id}"
}

resource "aws_security_group_rule" "allow_bouncer_internal_elb_in" {
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

resource "aws_security_group_rule" "allow_fastly_to_bouncer_elb_http" {
  type              = "ingress"
  to_port           = 80
  from_port         = 80
  protocol          = "tcp"
  security_group_id = "${aws_security_group.bouncer_elb.id}"
  cidr_blocks       = ["${data.fastly_ip_ranges.fastly.cidr_blocks}", "${var.office_ips}"]
}

resource "aws_security_group_rule" "allow_traffic-replay_to_bouncer_elb_http" {
  type              = "ingress"
  to_port           = 80
  from_port         = 80
  protocol          = "tcp"
  security_group_id = "${aws_security_group.bouncer_elb.id}"
  cidr_blocks       = ["${var.traffic_replay_ips}"]
}

resource "aws_security_group_rule" "allow_fastly_to_bouncer_elb_https" {
  type              = "ingress"
  to_port           = 443
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.bouncer_elb.id}"
  cidr_blocks       = ["${data.fastly_ip_ranges.fastly.cidr_blocks}", "${var.office_ips}"]
}

# TODO test whether egress rules are needed on ELBs
resource "aws_security_group_rule" "allow_bouncer_elb_egress" {
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

resource "aws_security_group_rule" "allow_monitoring_to_bouncer_internal_elb_https" {
  type                     = "ingress"
  to_port                  = 443
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.bouncer_internal_elb.id}"
  source_security_group_id = "${aws_security_group.monitoring.id}"
}

resource "aws_security_group_rule" "allow_monitoring_to_bouncer_internal_elb_http" {
  type                     = "ingress"
  to_port                  = 80
  from_port                = 80
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.bouncer_internal_elb.id}"
  source_security_group_id = "${aws_security_group.monitoring.id}"
}

resource "aws_security_group_rule" "allow_bouncer_internal_elb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.bouncer_internal_elb.id}"
}
