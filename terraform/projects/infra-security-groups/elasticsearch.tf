#
# == Manifest: Project: Security Groups: elasticsearch
#
# The elasticsearch needs to be accessible on ports:
#   - 9200 from the search group
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_elasticsearch_id
#

resource "aws_security_group" "elasticsearch" {
  name        = "${var.stackname}_elasticsearch_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to elasticsearch"

  tags {
    Name = "${var.stackname}_elasticsearch_access"
  }
}

resource "aws_security_group_rule" "elasticsearch_ingress_search_elasticsearch-api" {
  type      = "ingress"
  from_port = 9200
  to_port   = 9200
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.rummager-elasticsearch.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.search.id}"
}
