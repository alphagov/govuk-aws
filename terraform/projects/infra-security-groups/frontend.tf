#
# == Manifest: Project: Security Groups: frontend
#
# The frontend needs to be accessible on ports:
#   - 443 from the other VMs
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_frontend_id
# sg_frontend_elb_id

resource "aws_security_group" "frontend" {
  name        = "${var.stackname}_frontend_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the frontend host from its ELB"

  tags {
    Name = "${var.stackname}_frontend_access"
  }
}

resource "aws_security_group_rule" "frontend_ingress_frontend-elb_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.frontend.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.frontend_elb.id}"
}

resource "aws_security_group" "frontend_elb" {
  name        = "${var.stackname}_frontend_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the frontend ELB"

  tags {
    Name = "${var.stackname}_frontend_elb_access"
  }
}

# TODO: Audit
resource "aws_security_group_rule" "frontend-elb_ingress_management_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.frontend_elb.id}"
  source_security_group_id = "${aws_security_group.management.id}"
}

resource "aws_security_group_rule" "frontend-elb_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.frontend_elb.id}"
}

resource "aws_security_group" "static" {
  name        = "${var.stackname}_static_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to static host from its ELB"

  tags {
    Name = "${var.stackname}_static_access"
  }
}

resource "aws_security_group_rule" "frontend_ingress_static-carrenza-alb_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.frontend.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.static_carrenza_alb.id}"
}

resource "aws_security_group_rule" "static_ingress_static-carrenza-alb_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.static.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.static_carrenza_alb.id}"
}

resource "aws_security_group" "frontend_cache" {
  name        = "${var.stackname}_frontend_cache_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the frontend cache from frontend"

  tags {
    Name = "${var.stackname}_frontend_cache_access"
  }
}

resource "aws_security_group_rule" "frontend_ingress_frontend_cache_memcached" {
  type      = "ingress"
  from_port = 11211
  to_port   = 11211
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.frontend_cache.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.frontend.id}"
}

# Security resources for ALB set up for Carrenza access to AWS

resource "aws_security_group" "static_carrenza_alb" {
  name        = "${var.stackname}_static_carrenza_alb"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access static Carrenza ALB "

  tags {
    Name = "${var.stackname}_static_carrenza_alb_access"
  }
}

resource "aws_security_group_rule" "static-carrenza-alb_ingress_443_carrenza" {
  count     = "${length(var.carrenza_env_ips) > 0 ? 1 : 0}"
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  cidr_blocks       = ["${var.carrenza_env_ips}"]
  security_group_id = "${aws_security_group.static_carrenza_alb.id}"
}

resource "aws_security_group_rule" "static-carrenza-alb_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.static_carrenza_alb.id}"
}

resource "aws_security_group" "frontend_ithc_access" {
  count       = "${length(var.ithc_access_ips) > 0 ? 1 : 0}"
  name        = "${var.stackname}_frontend_ithc_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Control access to ITHC SSH"

  tags {
    Name = "${var.stackname}_frontend_ithc_access"
  }
}

resource "aws_security_group_rule" "ithc_ingress_frontend_ssh" {
  count             = "${length(var.ithc_access_ips) > 0 ? 1 : 0}"
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  cidr_blocks       = "${var.ithc_access_ips}"
  security_group_id = "${aws_security_group.frontend_ithc_access.id}"
}
