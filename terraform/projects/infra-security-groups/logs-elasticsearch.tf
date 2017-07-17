#
# == Manifest: Project: Security Groups: logs-elasticsearch
#
# The logging-elasticsearch needs to be accessible on ports:
#   - 9200 from the logging group
#   - 9300 from other cluster members (in the same SG)
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_logs-elasticsearch_id
# sg_logs-elasticsearch_elb_id
#

resource "aws_security_group" "logs-elasticsearch" {
  name        = "${var.stackname}_logs-elasticsearch_access"
  vpc_id      = "${data.terraform_remote_state.govuk_vpc.vpc_id}"
  description = "Access to logs-elasticsearch"

  tags {
    Name = "${var.stackname}_logs-elasticsearch_access"
  }
}

# the nodes need to speak among themselves for clustering
resource "aws_security_group_rule" "allow_logs-elasticsearch_cluster_in" {
  type      = "ingress"
  from_port = 9300
  to_port   = 9300
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.logs-elasticsearch.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.logs-elasticsearch.id}"
}

resource "aws_security_group_rule" "logs-elasticsearch_elb_in" {
  type      = "ingress"
  from_port = 9200
  to_port   = 9200
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.logs-elasticsearch.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.logs-elasticsearch_elb.id}"
}

resource "aws_security_group" "logs-elasticsearch_elb" {
  name        = "${var.stackname}_logs-elasticsearch_elb_access"
  vpc_id      = "${data.terraform_remote_state.govuk_vpc.vpc_id}"
  description = "Access the logging ELB"

  tags {
    Name = "${var.stackname}_logs-elasticsearch_elb_access"
  }
}

resource "aws_security_group_rule" "allow_management_to_logs-elasticsearch_elb" {
  type      = "ingress"
  from_port = 9200
  to_port   = 9200
  protocol  = "tcp"

  security_group_id = "${aws_security_group.logs-elasticsearch_elb.id}"

  # TODO: does anything other than icinga and logging need this?
  source_security_group_id = "${aws_security_group.management.id}"
}

# TODO test whether egress rules are needed on ELBs
resource "aws_security_group_rule" "allow_logs-elasticsearch_elb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.logs-elasticsearch_elb.id}"
}
