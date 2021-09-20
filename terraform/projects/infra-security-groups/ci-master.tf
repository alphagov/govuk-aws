#
# == Manifest: Project: Security Groups: ci-master
#
# The puppetmaster needs to be accessible on ports:
#   - 443 from the other VMs
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_ci-master_id
# sg_ci-master_elb_id

resource "aws_security_group" "ci-master" {
  count       = "${var.aws_environment == "integration" ? 1 : 0}"
  name        = "${var.stackname}_ci-master_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the ci-master host from its ELB"

  tags {
    Name = "${var.stackname}_ci-master_access"
  }
}

resource "aws_security_group_rule" "ci-master_ingress_ci-master-elb_http" {
  count     = "${var.aws_environment == "integration" ? 1 : 0}"
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.ci-master.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.ci-master_elb.id}"
}

resource "aws_security_group_rule" "ci-master_ingress_ci-master-internal-elb_http" {
  count     = "${var.aws_environment == "integration" ? 1 : 0}"
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.ci-master.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.ci-master_internal_elb.id}"
}

resource "aws_security_group" "ci-master_elb" {
  count       = "${var.aws_environment == "integration" ? 1 : 0}"
  name        = "${var.stackname}_ci-master_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the ci-master ELB"

  tags {
    Name = "${var.stackname}_ci-master_elb_access"
  }
}

resource "aws_security_group_rule" "ci-master-elb_ingress_office_https" {
  count     = "${var.aws_environment == "integration" ? 1 : 0}"
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id = "${aws_security_group.ci-master_elb.id}"
  cidr_blocks       = ["${var.office_ips}"]
}

# Allow Carrenza Integration and Production access to trigger automated ci-masterments
resource "aws_security_group_rule" "ci-master-elb_ingress_carrenza_https" {
  count     = "${var.aws_environment == "integration" ? 1 : 0}"
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id = "${aws_security_group.ci-master_elb.id}"
  cidr_blocks       = ["${var.carrenza_integration_ips}", "${var.carrenza_production_ips}"]
}

resource "aws_security_group_rule" "ci-master-elb_ingress_github_https" {
  count     = "${var.aws_environment == "integration" ? 1 : 0}"
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id = "${aws_security_group.ci-master_elb.id}"
  cidr_blocks       = ["${data.github_ip_ranges.github.hooks_ipv4}"]
}

resource "aws_security_group_rule" "ci-master-elb_egress_any_any" {
  count             = "${var.aws_environment == "integration" ? 1 : 0}"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.ci-master_elb.id}"
}

resource "aws_security_group_rule" "ci-master-internal-elb_egress_any_any" {
  count             = "${var.aws_environment == "integration" ? 1 : 0}"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.ci-master_internal_elb.id}"
}

resource "aws_security_group" "ci-master_internal_elb" {
  count       = "${var.aws_environment == "integration" ? 1 : 0}"
  name        = "${var.stackname}_ci-master_internal_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the ci-master Internal ELB"

  tags {
    Name = "${var.stackname}_ci-master_internal_elb_access"
  }
}

resource "aws_security_group_rule" "ci-master-internal-elb_ingress_management_https" {
  count     = "${var.aws_environment == "integration" ? 1 : 0}"
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.ci-master_internal_elb.id}"
  source_security_group_id = "${aws_security_group.management.id}"
}
