resource "aws_security_group" "search-ltr-generation" {
  name = "search-ltr-generation_access"

  vpc_id = data.terraform_remote_state.infra_vpc.outputs.vpc_id

  tags = {
    Name = "search-ltr-generation"
  }
}

resource "aws_security_group_rule" "search-ltr-generation_ingress_jenkins_ssh" {
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 22
  to_port                  = 22
  source_security_group_id = aws_security_group.deploy.id

  security_group_id = aws_security_group.search-ltr-generation.id
}

resource "aws_security_group_rule" "search-ltr-generation_egress_any_any" {
  type        = "egress"
  protocol    = "-1"
  from_port   = 0
  to_port     = 0
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.search-ltr-generation.id
}
