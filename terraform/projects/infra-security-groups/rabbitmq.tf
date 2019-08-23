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

resource "aws_security_group_rule" "rabbitmq_ingress_rabbitmq-elb_amqp" {
  type      = "ingress"
  from_port = 5672
  to_port   = 5672
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.rabbitmq.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.rabbitmq_elb.id}"
}

resource "aws_security_group_rule" "rabbitmq_ingress_carrenza-rabbitmq_amqp" {
  type      = "ingress"
  from_port = 5672
  to_port   = 5672
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.rabbitmq.id}"
  cidr_blocks       = ["${var.carrenza_rabbitmq_ips}"]
}

resource "aws_security_group_rule" "rabbitmq_ingress_rabbitmq-elb_rabbitmq-stomp" {
  type      = "ingress"
  from_port = 6163
  to_port   = 6163
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.rabbitmq.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.rabbitmq_elb.id}"
}

resource "aws_security_group_rule" "rabbitmq_ingress_rabbitmq_rabbitmq-transport" {
  type      = "ingress"
  from_port = 9100
  to_port   = 9100
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.rabbitmq.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.rabbitmq.id}"
}

resource "aws_security_group_rule" "rabbitmq_ingress_rabbitmq_rabbitmq-epmd" {
  type      = "ingress"
  from_port = 4369
  to_port   = 4369
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.rabbitmq.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.rabbitmq.id}"
}

resource "aws_security_group" "rabbitmq_elb" {
  name        = "${var.stackname}_rabbitmq_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the rabbitmq Internal ELB"

  tags {
    Name = "${var.stackname}_rabbitmq_elb_access"
  }
}

# TODO: Audit
resource "aws_security_group_rule" "rabbitmq-elb_ingress_management_amqp" {
  type      = "ingress"
  from_port = 5672
  to_port   = 5672
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.rabbitmq_elb.id}"
  source_security_group_id = "${aws_security_group.management.id}"
}

resource "aws_security_group_rule" "rabbitmq-elb_ingress_management_rabbitmq-stomp" {
  type      = "ingress"
  from_port = 6163
  to_port   = 6163
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.rabbitmq_elb.id}"
  source_security_group_id = "${aws_security_group.management.id}"
}

resource "aws_security_group_rule" "rabbitmq-elb_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.rabbitmq_elb.id}"
}
