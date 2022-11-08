#
# == Manifest: Project: Security Groups: ci-agents
#
# The ci-agents needs to be accessible on ports:
#   - 443 from the other VMs
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_ci-agent-1_id
# sg_ci-agent-1_elb_id

/////////////////////ci-agent-1/////////////////////////////////////////////////

resource "aws_security_group" "ci-agent-1" {
  count       = "${var.aws_environment == "integration" ? 1 : 0}"
  name        = "${var.stackname}_ci-agent-1_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the ci-agent-1 host from its ELB"

  tags {
    Name = "${var.stackname}_ci-agent-1_access"
  }
}

resource "aws_security_group_rule" "ci-agent-1_ingress_ci-agent-1-elb_ssh_tcp" {
  count     = "${var.aws_environment == "integration" ? 1 : 0}"
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.ci-agent-1.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.ci-agent-1_elb.id}"
}

resource "aws_security_group_rule" "ci-agent-1_ingress_ci-agent-1-ci_master_ssh_tcp" {
  count     = "${var.aws_environment == "integration" ? 1 : 0}"
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.ci-agent-1.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.ci-master.id}"
}

resource "aws_security_group" "ci-agent-1_elb" {
  count       = "${var.aws_environment == "integration" ? 1 : 0}"
  name        = "${var.stackname}_ci-agent-1_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the CI agent 1 ELB"

  tags {
    Name = "${var.stackname}_ci-agent-1_elb_access"
  }
}

resource "aws_security_group_rule" "ci-agent-1-elb_ingress_management_https" {
  count     = "${var.aws_environment == "integration" ? 1 : 0}"
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.ci-agent-1_elb.id}"
  source_security_group_id = "${aws_security_group.management.id}"
}

resource "aws_security_group_rule" "ci-agent-1-elb_ingress_ci-master_ssh_tcp" {
  count     = "${var.aws_environment == "integration" ? 1 : 0}"
  type      = "ingress"
  from_port = 0
  to_port   = 22
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.ci-agent-1_elb.id}"
  source_security_group_id = "${aws_security_group.ci-master.id}"
}

resource "aws_security_group_rule" "ci-agent-1-elb_egress_any_any" {
  count             = "${var.aws_environment == "integration" ? 1 : 0}"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.ci-agent-1_elb.id}"
}

/////////////////////ci-agent-2/////////////////////////////////////////////////

resource "aws_security_group" "ci-agent-2" {
  count       = "${var.aws_environment == "integration" ? 1 : 0}"
  name        = "${var.stackname}_ci-agent-2_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the ci-agent-2 host from its ELB"

  tags {
    Name = "${var.stackname}_ci-agent-2_access"
  }
}

resource "aws_security_group_rule" "ci-agent-2_ingress_ci-agent-2-elb_ssh_tcp" {
  count     = "${var.aws_environment == "integration" ? 1 : 0}"
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.ci-agent-2.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.ci-agent-2_elb.id}"
}

resource "aws_security_group_rule" "ci-agent-2_ingress_ci-agent-2-ci_master_ssh_tcp" {
  count     = "${var.aws_environment == "integration" ? 1 : 0}"
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.ci-agent-2.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.ci-master.id}"
}

resource "aws_security_group" "ci-agent-2_elb" {
  count       = "${var.aws_environment == "integration" ? 1 : 0}"
  name        = "${var.stackname}_ci-agent-2_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the CI agent 2 ELB"

  tags {
    Name = "${var.stackname}_ci-agent-2_elb_access"
  }
}

resource "aws_security_group_rule" "ci-agent-2-elb_ingress_management_https" {
  count     = "${var.aws_environment == "integration" ? 1 : 0}"
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.ci-agent-2_elb.id}"
  source_security_group_id = "${aws_security_group.management.id}"
}

resource "aws_security_group_rule" "ci-agent-2-elb_ingress_ci-master_ssh_tcp" {
  count     = "${var.aws_environment == "integration" ? 1 : 0}"
  type      = "ingress"
  from_port = 0
  to_port   = 22
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.ci-agent-2_elb.id}"
  source_security_group_id = "${aws_security_group.ci-master.id}"
}

