#
# == Manifest: Project: Security Groups: api-redis
#
# The api-redis needs to be accessible on ports:
#   - 6379 from search hosts (for rummager)
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_api-redis_id
#

resource "aws_security_group" "api-redis" {
  name        = "${var.stackname}_api-redis_access"
  vpc_id      = "${data.terraform_remote_state.govuk_vpc.vpc_id}"
  description = "Access to api-redis from its clients"

  tags {
    Name = "${var.stackname}_api-redis_access"
  }
}

# TODO: uncomment this once the search hosts exist
#resource "aws_security_group_rule" "allow_search_in" {
#  type      = "ingress"
#  from_port = 6379
#  to_port   = 6379
#  protocol  = "tcp"
#
#  # Which security group is the rule assigned to
#  security_group_id = "${aws_security_group.api-redis.id}"
#
#  # Which security group can use this rule
#  source_security_group_id = "${aws_security_group.logs-elasticsearch.id}"
#}

