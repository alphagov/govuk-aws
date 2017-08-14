#
# == Manifest: Project: Security Groups: frontend-lb
#
# The frontend-lb needs to be accessible on ports:
#   - 443 from the other VMs
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_frontend-lb_id
# sg_frontend-lb_elb_id

resource "aws_security_group" "frontend-lb" {
  name        = "${var.stackname}_frontend-lb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the frontend-lb host from its ELB"

  tags {
    Name = "${var.stackname}_frontend-lb_access"
  }
}

resource "aws_security_group_rule" "allow_frontend-lb_elb_in" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.frontend-lb.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.frontend-lb_elb.id}"
}

resource "aws_security_group" "frontend-lb_elb" {
  name        = "${var.stackname}_frontend-lb_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the frontend-lb ELB"

  tags {
    Name = "${var.stackname}_frontend-lb_elb_access"
  }
}

resource "aws_security_group_rule" "allow_cache-https_elb_in" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.frontend-lb_elb.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.cache.id}"
}

# TODO test whether egress rules are needed on ELBs
resource "aws_security_group_rule" "allow_frontend-lb_elb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.frontend-lb_elb.id}"
}