resource "aws_security_group_rule" "ci-agent-2-elb_egress_any_any" {
  count             = "${var.aws_environment == "integration" ? 1 : 0}"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.ci-agent-2_elb.id}"
}

/////////////////////ci-agent-3/////////////////////////////////////////////////

resource "aws_security_group" "ci-agent-3" {
  count       = "${var.aws_environment == "integration" ? 1 : 0}"
  name        = "${var.stackname}_ci-agent-3_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the ci-agent-3 host from its ELB"

  tags {
    Name = "${var.stackname}_ci-agent-3_access"
  }
}

resource "aws_security_group_rule" "ci-agent-3_ingress_ci-agent-3-elb_ssh_tcp" {
  count     = "${var.aws_environment == "integration" ? 1 : 0}"
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.ci-agent-3.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.ci-agent-3_elb.id}"
}

resource "aws_security_group_rule" "ci-agent-3_ingress_ci-agent-3-ci_master_ssh_tcp" {
  count     = "${var.aws_environment == "integration" ? 1 : 0}"
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.ci-agent-3.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.ci-master.id}"
}

resource "aws_security_group" "ci-agent-3_elb" {
  count       = "${var.aws_environment == "integration" ? 1 : 0}"
  name        = "${var.stackname}_ci-agent-3_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the CI agent 3 ELB"

  tags {
    Name = "${var.stackname}_ci-agent-3_elb_access"
  }
}

resource "aws_security_group_rule" "ci-agent-3-elb_ingress_management_https" {
  count     = "${var.aws_environment == "integration" ? 1 : 0}"
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.ci-agent-3_elb.id}"
  source_security_group_id = "${aws_security_group.management.id}"
}

resource "aws_security_group_rule" "ci-agent-3-elb_ingress_ci-master_ssh_tcp" {
  count     = "${var.aws_environment == "integration" ? 1 : 0}"
  type      = "ingress"
  from_port = 0
  to_port   = 22
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.ci-agent-3_elb.id}"
  source_security_group_id = "${aws_security_group.ci-master.id}"
}

resource "aws_security_group_rule" "ci-agent-3-elb_egress_any_any" {
  count             = "${var.aws_environment == "integration" ? 1 : 0}"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.ci-agent-3_elb.id}"
}

/////////////////////ci-agent-4/////////////////////////////////////////////////

resource "aws_security_group" "ci-agent-4" {
  count       = "${var.aws_environment == "integration" ? 1 : 0}"
  name        = "${var.stackname}_ci-agent-4_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the ci-agent-4 host from its ELB"

  tags {
    Name = "${var.stackname}_ci-agent-4_access"
  }
}

resource "aws_security_group_rule" "ci-agent-4_ingress_ci-agent-4-elb_ssh_tcp" {
  count     = "${var.aws_environment == "integration" ? 1 : 0}"
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.ci-agent-4.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.ci-agent-4_elb.id}"
}

resource "aws_security_group_rule" "ci-agent-4_ingress_ci-agent-4-ci_master_ssh_tcp" {
  count     = "${var.aws_environment == "integration" ? 1 : 0}"
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.ci-agent-4.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.ci-master.id}"
}

resource "aws_security_group" "ci-agent-4_elb" {
  count       = "${var.aws_environment == "integration" ? 1 : 0}"
  name        = "${var.stackname}_ci-agent-4_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the CI agent 4 ELB"

  tags {
    Name = "${var.stackname}_ci-agent-4_elb_access"
  }
}

resource "aws_security_group_rule" "ci-agent-4-elb_ingress_management_https" {
  count     = "${var.aws_environment == "integration" ? 1 : 0}"
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.ci-agent-4_elb.id}"
  source_security_group_id = "${aws_security_group.management.id}"
}

resource "aws_security_group_rule" "ci-agent-4-elb_ingress_ci-master_ssh_tcp" {
  count     = "${var.aws_environment == "integration" ? 1 : 0}"
  type      = "ingress"
  from_port = 0
  to_port   = 22
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.ci-agent-4_elb.id}"
  source_security_group_id = "${aws_security_group.ci-master.id}"
}

