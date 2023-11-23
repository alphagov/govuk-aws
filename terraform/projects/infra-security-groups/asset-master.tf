# == Manifest: Project: Security Groups: asset-master
#
# Asset Master does not need access from anything.
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_asset-master-efs_id
#
resource "aws_security_group" "asset-master-efs" {
  name        = "${var.stackname}_asset-master-efs_access"
  vpc_id      = data.terraform_remote_state.infra_vpc.outputs.vpc_id
  description = "Security group for asset-master EFS share"

  tags = {
    Name = "${var.stackname}_asset-master-efs_access"
  }
}
