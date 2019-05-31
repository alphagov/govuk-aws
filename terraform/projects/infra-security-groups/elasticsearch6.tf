#
# == Manifest: Project: Security Groups: elasticsearch6
#
# The elasticsearch cluster needs to be accessible on ports:
#   - 80 from 'calculators_frontend' (for licence-finder)
#   - 80 from 'search' (for search-api)
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_elasticsearch6_id
#

resource "aws_security_group" "elasticsearch6" {
  name        = "${var.stackname}_elasticsearch6_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to elasticsearch6"

  tags {
    Name = "${var.stackname}_elasticsearch6_access"
  }
}

resource "aws_security_group_rule" "elasticsearch6_ingress_calculators-frontend_elasticsearch-api" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.elasticsearch6.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.calculators-frontend.id}"
}

resource "aws_security_group_rule" "elasticsearch6_ingress_search_elasticsearch-api" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.elasticsearch6.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.search.id}"
}
