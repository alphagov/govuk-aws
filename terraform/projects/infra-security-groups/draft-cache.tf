#
# == Manifest: Project: Security Groups: draft-cache
#
# The puppetmaster needs to be accessible on ports:
#   - 443 from the other VMs
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_draft-cache_id
# sg_draft-cache_elb_id

resource "aws_security_group" "draft-cache" {
  name        = "${var.stackname}_draft-cache_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the draft-cache host from its ELB"

  tags {
    Name = "${var.stackname}_draft-cache_access"
  }
}

resource "aws_security_group_rule" "allow_draft-cache_elb_in" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.draft-cache.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.draft-cache_elb.id}"
}

resource "aws_security_group_rule" "allow_draft-cache_external_elb_in" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.draft-cache.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.draft-cache_external_elb.id}"
}

# We need to allow draft-cache instances to speak to their own to reload router
# routes
resource "aws_security_group_rule" "allow_draft-cache_from_draft-cache" {
  type      = "ingress"
  from_port = 3055
  to_port   = 3055
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.draft-cache.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.draft-cache.id}"
}

resource "aws_security_group" "draft-cache_elb" {
  name        = "${var.stackname}_draft-cache_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the draft-cache ELB"

  tags {
    Name = "${var.stackname}_draft-cache_elb_access"
  }
}

resource "aws_security_group" "draft-cache_external_elb" {
  name        = "${var.stackname}_draft-cache_elb_external_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the draft-cache external ELB"

  tags {
    Name = "${var.stackname}_draft-cache_external_elb_access"
  }
}

resource "aws_security_group_rule" "allow_public_to_draft-cache_external_elb" {
  type              = "ingress"
  to_port           = 443
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.draft-cache_external_elb.id}"
  cidr_blocks       = ["0.0.0.0/0", "${var.office_ips}"]
}

# This is required to commit routes using router-api at the end of the data sync
resource "aws_security_group_rule" "allow_draft-cache_from_draft-content-store" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.draft-cache_elb.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.draft-content-store.id}"
}

# TODO test whether egress rules are needed on ELBs
resource "aws_security_group_rule" "allow_draft-cache_elb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.draft-cache_elb.id}"
}