resource "aws_security_group_rule" "ci-agent-4-elb_egress_any_any" {
  count             = "${var.aws_environment == "integration" ? 1 : 0}"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.ci-agent-4_elb.id}"
}

/////////////////////ci-agent-5/////////////////////////////////////////////////

resource "aws_security_group" "ci-agent-5" {
  count       = "${var.aws_environment == "integration" ? 1 : 0}"
  name        = "${var.stackname}_ci-agent-5_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the ci-agent-5 host from its ELB"

  tags {
    Name = "${var.stackname}_ci-agent-5_access"
  }
}

resource "aws_security_group_rule" "ci-agent-5_ingress_ci-agent-5-elb_ssh_tcp" {
  count     = "${var.aws_environment == "integration" ? 1 : 0}"
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.ci-agent-5.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.ci-agent-5_elb.id}"
}

resource "aws_security_group_rule" "ci-agent-5_ingress_ci-agent-5-ci_master_ssh_tcp" {
  count     = "${var.aws_environment == "integration" ? 1 : 0}"
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.ci-agent-5.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.ci-master.id}"
}

resource "aws_security_group" "ci-agent-5_elb" {
  count       = "${var.aws_environment == "integration" ? 1 : 0}"
  name        = "${var.stackname}_ci-agent-5_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the CI agent 5 ELB"

  tags {
    Name = "${var.stackname}_ci-agent-5_elb_access"
  }
}

resource "aws_security_group_rule" "ci-agent-5-elb_ingress_management_https" {
  count     = "${var.aws_environment == "integration" ? 1 : 0}"
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.ci-agent-5_elb.id}"
  source_security_group_id = "${aws_security_group.management.id}"
}

resource "aws_security_group_rule" "ci-agent-5-elb_ingress_ci-master_ssh_tcp" {
  count     = "${var.aws_environment == "integration" ? 1 : 0}"
  type      = "ingress"
  from_port = 0
  to_port   = 22
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.ci-agent-5_elb.id}"
  source_security_group_id = "${aws_security_group.ci-master.id}"
}

resource "aws_security_group_rule" "ci-agent-5-elb_egress_any_any" {
  count             = "${var.aws_environment == "integration" ? 1 : 0}"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.ci-agent-5_elb.id}"
}

/////////////////////ci-agent-6/////////////////////////////////////////////////

resource "aws_security_group" "ci-agent-6" {
  count       = "${var.aws_environment == "integration" ? 1 : 0}"
  name        = "${var.stackname}_ci-agent-6_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the ci-agent-6 host from its ELB"

  tags {
    Name = "${var.stackname}_ci-agent-6_access"
  }
}

resource "aws_security_group_rule" "ci-agent-6_ingress_ci-agent-6-elb_ssh_tcp" {
  count     = "${var.aws_environment == "integration" ? 1 : 0}"
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.ci-agent-6.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.ci-agent-6_elb.id}"
}

resource "aws_security_group_rule" "ci-agent-6_ingress_ci-agent-6-ci_master_ssh_tcp" {
  count     = "${var.aws_environment == "integration" ? 1 : 0}"
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.ci-agent-6.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.ci-master.id}"
}

resource "aws_security_group" "ci-agent-6_elb" {
  count       = "${var.aws_environment == "integration" ? 1 : 0}"
  name        = "${var.stackname}_ci-agent-6_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the CI agent 6 ELB"

  tags {
    Name = "${var.stackname}_ci-agent-6_elb_access"
  }
}

resource "aws_security_group_rule" "ci-agent-6-elb_ingress_management_https" {
  count     = "${var.aws_environment == "integration" ? 1 : 0}"
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.ci-agent-6_elb.id}"
  source_security_group_id = "${aws_security_group.management.id}"
}

resource "aws_security_group_rule" "ci-agent-6-elb_ingress_ci-master_ssh_tcp" {
  count     = "${var.aws_environment == "integration" ? 1 : 0}"
  type      = "ingress"
  from_port = 0
  to_port   = 22
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.ci-agent-6_elb.id}"
  source_security_group_id = "${aws_security_group.ci-master.id}"
}

resource "aws_security_group_rule" "ci-agent-6-elb_egress_any_any" {
  count             = "${var.aws_environment == "integration" ? 1 : 0}"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.ci-agent-6_elb.id}"
}

