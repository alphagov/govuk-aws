# == Manifest: Project: Security Groups: mirrorer
#
# Mirrorer is standalone, and doesn't require access from anything.
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_mirrorer_id

resource "aws_security_group" "mirrorer" {
  name        = "${var.stackname}_mirrorer_access"
  vpc_id      = data.terraform_remote_state.infra_vpc.outputs.vpc_id
  description = "Security group for mirrorer"

  tags = {
    Name = "${var.stackname}_mirrorer_access"
  }
}
