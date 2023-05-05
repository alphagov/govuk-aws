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

  tags = {
    Project         = var.stackname
    aws_stackname   = var.stackname
    aws_environment = var.aws_environment
  }
}

# --------------------------------------------------------------
# Lookups to existing resources which we need to reference

# Look up the existing SSL certificate for internal-facing infra
data "aws_acm_certificate" "internal_cert" {
  domain   = var.elb_internal_certname
  statuses = ["ISSUED"]
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
  subnet_ids      = var.deployment_mode == "SINGLE_INSTANCE" ? [data.terraform_remote_state.infra_networking.outputs.private_subnet_ids[0]] : data.terraform_remote_state.infra_networking.outputs.private_subnet_ids

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

# existing RabbitMQ runs on port 5672, this AmazonMQ will be on port 5671
# so we need to allow that through the SG
resource "aws_security_group_rule" "govukcrawleramazonmq_ingress_management_amqps" {
  type        = "ingress"
  from_port   = 5671
  to_port     = 5671
  protocol    = "tcp"
  description = "AMQPS ingress for GOV.UK Crawler AmazonMQ"

  # Which security group is the rule assigned to
  security_group_id        = data.terraform_remote_state.infra_security_groups.outputs.sg_rabbitmq_id
  source_security_group_id = data.terraform_remote_state.infra_security_groups.outputs.sg_management_id
}

# allow outgoing traffic to anything within the same SG
resource "aws_security_group_rule" "rabbitmq_egress_self_self" {
  type      = "egress"
  from_port = 0
  to_port   = 0
  protocol  = "-1"

  source_security_group_id = data.terraform_remote_state.infra_security_groups.outputs.sg_rabbitmq_id
  security_group_id        = data.terraform_remote_state.infra_security_groups.outputs.sg_rabbitmq_id
}


# --------------------------------------------------------------
# Network Load Balancer

resource "aws_lb" "govukcrawlermq_lb_internal" {
  name               = "govukcrawleramazonmq-lb-internal"
  internal           = true
  load_balancer_type = "network"
  subnets            = aws_mq_broker.govuk_crawler_amazonmq.subnet_ids

  access_logs {
    bucket = data.terraform_remote_state.infra_monitoring.outputs.aws_logging_bucket_id
    prefix = "lb/${var.stackname}-govukcrawleramazonmq-internal-lb"
  }

  enable_deletion_protection = var.lb_delete_protection

  tags = {
    "Name"            = "${var.stackname}-govukcrawleramazonmq-internal"
    "Project"         = var.stackname
    "aws_environment" = var.aws_environment
    "aws_migration"   = "govukcrawleramazonmq"
  }
}

# HTTPS listener for web admin UI traffic
resource "aws_lb_listener" "internal_https" {
  load_balancer_arn = aws_lb.govukcrawlermq_lb_internal.arn
  port              = "443"
  protocol          = "TLS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = data.aws_acm_certificate.internal_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.internal_https.arn
  }
}

# AMQPS listener for port 5671 traffic
resource "aws_lb_listener" "internal_amqps" {
  load_balancer_arn = aws_lb.govukcrawlermq_lb_internal.arn
  port              = "5671"
  protocol          = "TLS"
  certificate_arn   = data.aws_acm_certificate.internal_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.internal_amqps.arn
  }
}

# HTTPS target group for web admin UI traffic
resource "aws_lb_target_group" "internal_https" {
  name        = "govukcrawlermq-lb-internal-https"
  target_type = "ip"
  port        = 443
  protocol    = "TLS"
  vpc_id      = data.terraform_remote_state.infra_vpc.outputs.vpc_id

  health_check {
    path     = "/"
    protocol = "HTTPS"
  }
}

# AMQPS target group for port 5671 traffic
resource "aws_lb_target_group" "internal_amqps" {
  name        = "govukcrawlermq-lb-internal-amqps"
  target_type = "ip"
  port        = 5671
  protocol    = "TLS"
  vpc_id      = data.terraform_remote_state.infra_vpc.outputs.vpc_id

  # Use port 443 HTTPS for the healthcheck, as the LB
  # won't get a recognisable response on port 5671
  health_check {
    path     = "/"
    port     = 443
    protocol = "HTTPS"
  }
}
