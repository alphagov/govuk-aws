/**
 * ## Project: app-govuk-crawler-amazonmq
 * 
 */

terraform {
  backend "s3" {}
  required_version = ">= 1.1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    local = {
      version = "~> 2.2.3"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# --------------------------------------------------------------
# Generate passwords for the user accounts in the schema.json file
#
resource "random_password" "root" {
  length  = 24
  special = false
}
resource "random_password" "monitoring" {
  length  = 24
  special = false
}
resource "random_password" "govuk_crawler_worker" {
  length  = 24
  special = false
}

locals {
  govuk_crawler_amazonmq_passwords = {
    root                 = random_password.root.result
    monitoring           = random_password.monitoring.result
    govuk_crawler_worker = random_password.govuk_crawler_worker.result
  }
}

# --------------------------------------------------------------
# The AmazonMQ broker
resource "aws_mq_broker" "govuk_crawler_amazonmq" {
  broker_name = var.govuk_crawler_amazonmq_broker_name

  engine_type         = var.engine_type
  engine_version      = var.engine_version
  host_instance_type  = var.host_instance_type
  deployment_mode     = var.deployment_mode
  publicly_accessible = var.publicly_accessible
  # use the existing RabbitMQ security group
  security_groups = ["${data.terraform_remote_state.infra_security_groups.outputs.sg_rabbitmq_id}"]

  logs {
    general = true
  }

  # The Terraform provider will only allow us to create a single user
  # All other users must be added from the web UI
  user {
    console_access = true
    username       = "root"
    password       = local.govuk_crawler_amazonmq_passwords["root"]
  }
}

# --------------------------------------------------------------
# Security group rules

# Allow HTTPS access to GOV.UK Crawler's AmazonMQ from anything in the 'management' SG
# (i.e. all EC2 instances)
resource "aws_security_group_rule" "govukcrawleramazonmq_ingress_management_https" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  description = "HTTPS ingress for GOV.UK Crawler AmazonMQ"

  # Which security group is the rule assigned to
  security_group_id        = data.terraform_remote_state.infra_security_groups.outputs.sg_rabbitmq_id
  source_security_group_id = data.terraform_remote_state.infra_security_groups.outputs.sg_management_id
}
