#
# == Manifest: Project: Security Groups: api
#
# The api needs to be accessible on ports:
#   - 443 from the other VMs
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_api_id
# sg_api_elb_id

resource "aws_security_group" "api" {
  name        = "${var.stackname}_api_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the api host from its ELB"

  tags {
    Name = "${var.stackname}_api_access"
  }
}

resource "aws_security_group_rule" "allow_api_elb_in" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.api.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.api_elb.id}"
}

resource "aws_security_group" "api_elb" {
  name        = "${var.stackname}_api_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the api ELB"

  tags {
    Name = "${var.stackname}_api_elb_access"
  }
}

resource "aws_security_group_rule" "allow_api-lb-https_to_api_elb" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.api_elb.id}"
  source_security_group_id = "${aws_security_group.api-lb.id}"
}

# TODO test whether egress rules are needed on ELBs
resource "aws_security_group_rule" "allow_api_elb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.api_elb.id}"
}
