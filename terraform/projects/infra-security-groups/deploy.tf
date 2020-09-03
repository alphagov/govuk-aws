#
# == Manifest: Project: Security Groups: deploy
#
# The puppetmaster needs to be accessible on ports:
#   - 443 from the other VMs
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_deploy_id
# sg_deploy_elb_id

resource "aws_security_group" "deploy" {
  name        = "${var.stackname}_deploy_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the deploy host from its ELB"

  tags {
    Name = "${var.stackname}_deploy_access"
  }
}

resource "aws_security_group_rule" "deploy_ingress_deploy-elb_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.deploy.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.deploy_elb.id}"
}

resource "aws_security_group_rule" "deploy_ingress_deploy-internal-elb_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.deploy.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.deploy_internal_elb.id}"
}

resource "aws_security_group" "deploy_elb" {
  name        = "${var.stackname}_deploy_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the deploy ELB"

  tags {
    Name = "${var.stackname}_deploy_elb_access"
  }
}

resource "aws_security_group_rule" "deploy-elb_ingress_office_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id = "${aws_security_group.deploy_elb.id}"
  cidr_blocks       = ["${var.office_ips}"]
}

# Allow Carrenza Integration and Production access to trigger automated deployments
resource "aws_security_group_rule" "deploy-elb_ingress_carrenza_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id = "${aws_security_group.deploy_elb.id}"
  cidr_blocks       = ["${var.carrenza_integration_ips}", "${var.carrenza_production_ips}"]
}

resource "aws_security_group_rule" "deploy-elb_ingress_aws_integration_access_https" {
  count     = "${(var.aws_environment == "integration") || (var.aws_environment == "staging") ? 1 : 0}"
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id = "${aws_security_group.deploy_elb.id}"
  cidr_blocks       = ["${var.aws_integration_external_nat_gateway_ips}"]
}

resource "aws_security_group_rule" "deploy-elb_ingress_aws_staging_access_https" {
  count     = "${var.aws_environment == "production" ? 1 : 0}"
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id = "${aws_security_group.deploy_elb.id}"
  cidr_blocks       = ["${var.aws_staging_external_nat_gateway_ips}"]
}

resource "aws_security_group_rule" "deploy-elb_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.deploy_elb.id}"
}

resource "aws_security_group_rule" "deploy-internal-elb_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.deploy_internal_elb.id}"
}

resource "aws_security_group" "deploy_internal_elb" {
  name        = "${var.stackname}_deploy_internal_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the deploy Internal ELB"

  tags {
    Name = "${var.stackname}_deploy_internal_elb_access"
  }
}

resource "aws_security_group_rule" "deploy-internal-elb_ingress_management_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.deploy_internal_elb.id}"
  source_security_group_id = "${aws_security_group.management.id}"
}
