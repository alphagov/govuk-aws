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

resource "aws_security_group_rule" "draft-cache_ingress_draft-cache-elb_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.draft-cache.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.draft-cache_elb.id}"
}

resource "aws_security_group_rule" "draft-cache_ingress_draft-cache-external-elb_http" {
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
resource "aws_security_group_rule" "draft-cache_ingress_draft-cache_router" {
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

# Allow draft-cache to speak to it's own ELB to reroute publicapi traffic
# to itself
resource "aws_security_group_rule" "draft-cache-elb_ingress_cache_https" {
  type      = "ingress"
  to_port   = 443
  from_port = 443
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.draft-cache_elb.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.draft-cache.id}"
}

# Allow Jenkins to speak to ELB to make /healthcheck requests
resource "aws_security_group_rule" "draft-cache-elb_ingress_management_https" {
  type      = "ingress"
  to_port   = 443
  from_port = 443
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.draft-cache_elb.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.management.id}"
}

resource "aws_security_group" "draft-cache_external_elb" {
  name        = "${var.stackname}_draft-cache_elb_external_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the draft-cache external ELB"

  tags {
    Name = "${var.stackname}_draft-cache_external_elb_access"
  }
}

resource "aws_security_group_rule" "draft-cache-external-elb_ingress_public_https" {
  type              = "ingress"
  to_port           = 443
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.draft-cache_external_elb.id}"
  cidr_blocks       = ["0.0.0.0/0"]
}

# This is required to commit routes using router-api at the end of the data sync
resource "aws_security_group_rule" "draft-cache-elb_ingress_draft-content-store_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.draft-cache_elb.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.draft-content-store.id}"
}

resource "aws_security_group_rule" "draft-cache-elb_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.draft-cache_elb.id}"
}

resource "aws_security_group_rule" "draft-cache-external-elb_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.draft-cache_external_elb.id}"
}

resource "aws_security_group" "draft-cache_ithc_access" {
  count       = "${length(var.ithc_access_ips) > 0 ? 1 : 0}"
  name        = "${var.stackname}_draft-cache_ithc_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Control access to ITHC SSH"

  tags {
    Name = "${var.stackname}_draft-cache_ithc_access"
  }
}

resource "aws_security_group_rule" "ithc_ingress_draft-cache_ssh" {
  count             = "${length(var.ithc_access_ips) > 0 ? 1 : 0}"
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  cidr_blocks       = "${var.ithc_access_ips}"
  security_group_id = "${aws_security_group.draft-cache_ithc_access.id}"
}
