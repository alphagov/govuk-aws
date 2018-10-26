#
# == Manifest: Project: Security Groups: mapit
#
# Mapit needs to be accessible on 80/tcp internally
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_mapit_id
# sg_mapit_elb_id

resource "aws_security_group" "mapit" {
  name        = "${var.stackname}_mapit_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the mapit host from its ELB"

  tags {
    Name = "${var.stackname}_mapit_access"
  }
}

resource "aws_security_group_rule" "mapit_ingress_mapit-elb_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.mapit.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.mapit_elb.id}"
}

resource "aws_security_group" "mapit_elb" {
  name        = "${var.stackname}_mapit_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the mapit Internal ELB"

  tags {
    Name = "${var.stackname}_mapit_elb_access"
  }
}

resource "aws_security_group_rule" "mapit-elb_ingress_management_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.mapit_elb.id}"
  source_security_group_id = "${aws_security_group.management.id}"
}

resource "aws_security_group_rule" "mapit-elb_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.mapit_elb.id}"
}

# Security resources for ALB set up for Carrenza access to AWS Mapit

resource "aws_security_group" "mapit_carrenza_alb" {
  name        = "${var.stackname}_mapit_carrenza_alb"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the mapit Carrenza ALB "

  tags {
    Name = "${var.stackname}_mapit_carrenza_alb_access"
  }
}

resource "aws_security_group_rule" "mapit_carrenza_alb_ingress_443_carrenza" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  cidr_blocks       = ["${var.carrenza_env_ips}"]
  security_group_id = "${aws_security_group.mapit_carrenza_alb.id}"
}

resource "aws_security_group_rule" "mapit_carrenza_alb_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.mapit_carrenza_alb.id}"
}
