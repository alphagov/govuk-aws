#
# == Manifest: Project: Security Groups: publishing-api-db-admin
#
# The publishing-api-db-admin needs to be accessible on ports:
#   - 22 from the other VMs
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_publishing-api-db-admin_id
# sg_publishing-api-db-admin_elb_id

resource "aws_security_group" "publishing-api-db-admin" {
  name        = "${var.stackname}_publishing-api-db-admin_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the publishing-api-db-admin host from its ELB"

  tags {
    Name = "${var.stackname}_publishing-api-db-admin_access"
  }
}

resource "aws_security_group_rule" "publishing-api-db-admin_ingress_publishing-api-db-admin-elb_ssh" {
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.publishing-api-db-admin.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.publishing-api-db-admin_elb.id}"
}

resource "aws_security_group" "publishing-api-db-admin_elb" {
  name        = "${var.stackname}_publishing-api-db-admin_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the publishing-api-db-admin ELB"

  tags {
    Name = "${var.stackname}_publishing-api-db-admin_elb_access"
  }
}

resource "aws_security_group_rule" "publishing-api-db-admin-elb_ingress_management_ssh" {
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.publishing-api-db-admin_elb.id}"
  source_security_group_id = "${aws_security_group.management.id}"
}

resource "aws_security_group_rule" "publishing-api-db-admin-elb_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.publishing-api-db-admin_elb.id}"
}
