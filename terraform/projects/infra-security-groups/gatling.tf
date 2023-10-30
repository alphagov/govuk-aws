#
# == Manifest: Project: Security Groups: gatling
#
# Gatling instances need to be accessible on ports:
#   - 22 for ssh
#   - 80 for nginx access
#
# Nginx of Gatling instances are accessible via a restricted external load
# balancer to office IPs only. External load balancer has open ports:
#   - 443 for HTTPS

resource "aws_security_group" "gatling" {
  name        = "${var.stackname}_gatling_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.outputs.vpc_id}"
  description = "Access to the gatling host"

  tags = {
    Name = "${var.stackname}_gatling_access"
  }
}

resource "aws_security_group_rule" "gatling_ingress_gatling_ssh" {
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.gatling.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.gatling.id}"
}

resource "aws_security_group_rule" "gatling_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.gatling.id}"
}

resource "aws_security_group_rule" "gatling_ingress_gatling_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.gatling.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.gatling_external_elb.id}"
}

resource "aws_security_group" "gatling_external_elb" {
  name        = "${var.stackname}_gatling_external_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.outputs.vpc_id}"
  description = "Access the gatling External ELB"

  tags = {
    Name = "${var.stackname}_gatling_external_elb_access"
  }
}

resource "aws_security_group_rule" "gatling-external-elb_ingress_office_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id = "${aws_security_group.gatling_external_elb.id}"
  cidr_blocks       = var.gds_egress_ips
}

resource "aws_security_group_rule" "gatling-external-elb_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.gatling_external_elb.id}"
}
