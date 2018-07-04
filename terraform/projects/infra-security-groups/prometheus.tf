#
# == Manifest: Project: Security Groups: logs-cdn
#
# Prometheus needs to be accessible on ports:
#   - 9090
#
# === Variables:
# stackname - string
# office_ips - array of CIDR blocks
#
# === Outputs:
# sg_prometheus_id
# sg_prometheus_elb_id

resource "aws_security_group" "prometheus" {
  name        = "${var.stackname}_prometheus"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to prometheus"

  tags {
    Name = "${var.stackname}_prometheus_elb"
  }
}

resource "aws_security_group_rule" "prometheus-ingress-prometheus_external_elb-https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.prometheus.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.prometheus_external_elb.id}"
}

resource "aws_security_group" "prometheus_external_elb" {
  name        = "${var.stackname}_prometheus_external_elb"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to prometheus"

  tags {
    Name = "${var.stackname}_prometheus_external_elb"
  }
}

resource "aws_security_group_rule" "prometheus_external_elb-ingress-office-https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.prometheus_external_elb.id}"

  # Which security group can use this rule
  cidr_blocks       = ["${var.office_ips}"]
}

