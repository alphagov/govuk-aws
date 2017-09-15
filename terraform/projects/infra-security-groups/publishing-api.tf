#
# == Manifest: Project: Security Groups: publishing-api
#
# The publishing-api needs to be accessible on ports:
#   - 443 from the other VMs
#
# === Variables:
# stackname - string
#
# === Outputs:
#
# sg_publishing-api_internal_id
# sg_publishing-api_elb_internal_id
# sg_publishing-api_external_id
# sg_publishing-api_elb_external_id
#
resource "aws_security_group" "publishing-api" {
  name        = "${var.stackname}_publishing-api_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the publishing-api host from its ELB"

  tags {
    Name = "${var.stackname}_publishing-api_access"
  }
}

resource "aws_security_group_rule" "allow_publishing-api_external_elb_in" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.publishing-api.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.publishing-api_elb_external.id}"
}

resource "aws_security_group" "publishing-api_elb_external" {
  name        = "${var.stackname}_publishing-api_elb_external_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the publishing-api ELB"

  tags {
    Name = "${var.stackname}_publishing-api_elb_access"
  }
}

resource "aws_security_group_rule" "allow_office_to_publishing-api_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.publishing-api_elb_external.id}"
  cidr_blocks       = ["${var.office_ips}"]
}

resource "aws_security_group" "publishing-api_elb_internal" {
  name        = "${var.stackname}_publishing-api_elb_internal_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the publishing-api ELB"

  tags {
    Name = "${var.stackname}_publishing-api_elb_access"
  }
}

resource "aws_security_group_rule" "allow_publishing-api_internal_elb_in" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.publishing-api.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.publishing-api_elb_internal.id}"
}

# TODO: application machines need access to publishing-api - create an application
# group that needs access?
resource "aws_security_group_rule" "allow_management_to_publishing-api_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.publishing-api_elb_external.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.management.id}"
}

# TODO: test whether egress rules are needed on elbs
resource "aws_security_group_rule" "allow_publishing-api_elb_external_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.publishing-api_elb_external.id}"
}

# TODO: test whether egress rules are needed on elbs
resource "aws_security_group_rule" "allow_publishing-api_elb_internal_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.publishing-api_elb_internal.id}"
}
