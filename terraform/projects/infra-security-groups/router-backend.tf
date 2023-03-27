# == Manifest: Project: Security Groups: router-backend
#
# The Router Mongo instances needs to be accessible on ports:
#   - 27017 from other members of the cluster
#   - 27017 from cache
#   - 443 from clients
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_router-backend_id
# sg_router-api_elb_id
#
resource "aws_security_group" "router-backend" {
  name        = "${var.stackname}_router-backend_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.outputs.vpc_id}"
  description = "Access to router-backend"

  tags = {
    Name = "${var.stackname}_router-backend_access"
  }
}

# the nodes need to speak among themselves for clustering
resource "aws_security_group_rule" "router-backend_ingress_router-backend_mongo" {
  type      = "ingress"
  from_port = 27017
  to_port   = 27017
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.router-backend.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.router-backend.id}"
}

resource "aws_security_group_rule" "router-backend_ingress_router-api-elb_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.router-backend.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.router-api_elb.id}"
}

resource "aws_security_group_rule" "router-backend_ingress_draft-cache_mongo" {
  type      = "ingress"
  from_port = 27017
  to_port   = 27017
  protocol  = "tcp"

  security_group_id = "${aws_security_group.router-backend.id}"

  source_security_group_id = "${aws_security_group.draft-cache.id}"
}

resource "aws_security_group_rule" "router-backend_ingress_cache_mongo" {
  type      = "ingress"
  from_port = 27017
  to_port   = 27017
  protocol  = "tcp"

  security_group_id = "${aws_security_group.router-backend.id}"

  source_security_group_id = "${aws_security_group.cache.id}"
}

resource "aws_security_group" "router-api_elb" {
  name        = "${var.stackname}_router-api_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.outputs.vpc_id}"
  description = "Access to router-api"

  tags = {
    Name = "${var.stackname}_router-api_elb_access"
  }
}

# TODO: Audit
resource "aws_security_group_rule" "router-api-elb_ingress_management_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id = "${aws_security_group.router-api_elb.id}"

  source_security_group_id = "${aws_security_group.management.id}"
}

resource "aws_security_group_rule" "router-api-elb_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.router-api_elb.id}"
}

resource "aws_security_group" "router-backend_ithc_access" {
  count       = "${length(var.ithc_access_ips) > 0 ? 1 : 0}"
  name        = "${var.stackname}_router-backend_ithc_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.outputs.vpc_id}"
  description = "Control access to ITHC SSH"

  tags = {
    Name = "${var.stackname}_router-backend_ithc_access"
  }
}

resource "aws_security_group_rule" "ithc_ingress_router-backend_ssh" {
  count             = "${length(var.ithc_access_ips) > 0 ? 1 : 0}"
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  cidr_blocks       = "${var.ithc_access_ips}"
  security_group_id = "${aws_security_group.router-backend_ithc_access.id}"
}
