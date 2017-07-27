#
# == Manifest: Project: Security Groups: rabbitmq
#
# The rabbitmq needs to be accessible on ports:
#   - 5672/tcp
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_rabbitmq_id
# sg_rabbitmq_elb_id

resource "aws_security_group" "rabbitmq" {
  name        = "${var.stackname}_rabbitmq_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the rabbitmq host from its ELB"

  tags {
    Name = "${var.stackname}_rabbitmq_access"
  }
}

resource "aws_security_group_rule" "allow_rabbitmq_elb_in" {
  type      = "ingress"
  from_port = 5672
  to_port   = 5672
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.rabbitmq.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.rabbitmq_elb.id}"
}

resource "aws_security_group" "rabbitmq_elb" {
  name        = "${var.stackname}_rabbitmq_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the rabbitmq Internal ELB"

  tags {
    Name = "${var.stackname}_rabbitmq_elb_access"
  }
}

resource "aws_security_group_rule" "allow_management_to_rabbitmq_elb" {
  type      = "ingress"
  from_port = 5672
  to_port   = 5672
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.rabbitmq_elb.id}"
  source_security_group_id = "${aws_security_group.management.id}"
}

resource "aws_security_group_rule" "allow_rabbitmq_elb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.rabbitmq_elb.id}"
}
