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

resource "aws_security_group" "draft-cache_elb" {
  name        = "${var.stackname}_draft-cache_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the draft-cache ELB"

  tags {
    Name = "${var.stackname}_draft-cache_elb_access"
  }
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
