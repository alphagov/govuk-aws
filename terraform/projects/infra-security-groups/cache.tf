#
# == Manifest: Project: Security Groups: cache
#
# The cache needs to be accessible on ports:
#   - 443 from the other VMs
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_cache_id
# sg_cache_elb_id

resource "aws_security_group" "cache" {
  name        = "${var.stackname}_cache_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the cache host from its ELB"

  tags {
    Name = "${var.stackname}_cache_access"
  }
}

resource "aws_security_group_rule" "allow_cache_elb_in" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.cache.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.cache_elb.id}"
}

resource "aws_security_group" "cache_elb" {
  name        = "${var.stackname}_cache_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the cache ELB"

  tags {
    Name = "${var.stackname}_cache_elb_access"
  }
}

# Router backend needs access to cache for router-api to communicate with
# router to reload routes
resource "aws_security_group_rule" "allow_router-backend_to_cache_elb" {
  type      = "ingress"
  from_port = 3055
  to_port   = 3055
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.cache_elb.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.router-backend.id}"
}

# TODO test whether egress rules are needed on ELBs
resource "aws_security_group_rule" "allow_cache_elb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.cache_elb.id}"
}
