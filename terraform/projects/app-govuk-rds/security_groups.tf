resource "aws_security_group" "rds" {
  for_each = var.databases

  name        = "${var.stackname}_${each.value.name}_rds_access"
  vpc_id      = data.terraform_remote_state.infra_vpc.outputs.vpc_id
  description = "Access to ${each.value.name} RDS"

  tags = merge(local.tags, { Name = "${var.stackname}_${each.value.name}_rds_access" })
}

resource "aws_security_group" "db_admin" {
  for_each = var.databases

  name        = "${var.stackname}_${each.value.name}_db-admin_access"
  vpc_id      = data.terraform_remote_state.infra_vpc.outputs.vpc_id
  description = "Access to ${each.value.name} db-admin"

  tags = merge(local.tags, { Name = "${var.stackname}_${each.value.name}_db-admin_access" })
}

resource "aws_security_group_rule" "rds_ingress_db-admin_postgres" {
  for_each = { for name, config in var.databases : name => config if config.engine == "postgres" }

  type      = "ingress"
  from_port = 5432
  to_port   = 5432
  protocol  = "tcp"

  security_group_id        = aws_security_group.rds[each.key].id
  source_security_group_id = aws_security_group.db_admin[each.key].id
}

resource "aws_security_group_rule" "rds_ingress_db-admin_mysql" {
  for_each = { for name, config in var.databases : name => config if config.engine == "mysql" }

  type      = "ingress"
  from_port = 3306
  to_port   = 3306
  protocol  = "tcp"

  security_group_id        = aws_security_group.rds[each.key].id
  source_security_group_id = aws_security_group.db_admin[each.key].id
}

resource "aws_security_group_rule" "db-admin_ingress_management_ssh" {
  for_each = var.databases

  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"

  security_group_id        = aws_security_group.db_admin[each.key].id
  source_security_group_id = data.terraform_remote_state.infra_security_groups.outputs.sg_management_id
}

resource "aws_security_group_rule" "db-admin_egress_any_any" {
  for_each = var.databases

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.db_admin[each.key].id
}
