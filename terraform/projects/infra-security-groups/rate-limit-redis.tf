#
# == Manifest: Project: Security Groups: rate-limit-redis
#
# The rate-limit-redis needs to be accessible on ports:
#   - 6379 from frontend hosts
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_rate-limit-redis_id
#

resource "aws_security_group" "rate-limit-redis" {
  name        = "${var.stackname}_rate-limit-redis_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to rate-limit-redis from its clients"

  tags {
    Name = "${var.stackname}_rate-limit-redis_access"
  }
}

resource "aws_security_group_rule" "rate-limit-redis_ingress_frontend_redis" {
  type      = "ingress"
  from_port = 6379
  to_port   = 6379
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.rate-limit-redis.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.frontend.id}"
}
