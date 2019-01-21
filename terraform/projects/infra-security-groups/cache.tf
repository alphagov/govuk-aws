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

resource "aws_security_group_rule" "cache_ingress_cache-elb_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.cache.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.cache_elb.id}"
}

resource "aws_security_group_rule" "cache_ingress_cache-external-elb_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.cache.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.cache_external_elb.id}"
}

# Allow the router-backend instances to reload router routes
resource "aws_security_group_rule" "cache_ingress_router-backend_router" {
  type      = "ingress"
  from_port = 3055
  to_port   = 3055
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.cache.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.router-backend.id}"
}

# Allow the backend instances to clear parts of the varnish cache
resource "aws_security_group_rule" "cache_ingress_backend_varnish" {
  type      = "ingress"
  from_port = 7999
  to_port   = 7999
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.cache.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.backend.id}"
}

resource "aws_security_group" "cache_elb" {
  name        = "${var.stackname}_cache_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the cache ELB"

  tags {
    Name = "${var.stackname}_cache_elb_access"
  }
}

# Allow cache to speak to it's own ELB to reroute publicapi traffic
# to itself
resource "aws_security_group_rule" "cache-elb_ingress_cache_https" {
  type      = "ingress"
  to_port   = 443
  from_port = 443
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.cache_elb.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.cache.id}"
}

resource "aws_security_group_rule" "cache-elb_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.cache_elb.id}"
}

resource "aws_security_group" "cache_external_elb" {
  name        = "${var.stackname}_cache_external_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the cache external ELB"

  tags {
    Name = "${var.stackname}_cache_external_elb_access"
  }
}

resource "aws_security_group_rule" "cache-external-elb_ingress_public_https" {
  type              = "ingress"
  to_port           = 443
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.cache_external_elb.id}"
  cidr_blocks       = ["0.0.0.0/0", "${var.office_ips}", "${var.traffic_replay_ips}"]
}

resource "aws_security_group_rule" "cache-external-elb_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.cache_external_elb.id}"
}
