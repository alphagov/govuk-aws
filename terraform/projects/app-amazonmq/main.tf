/**
 * ## Project: app-backend
 * 
 * Module app-amazonmq creates an Amazon MQ instance or cluster for GOV.UK.
 * It uses remote state from the infra-vpc and infra-security-groups modules.
 *
 * The Terraform provider will only allow us to create a single user, so all 
 * other users must be added from the RabbitMQ web admin UI.
 */
terraform {
  backend "s3" {}
  required_version = ">= 1.1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# --------------------------------------------------------------
resource "aws_mq_broker" "publishing_amazonmq" {
  broker_name = "PublishingMQ"

  engine_type         = var.engine_type
  engine_version      = var.engine_version
  deployment_mode     = var.deployment_mode
  host_instance_type  = var.host_instance_type
  publicly_accessible = var.publicly_accessible
  security_groups     = ["${aws_security_group.amazonmq.id}"]
  subnet_ids = var.deployment_mode == "SINGLE_INSTANCE" ? [data.terraform_remote_state.infra_networking.outputs.private_subnet_ids[0]] : data.terraform_remote_state.infra_networking.outputs.private_subnet_ids

  # The Terraform provider will only allow us to create a single user
  # All other users must be added from the web UI 
  user {
    console_access = true
    username       = "root"
    password       = var.amazonmq_root_password
  }

}


resource "aws_security_group" "amazonmq" {
  name        = "${var.stackname}_amazonmq_access"
  vpc_id      = data.terraform_remote_state.infra_vpc.outputs.vpc_id
  description = "Access to Amazonmq from named SGs"

  tags = {
    Name = "${var.stackname}_amazonmq_access"
  }
}

resource "aws_security_group_rule" "amazonmq_ingress_management_amqp" {
  type      = "ingress"
  from_port = 5672
  to_port   = 5672
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = aws_security_group.amazonmq.id

  # Which security group can use this rule
  source_security_group_id = data.terraform_remote_state.infra_security_groups.outputs.sg_management_id
}


resource "aws_security_group_rule" "amazonmq_ingress_management_stomp" {
  type      = "ingress"
  from_port = 6163
  to_port   = 6163
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = aws_security_group.amazonmq.id

  # Which security group can use this rule
  source_security_group_id = data.terraform_remote_state.infra_security_groups.outputs.sg_management_id
}

resource "aws_security_group_rule" "amazonmq_ingress_any_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = aws_security_group.amazonmq.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "amazonmq_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.amazonmq.id
}


# --------------------------------------------------------------  
data "aws_route53_zone" "internal" {
  name         = var.internal_zone_name
  private_zone = true
}

# internal_domain_name is ${var.stackname}.${internal_root_domain_name}
resource "aws_route53_record" "amazonmq_internal_root_domain_name" {
  zone_id = data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_zone_id
  name    = "${aws_mq_broker.publishing_amazonmq.broker_name}.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"
  type    = "CNAME"
  # records = [aws_mq_broker.publishing_amazonmq.instances.0.ip_address]
  ttl     = 300
  records = [regex("://([^/:]+)", aws_mq_broker.publishing_amazonmq.instances.0.console_url)[0]]

}
