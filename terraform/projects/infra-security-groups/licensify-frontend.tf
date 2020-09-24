#
# == Manifest: Project: Security Groups: licensify-frontend
#
# The licensify-frontend needs to be accessible on ports:
#   - 443 from the other VMs
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_licensify-frontend_id
# sg_licensify-frontend_elb_id

resource "aws_security_group" "licensify-frontend" {
  name        = "${var.stackname}_licensify-frontend_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the licensify-frontend host from its public ELB and internal LB"

  tags {
    Name = "${var.stackname}_licensify-frontend_access"
  }
}

resource "aws_security_group_rule" "licensify-frontend_ingress_licensify-frontend-elb_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.licensify-frontend.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.licensify-frontend_external_elb.id}"
}

resource "aws_security_group_rule" "licensify-frontend_ingress_licensify-frontend-internal-lb_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.licensify-frontend.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.licensify-frontend_internal_lb.id}"
}

resource "aws_security_group" "licensify-frontend_external_elb" {
  name        = "${var.stackname}_licensify-frontend_external_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the public licensify-frontend ELB"

  tags {
    Name = "${var.stackname}_licensify-frontend_elb_access"
  }
}

resource "aws_security_group_rule" "licensify-frontend-elb_ingress_office_https" {
  count     = "${(var.aws_environment == "integration") || (var.aws_environment == "staging") ? 1 : 0}"
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id = "${aws_security_group.licensify-frontend_external_elb.id}"
  cidr_blocks       = ["${var.office_ips}"]
}

resource "aws_security_group_rule" "licensify-frontend-elb_ingress_public_https" {
  count     = "${var.aws_environment == "production"? 1 : 0}"
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id = "${aws_security_group.licensify-frontend_external_elb.id}"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "licensify-frontend-elb_ingress_office_http" {
  count     = "${(var.aws_environment == "integration") || (var.aws_environment == "staging") ? 1 : 0}"
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  security_group_id = "${aws_security_group.licensify-frontend_external_elb.id}"
  cidr_blocks       = ["${var.office_ips}"]
}

resource "aws_security_group_rule" "licensify-frontend-elb_ingress_public_http" {
  count     = "${var.aws_environment == "production"? 1 : 0}"
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  security_group_id = "${aws_security_group.licensify-frontend_external_elb.id}"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "licensify-frontend-elb_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.licensify-frontend_external_elb.id}"
}

# Internal Loadbalancer
resource "aws_security_group" "licensify-frontend_internal_lb" {
  name        = "${var.stackname}_licensify-frontend_lb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the licensify-frontend LB"

  tags {
    Name = "${var.stackname}_licensify-frontend_internal_lb_access"
  }
}

resource "aws_security_group_rule" "licensify-frontend-internal-lb_ingress_management_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.licensify-frontend_internal_lb.id}"
  source_security_group_id = "${aws_security_group.management.id}"
}

resource "aws_security_group_rule" "licensify-frontend-internal-lb_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.licensify-frontend_internal_lb.id}"
}

resource "aws_security_group" "licensify_frontend_ithc_access" {
  count       = "${length(var.ithc_access_ips) > 0 ? 1 : 0}"
  name        = "${var.stackname}_licensify_frontend_ithc_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Control access to ITHC SSH"

  tags {
    Name = "${var.stackname}_licensify_frontend_ithc_access"
  }
}

resource "aws_security_group_rule" "ithc_ingress_licensify_frontend_ssh" {
  count             = "${length(var.ithc_access_ips) > 0 ? 1 : 0}"
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  cidr_blocks       = "${var.ithc_access_ips}"
  security_group_id = "${aws_security_group.licensify_frontend_ithc_access.id}"
}
