#
# == Manifest: Project: Security Groups: gatling
#
# Gatling needs to be accessible on ports:
#   - 22
#   - 80
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_gatling_id

resource "aws_security_group" "gatling" {
  name        = "${var.stackname}_gatling_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the gatling host"

  tags {
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

resource "aws_security_group_rule" "gatling_ingress_gatling_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
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
