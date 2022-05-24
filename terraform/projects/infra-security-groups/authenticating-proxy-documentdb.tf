#
# == Manifest: Project: Security Groups: authenticating_proxy_documentdb
#
# === Variables:
# stackname - string
#
# === Outputs:
#
#

resource "aws_security_group" "authenticating-proxy-documentdb" {
  name        = "${var.stackname}_authenticating_proxy_documentdb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to Authenticating Proxy Documentdb from its clients"

  tags {
    Name = "${var.stackname}_authenticating_proxy_documentdb_access"
  }
}

resource "aws_security_group_rule" "authenticating-proxy-documentdb_ingress_db-admin_mongodb" {
  type      = "ingress"
  from_port = 27017
  to_port   = 27017
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.authenticating-proxy-documentdb.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.db-admin.id}"
}

# Allow authenticating proxy apps on backend machines to access the authenticating proxy documentdb cluster
resource "aws_security_group_rule" "authenticating-proxy-documentdb_ingress_backend_authenticating_proxy_apps" {
  type      = "ingress"
  from_port = 27017
  to_port   = 27017
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.authenticating-proxy-documentdb.id}"

  # Which security group can use this rule
  # When a specialised authenticating proxy backend groups is made, update this to
  # lock it down to just that, not all apps in the draft-cache group
  # source_security_group_id = "${aws_security_group.authenticating-proxy-backend.id}"
  source_security_group_id = "${aws_security_group.draft-cache.id}"
}