/////////////////////ci-agent-7/////////////////////////////////////////////////

resource "aws_security_group" "ci-agent-7" {
  count       = "${var.aws_environment == "integration" ? 1 : 0}"
  name        = "${var.stackname}_ci-agent-7_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the ci-agent-7 host from its ELB"

  tags {
    Name = "${var.stackname}_ci-agent-7_access"
  }
}

resource "aws_security_group_rule" "ci-agent-7_ingress_ci-agent-7-elb_ssh_tcp" {
  count     = "${var.aws_environment == "integration" ? 1 : 0}"
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.ci-agent-7.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.ci-agent-7_elb.id}"
}

resource "aws_security_group_rule" "ci-agent-7_ingress_ci-agent-7-ci_master_ssh_tcp" {
  count     = "${var.aws_environment == "integration" ? 1 : 0}"
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.ci-agent-7.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.ci-master.id}"
}

resource "aws_security_group" "ci-agent-7_elb" {
  count       = "${var.aws_environment == "integration" ? 1 : 0}"
  name        = "${var.stackname}_ci-agent-7_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the CI agent 7 ELB"

  tags {
    Name = "${var.stackname}_ci-agent-7_elb_access"
  }
}

resource "aws_security_group_rule" "ci-agent-7-elb_ingress_management_https" {
  count     = "${var.aws_environment == "integration" ? 1 : 0}"
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.ci-agent-7_elb.id}"
  source_security_group_id = "${aws_security_group.management.id}"
}

resource "aws_security_group_rule" "ci-agent-7-elb_ingress_ci-master_ssh_tcp" {
  count     = "${var.aws_environment == "integration" ? 1 : 0}"
  type      = "ingress"
  from_port = 0
  to_port   = 22
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.ci-agent-7_elb.id}"
  source_security_group_id = "${aws_security_group.ci-master.id}"
}

resource "aws_security_group_rule" "ci-agent-7-elb_egress_any_any" {
  count             = "${var.aws_environment == "integration" ? 1 : 0}"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.ci-agent-7_elb.id}"
}

/////////////////////ci-agent-8/////////////////////////////////////////////////

resource "aws_security_group" "ci-agent-8" {
  count       = "${var.aws_environment == "integration" ? 1 : 0}"
  name        = "${var.stackname}_ci-agent-8_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the ci-agent-8 host from its ELB"

  tags {
    Name = "${var.stackname}_ci-agent-8_access"
  }
}

resource "aws_security_group_rule" "ci-agent-8_ingress_ci-agent-8-elb_ssh_tcp" {
  count     = "${var.aws_environment == "integration" ? 1 : 0}"
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.ci-agent-8.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.ci-agent-8_elb.id}"
}

resource "aws_security_group_rule" "ci-agent-8_ingress_ci-agent-8-ci_master_ssh_tcp" {
  count     = "${var.aws_environment == "integration" ? 1 : 0}"
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.ci-agent-8.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.ci-master.id}"
}

resource "aws_security_group" "ci-agent-8_elb" {
  count       = "${var.aws_environment == "integration" ? 1 : 0}"
  name        = "${var.stackname}_ci-agent-8_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the CI agent 8 ELB"

  tags {
    Name = "${var.stackname}_ci-agent-8_elb_access"
  }
}

resource "aws_security_group_rule" "ci-agent-8-elb_ingress_management_https" {
  count     = "${var.aws_environment == "integration" ? 1 : 0}"
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.ci-agent-8_elb.id}"
  source_security_group_id = "${aws_security_group.management.id}"
}

resource "aws_security_group_rule" "ci-agent-8-elb_ingress_ci-master_ssh_tcp" {
  count     = "${var.aws_environment == "integration" ? 1 : 0}"
  type      = "ingress"
  from_port = 0
  to_port   = 22
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.ci-agent-8_elb.id}"
  source_security_group_id = "${aws_security_group.ci-master.id}"
}

resource "aws_security_group_rule" "ci-agent-8-elb_egress_any_any" {
  count             = "${var.aws_environment == "integration" ? 1 : 0}"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.ci-agent-8_elb.id}"
}
