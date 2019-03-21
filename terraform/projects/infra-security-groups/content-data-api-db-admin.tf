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
