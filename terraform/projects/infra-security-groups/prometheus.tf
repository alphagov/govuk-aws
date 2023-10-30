#
# == Manifest: Project: Security Groups: prometheus
#
# Prometheus needs to be accessible on ports:
#   - 9090
#
# === Variables:
# stackname - string
# gds_egress_ips - array of CIDR blocks
#
# === Outputs:
# sg_prometheus_id
# sg_prometheus_elb_id

resource "aws_security_group" "prometheus" {
  name        = "${var.stackname}_prometheus"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.outputs.vpc_id}"
  description = "Access to prometheus instance from the prometheus LB"

  tags = {
    Name = "${var.stackname}_prometheus"
  }
}

resource "aws_security_group_rule" "prometheuselb_ingress_prometheus_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.prometheus.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.prometheus_external_elb.id}"
}

resource "aws_security_group" "prometheus_internal_elb" {
  name        = "${var.stackname}_prometheus_internal_elb"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.outputs.vpc_id}"
  description = "Prometheus Internal LB"

  tags = {
    Name = "${var.stackname}_prometheus_internal_elb"
  }
}

resource "aws_security_group_rule" "prometheus-internal-elb_ingress_prometheus_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.prometheus.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.prometheus_internal_elb.id}"
}

resource "aws_security_group_rule" "prometheus-internal-elb_egress_prometheus_http" {
  type      = "egress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.prometheus_internal_elb.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.prometheus.id}"
}

resource "aws_security_group_rule" "prometheus-internal-elb_ingress_grafana_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.prometheus_internal_elb.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.graphite.id}" # Note: Grafana runs on the graphite VM
}

resource "aws_security_group" "prometheus_external_elb" {
  name        = "${var.stackname}_prometheus_external_elb"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.outputs.vpc_id}"
  description = "Access to prometheus LB"

  tags = {
    Name = "${var.stackname}_prometheus_external_elb"
  }
}

resource "aws_security_group_rule" "prometheus-elb_ingress_officeips_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.prometheus_external_elb.id}"

  # Which security group can use this rule
  cidr_blocks = var.gds_egress_ips
}

resource "aws_security_group_rule" "prometheus-elb_egress_prometheus_http" {
  type      = "egress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.prometheus_external_elb.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.prometheus.id}"
}
