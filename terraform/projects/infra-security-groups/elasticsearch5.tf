#
# == Manifest: Project: Security Groups: elasticsearch5
#
# The elasticsearch cluster needs to be accessible on ports:
#   - 80 from 'calculators_frontend' (for licence-finder)
#   - 80 from 'search' (for search-api)
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_elasticsearch5_id
#

resource "aws_security_group" "elasticsearch5" {
  name        = "${var.stackname}_elasticsearch5_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to elasticsearch5"

  tags {
    Name = "${var.stackname}_elasticsearch5_access"
  }
}

resource "aws_security_group_rule" "elasticsearch5_ingress_calculators-frontend_elasticsearch-api" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.elasticsearch5.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.calculators-frontend.id}"
}

resource "aws_security_group_rule" "elasticsearch5_ingress_search_elasticsearch-api" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.elasticsearch5.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.search.id}"
}
