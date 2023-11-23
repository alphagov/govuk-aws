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
  vpc_id      = data.terraform_remote_state.infra_vpc.outputs.vpc_id
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
  security_group_id = aws_security_group.router-backend.id

  # Which security group can use this rule
  source_security_group_id = aws_security_group.router-backend.id
}

resource "aws_security_group" "router-backend_ithc_access" {
  count       = length(var.ithc_access_ips) > 0 ? 1 : 0
  name        = "${var.stackname}_router-backend_ithc_access"
  vpc_id      = data.terraform_remote_state.infra_vpc.outputs.vpc_id
  description = "Control access to ITHC SSH"

  tags = {
    Name = "${var.stackname}_router-backend_ithc_access"
  }
}

resource "aws_security_group_rule" "ithc_ingress_router-backend_ssh" {
  count             = length(var.ithc_access_ips) > 0 ? 1 : 0
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  cidr_blocks       = var.ithc_access_ips
  security_group_id = aws_security_group.router-backend_ithc_access[0].id
}
