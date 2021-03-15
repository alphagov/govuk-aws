# == Manifest: Project: Security Groups: sidekiq-monitoring
#
# The sidekiq-monitoring needs to be accessible on ports:
#   - 443 from the other VMs

# === Variables:
# stackname - string
#
# === Outputs:
# sg_sidekiq-monitoring_elb_id

resource "aws_security_group" "sidekiq-monitoring_external_elb" {
  name        = "${var.stackname}_sidekiq-monitoring_external_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the sidekiq-monitoring external ELB"

  tags {
    Name = "${var.stackname}_sidekiq-monitoring_external_elb_access"
  }
}

resource "aws_security_group_rule" "sidekiq-monitoring_ingress_external-elb_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id = "${aws_security_group.sidekiq-monitoring_external_elb.id}"
  cidr_blocks       = ["${var.office_ips}"]
}

resource "aws_security_group_rule" "sidekiq-monitoring_egress_external_elb_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.sidekiq-monitoring_external_elb.id}"
}
