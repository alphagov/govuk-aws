#
# == Manifest: Project: Security Groups: graphite
#
# The graphite needs to be accessible on ports:
#   - 2003/tcp (carbon-aggregator LINE_RECEIVER)
#   - 2004/tcp (carbon-aggregator PICKLE_RECEIVER)
#   - 443/tcp (api)
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_graphite_id
# sg_graphite_elb_id

resource "aws_security_group" "graphite" {
  name        = "${var.stackname}_graphite_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the graphite host from its ELB"

  tags {
    Name = "${var.stackname}_graphite_access"
  }
}

resource "aws_security_group_rule" "allow_graphite_external_elb_in" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.graphite.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.graphite_external_elb.id}"
}

resource "aws_security_group_rule" "allow_graphite_carbon_aggregator_line_internal_elb_in" {
  type      = "ingress"
  from_port = 2003
  to_port   = 2003
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.graphite.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.graphite_internal_elb.id}"
}

resource "aws_security_group_rule" "allow_graphite_carbon_aggregator_pickle_internal_elb_in" {
  type      = "ingress"
  from_port = 2004
  to_port   = 2004
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.graphite.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.graphite_internal_elb.id}"
}

resource "aws_security_group" "graphite_external_elb" {
  name        = "${var.stackname}_graphite_external_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the Graphite External ELB"

  tags {
    Name = "${var.stackname}_graphite_external_elb_access"
  }
}

resource "aws_security_group_rule" "allow_graphite_external_elb_office_in" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id = "${aws_security_group.graphite_external_elb.id}"
  cidr_blocks       = ["${var.office_ips}"]
}

resource "aws_security_group_rule" "allow_graphite_external_elb_management_in" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.graphite_external_elb.id}"
  source_security_group_id = "${aws_security_group.management.id}"
}

resource "aws_security_group_rule" "allow_graphite_external_elb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.graphite_external_elb.id}"
}

resource "aws_security_group" "graphite_internal_elb" {
  name        = "${var.stackname}_graphite_internal_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the Graphite Internal ELB"

  tags {
    Name = "${var.stackname}_graphite_internal_elb_access"
  }
}

resource "aws_security_group_rule" "allow_management_to_graphite_carbon_aggregator_line_elb" {
  type      = "ingress"
  from_port = 2003
  to_port   = 2003
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.graphite_internal_elb.id}"
  source_security_group_id = "${aws_security_group.management.id}"
}

resource "aws_security_group_rule" "allow_management_to_graphite_carbon_aggregator_pickle_elb" {
  type      = "ingress"
  from_port = 2004
  to_port   = 2004
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.graphite_internal_elb.id}"
  source_security_group_id = "${aws_security_group.management.id}"
}

resource "aws_security_group_rule" "allow_graphite_internal_elb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.graphite_internal_elb.id}"
}
