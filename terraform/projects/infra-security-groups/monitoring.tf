#
# == Manifest: Project: Security Groups: monitoring
#
# The monitoring host needs to be accessible on ports:
#   - 443 from the other VMs
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_monitoring_id
# sg_monitoring_elb_id

resource "aws_security_group" "monitoring" {
  name        = "${var.stackname}_monitoring_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the monitoring host from its ELB"

  tags {
    Name = "${var.stackname}_monitoring_access"
  }
}

resource "aws_security_group_rule" "allow_monitoring_elb_in" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.monitoring.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.monitoring_elb.id}"
}

resource "aws_security_group" "monitoring_elb" {
  name        = "${var.stackname}_monitoring_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the monitoring ELB"

  tags {
    Name = "${var.stackname}_monitoring_elb_access"
  }
}

resource "aws_security_group_rule" "allow_office_to_monitoring" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id = "${aws_security_group.monitoring_elb.id}"
  cidr_blocks       = ["${var.office_ips}"]
}

# TODO test whether egress rules are needed on ELBs
resource "aws_security_group_rule" "allow_monitoring_elb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.monitoring_elb.id}"
}
