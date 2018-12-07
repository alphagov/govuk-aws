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

resource "aws_security_group_rule" "content-store_ingress_content-store-internal-elb_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.content-store.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.content-store_internal_elb.id}"
}

resource "aws_security_group_rule" "content-store_ingress_content-store-external-elb_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.content-store.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.content-store_external_elb.id}"
}

resource "aws_security_group" "content-store_internal_elb" {
  name        = "${var.stackname}_content-store_internal_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the content-store internal ELB"

  tags {
    Name = "${var.stackname}_content-store_internal_elb_access"
  }
}

# TODO: Audit
resource "aws_security_group_rule" "content-store-internal-elb_ingress_management_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.content-store_internal_elb.id}"
  source_security_group_id = "${aws_security_group.management.id}"
}

resource "aws_security_group_rule" "content-store-internal-elb_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.content-store_internal_elb.id}"
}

resource "aws_security_group" "content-store_external_elb" {
  name        = "${var.stackname}_content-store_external_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the content-store external ELB"

  tags {
    Name = "${var.stackname}_content-store_external_elb_access"
  }
}

# TODO: Audit
resource "aws_security_group_rule" "content-store-external-elb_ingress_public_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id = "${aws_security_group.content-store_external_elb.id}"
  cidr_blocks       = ["${var.carrenza_env_ips}", "${var.office_ips}"]
}

resource "aws_security_group_rule" "content-store-external-elb_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.content-store_external_elb.id}"
}
