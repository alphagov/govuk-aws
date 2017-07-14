#
# == Manifest: Project: Security Groups: backup
#
# The backup needs to be accessible on ports:
#   - 22/tcp
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_backup_id
# sg_backup_elb_id

resource "aws_security_group" "backup" {
  name        = "${var.stackname}_backup_access"
  vpc_id      = "${data.terraform_remote_state.govuk_vpc.vpc_id}"
  description = "Access to the backup host from its ELB"

  tags {
    Name = "${var.stackname}_backup_access"
  }
}

resource "aws_security_group_rule" "allow_backup_elb_in" {
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.backup.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.backup_elb.id}"
}

resource "aws_security_group" "backup_elb" {
  name        = "${var.stackname}_backup_elb_access"
  vpc_id      = "${data.terraform_remote_state.govuk_vpc.vpc_id}"
  description = "Access the backup ELB"

  tags {
    Name = "${var.stackname}_backup_elb_access"
  }
}

resource "aws_security_group_rule" "allow_management_to_backup_ssh_elb" {
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.backup_elb.id}"
  source_security_group_id = "${aws_security_group.management.id}"
}
