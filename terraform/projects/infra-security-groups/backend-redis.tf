#
# == Manifest: Project: Security Groups: backend-redis
#
# The backend-redis needs to be accessible on ports:
#   - 6379 from backend hosts
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_backend-redis_id
#

resource "aws_security_group" "backend-redis" {
  name        = "${var.stackname}_backend-redis_access"
  vpc_id      = "${data.terraform_remote_state.govuk_vpc.vpc_id}"
  description = "Access to backend-redis from its clients"

  tags {
    Name = "${var.stackname}_backend-redis_access"
  }
}

# TODO: uncomment this once the backend hosts exist
#resource "aws_security_group_rule" "allow_search_in" {
#  type      = "ingress"
#  from_port = 6379
#  to_port   = 6379
#  protocol  = "tcp"
#
#  # Which security group is the rule assigned to
#  security_group_id = "${aws_security_group.backend-redis.id}"
#
#  # Which security group can use this rule
#  source_security_group_id = "${aws_security_group.backend.id}"
#}

