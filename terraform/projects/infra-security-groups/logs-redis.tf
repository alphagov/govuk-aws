#
# == Manifest: Project: Security Groups: logs-redis
#
# The logging-elasticache needs to be accessible on ports:
#   - 6379 from the logs-elasticsearch and logging groups
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_logs-redis_id
#

resource "aws_security_group" "logs-redis" {
  name        = "${var.stackname}_logs-redis_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to logs-redis from its clients"

  tags {
    Name = "${var.stackname}_logs-redis_access"
  }
}

resource "aws_security_group_rule" "allow_logs-elasticsearch_in" {
  type      = "ingress"
  from_port = 6379
  to_port   = 6379
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.logs-redis.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.logs-elasticsearch.id}"
}

resource "aws_security_group_rule" "allow_logging_in" {
  type      = "ingress"
  from_port = 6379
  to_port   = 6379
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.logs-redis.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.logging.id}"
}

resource "aws_security_group_rule" "allow_management_to_logging_redis" {
  type      = "ingress"
  from_port = 6379
  to_port   = 6379
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.logs-redis.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.management.id}"
}
