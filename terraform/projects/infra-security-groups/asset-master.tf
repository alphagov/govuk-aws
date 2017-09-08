# == Manifest: Project: Security Groups: asset-master
#
# Asset Master does not need access from anything.
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_asset-master_id

resource "aws_security_group" "asset-master" {
  name        = "${var.stackname}_asset-master_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Security group for asset-master"

  tags {
    Name = "${var.stackname}_asset-master_access"
  }
}
