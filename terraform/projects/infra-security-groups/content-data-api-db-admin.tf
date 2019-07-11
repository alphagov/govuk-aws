#
# == Manifest: Project: Security Groups: content-data-api-db-admin
#
# The content-data-api-db-admin needs to be accessible on ports:
#   - 22 from the other VMs
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_content-data-api-db-admin_id

resource "aws_security_group" "content-data-api-db-admin" {
  name        = "${var.stackname}_content-data-api-db-admin_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Security group for the Content Data API DB admin machine"

  tags {
    Name = "${var.stackname}_content-data-api-db-admin_access"
  }
}

resource "aws_security_group" "content-data-api-db-admin_ithc_access" {
  count       = "${length(var.ithc_access_ips) > 0 ? 1 : 0}"
  name        = "${var.stackname}_content-data-api-db-admin_ithc_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Control access to ITHC SSH"

  tags {
    Name = "${var.stackname}_content-data-api-db-admin_ithc_access"
  }
}

resource "aws_security_group_rule" "ithc_ingress_content-data-api-db-admin_ssh" {
  count             = "${length(var.ithc_access_ips) > 0 ? 1 : 0}"
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  cidr_blocks       = "${var.ithc_access_ips}"
  security_group_id = "${aws_security_group.content-data-api-db-admin_ithc_access.id}"
}
