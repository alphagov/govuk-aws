#
# == Manifest: Project: Security Groups: monitoring
#
# The monitoring host needs to be accessible on ports:
#   - 443 from the other VMs
#   - 6514-6516 from Fastly
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_monitoring_id
# sg_monitoring_elb_id

resource "aws_security_group" "monitoring" {
  name        = "${var.stackname}_monitoring_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.outputs.vpc_id}"
  description = "Access to the monitoring host from its ELB"

  tags = {
    Name = "${var.stackname}_monitoring_access"
  }
}

resource "aws_security_group_rule" "monitoring_ingress_monitoring-external-elb_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.monitoring.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.monitoring_external_elb.id}"
}

resource "aws_security_group_rule" "monitoring_ingress_monitoring-internal-elb_nsca" {
  type      = "ingress"
  from_port = 5667
  to_port   = 5667
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.monitoring.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.monitoring_internal_elb.id}"
}

resource "aws_security_group_rule" "monitoring_ingress_monitoring-internal-elb_ssh" {
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.monitoring.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.monitoring_internal_elb.id}"
}

resource "aws_security_group_rule" "monitoring_ingress_monitoring-internal-elb_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.monitoring.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.monitoring_internal_elb.id}"
}

resource "aws_security_group" "monitoring_external_elb" {
  name        = "${var.stackname}_monitoring_external_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.outputs.vpc_id}"
  description = "Access the monitoring ELB"

  tags = {
    Name = "${var.stackname}_monitoring_external_elb_access"
  }
}

resource "aws_security_group_rule" "monitoring-external-elb_ingress_office_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id = "${aws_security_group.monitoring_external_elb.id}"
  cidr_blocks       = var.office_ips
}

resource "aws_security_group_rule" "monitoring-external-elb_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.monitoring_external_elb.id}"
}

resource "aws_security_group" "monitoring_internal_elb" {
  name        = "${var.stackname}_monitoring_internal_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.outputs.vpc_id}"
  description = "Access the monitoring ELB"

  tags = {
    Name = "${var.stackname}_monitoring_internal_elb_access"
  }
}

resource "aws_security_group_rule" "monitoring-internal-elb_ingress_management_ncsa" {
  type      = "ingress"
  from_port = 5667
  to_port   = 5667
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.monitoring_internal_elb.id}"
  source_security_group_id = "${aws_security_group.management.id}"
}

resource "aws_security_group_rule" "monitoring-internal-elb_ingress_management_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.monitoring_internal_elb.id}"
  source_security_group_id = "${aws_security_group.management.id}"
}

resource "aws_security_group_rule" "monitoring-internal-elb_ingress_jumpbox_ssh" {
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.monitoring_internal_elb.id}"
  source_security_group_id = "${aws_security_group.jumpbox.id}"
}

resource "aws_security_group_rule" "monitoring-internal-elb_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.monitoring_internal_elb.id}"
}

# Allows access to the monitoring machine from its ELB on specified ports
resource "aws_security_group_rule" "monitoring_ingress_monitoring-elb_syslog-tls" {
  type      = "ingress"
  from_port = 6514
  to_port   = 6516
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.monitoring.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.monitoring_external_elb.id}"
}

# Allows access to the monitoring ELB from fastly IPs on specified ports
resource "aws_security_group_rule" "monitoring-elb_ingress_fastly_syslog-tls" {
  type              = "ingress"
  from_port         = 6514
  to_port           = 6516
  protocol          = "tcp"
  security_group_id = "${aws_security_group.monitoring_external_elb.id}"
  cidr_blocks       = data.fastly_ip_ranges.fastly.cidr_blocks
}
