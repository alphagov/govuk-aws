# == Manifest: Project: Security Groups: asset-master
#
# Asset Master does not need access from anything.
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_asset-master_id
# sg_asset-master-efs_id
#
resource "aws_security_group" "asset-master" {
  name        = "${var.stackname}_asset-master_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Security group for asset-master"

  tags {
    Name = "${var.stackname}_asset-master_access"
  }
}

resource "aws_security_group" "asset-master-efs" {
  name        = "${var.stackname}_asset-master-efs_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Security group for asset-master EFS share"

  tags {
    Name = "${var.stackname}_asset-master-efs_access"
  }
}

# Allow both TCP and UDP for NFS
resource "aws_security_group_rule" "asset-master-efs_ingress_asset-master_nfs" {
  type      = "ingress"
  from_port = 111
  to_port   = 111
  protocol  = "all"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.asset-master-efs.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.asset-master.id}"
}

# Allow both TCP and UDP for NFS
resource "aws_security_group_rule" "asset-master-efs_ingress_backend_nfs" {
  type      = "ingress"
  from_port = 111
  to_port   = 111
  protocol  = "all"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.asset-master-efs.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.backend.id}"
}

# Allow both TCP and UDP for NFS
resource "aws_security_group_rule" "asset-master-efs_ingress_whitehall-backend_nfs" {
  type      = "ingress"
  from_port = 111
  to_port   = 111
  protocol  = "all"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.asset-master-efs.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.whitehall-backend.id}"
}
