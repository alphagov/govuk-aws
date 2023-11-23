#
# == Manifest: Project: Security Groups: search
#
# The search needs to be accessible on ports:
#   - 443 from the other VMs
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_search_id
# sg_search_elb_id

resource "aws_security_group" "search" {
  name        = "${var.stackname}_search_access"
  vpc_id      = data.terraform_remote_state.infra_vpc.outputs.vpc_id
  description = "Access to the search host from its ELB"

  tags = {
    Name = "${var.stackname}_search_access"
  }
}

resource "aws_security_group" "search_ithc_access" {
  count       = length(var.ithc_access_ips) > 0 ? 1 : 0
  name        = "${var.stackname}_search_ithc_access"
  vpc_id      = data.terraform_remote_state.infra_vpc.outputs.vpc_id
  description = "Control access to ITHC SSH"

  tags = {
    Name = "${var.stackname}_search_ithc_access"
  }
}

resource "aws_security_group_rule" "ithc_ingress_search_ssh" {
  count             = length(var.ithc_access_ips) > 0 ? 1 : 0
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  cidr_blocks       = var.ithc_access_ips
  security_group_id = aws_security_group.search_ithc_access[0].id
}
