#
# == Manifest: Project: Security Groups: elasticsearch6
#
# The elasticsearch cluster needs to be accessible on ports:
#   - 80 and 443 from 'calculators_frontend' (for licence-finder)
#   - 80 and 443 from 'search' (for search-api)
#   - 443 search-ltr-generation
#
# When both licence-finder and search-api are using https, the http
# rule can be removed.
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_elasticsearch6_id
#

resource "aws_security_group" "elasticsearch6" {
  name        = "${var.stackname}_elasticsearch6_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.outputs.vpc_id}"
  description = "Access to elasticsearch6"

  tags = {
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

resource "aws_security_group_rule" "elasticsearch6_ingress_calculators-frontend_elasticsearch-api-https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
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

resource "aws_security_group_rule" "elasticsearch6_ingress_search_elasticsearch-api-https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.elasticsearch6.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.search.id}"
}

resource "aws_security_group_rule" "elasticsearch6_ingress_search-ltr-generation_elasticsearch-api" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.elasticsearch6.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.search-ltr-generation.id}"
}

resource "aws_security_group_rule" "elasticsearch6_ingress_search-ltr-generation_elasticsearch-api-https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.elasticsearch6.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.search-ltr-generation.id}"
}
