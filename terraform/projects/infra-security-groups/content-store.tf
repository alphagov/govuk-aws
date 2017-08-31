#
# == Manifest: Project: Security Groups: content-store
#
# The content-store needs to be accessible on ports:
#   - 443 from the other VMs
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_content-store_id
# sg_content-store_elb_id

resource "aws_security_group" "content-store" {
  name        = "${var.stackname}_content-store_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the content-store host from its ELB"

  tags {
    Name = "${var.stackname}_content-store_access"
  }
}

resource "aws_security_group_rule" "allow_content-store_elb_in" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.content-store.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.content-store_elb.id}"
}

resource "aws_security_group" "content-store_elb" {
  name        = "${var.stackname}_content-store_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the content-store ELB"

  tags {
    Name = "${var.stackname}_content-store_elb_access"
  }
}

# Content Store should be available externally
resource "aws_security_group_rule" "allow_public_to_content-store_elb" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id = "${aws_security_group.content-store_elb.id}"
  cidr_blocks       = ["0.0.0.0/0", "${var.office_ips}"]
}

# TODO test whether egress rules are needed on ELBs
resource "aws_security_group_rule" "allow_content-store_elb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.content-store_elb.id}"
}
