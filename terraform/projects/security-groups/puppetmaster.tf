#
# == Manifest: Project: Security Groups: puppetmaster
#
# The puppetmaster needs to be accessible on ports:
#   - 8140 from the other VMs
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_puppetmaster_id

resource "aws_security_group" "puppetmaster" {
  name        = "${var.stackname}_puppetmaster_access"
  description = "Access to the puppetmaster on 8140 from the VPC"
}

# All VMs will need to talk to the puppetmaster.
resource "aws_security_group_rule" "allow_puppet_in" {
  type      = "ingress"
  from_port = 8140
  to_port   = 8140
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.puppetmaster.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.management.id}"
}
