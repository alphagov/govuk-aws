#
# == Manifest: Project: Security Groups: puppetmaster
#
# The puppetmaster needs to be accessible on ports:
#   - 8140 from the other VMs
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_puppetmaster_id
# sg_puppetmaster_elb_id

resource "aws_security_group" "puppetmaster" {
  name        = "${var.stackname}_puppetmaster_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the puppetmaster from its ELB"

  tags {
    Name = "${var.stackname}_puppetmaster_access"
  }
}

# All VMs will need to talk to the puppetmaster.
resource "aws_security_group_rule" "allow_puppet_elb_in" {
  type      = "ingress"
  from_port = 8140
  to_port   = 8140
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.puppetmaster.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.puppetmaster_elb.id}"
}

resource "aws_security_group_rule" "allow_puppetdb_elb_in" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.puppetmaster.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.puppetmaster_elb.id}"
}

resource "aws_security_group" "puppetmaster_elb" {
  name        = "${var.stackname}_puppetmaster_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the puppetmaster ELB"

  tags {
    Name = "${var.stackname}_puppetmaster_elb_access"
  }
}

resource "aws_security_group_rule" "allow_management_to_puppet" {
  type      = "ingress"
  from_port = 8140
  to_port   = 8140
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.puppetmaster_elb.id}"
  source_security_group_id = "${aws_security_group.management.id}"
}

resource "aws_security_group_rule" "allow_monitoring_to_puppetdb" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.puppetmaster_elb.id}"
  source_security_group_id = "${aws_security_group.monitoring.id}"
}

# TODO test whether egress rules are needed on ELBs
resource "aws_security_group_rule" "allow_puppetmaster_elb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.puppetmaster_elb.id}"
}
