/**
 * ## Project: app-publishing-amazonmq
 * 
 * Project app-publishing-amazonmq creates an Amazon MQ instance or cluster for GOV.UK.
 * It uses remote state from the infra-vpc and infra-security-groups modules.
 *
 * The Terraform provider will only allow us to create a single user, so all 
 * other users must be added from the RabbitMQ web admin UI or REST API.
 * 
 * DO NOT USE IN PRODUCTION YET - this version is integration-only, as it
 * implicitly assumes a single instance, and will need reworking for a 
 * highly-available cluster setup 
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
# Generate passwords for the user accounts
#
resource "random_password" "root" {
  length  = 24
  special = false
}
resource "random_password" "monitoring" {
  length  = 24
  special = false
}
resource "random_password" "publishing_api" {
  length  = 24
  special = false
}
resource "random_password" "search_api" {
  length  = 24
  special = false
}
resource "random_password" "content_data_api" {
  length  = 24
  special = false
}
resource "random_password" "email_alert_service" {
  length  = 24
  special = false
}
resource "random_password" "cache_clearing_service" {
  length  = 24
  special = false
}

locals {
  publishing_amazonmq_passwords = {
    root                   = random_password.root.result
    monitoring             = random_password.monitoring.result
    publishing_api         = random_password.publishing_api.result
    search_api             = random_password.search_api.result
    content_data_api       = random_password.content_data_api.result
    email_alert_service    = random_password.email_alert_service.result
    cache_clearing_service = random_password.cache_clearing_service.result
  }

  tags = {
    Project         = var.stackname
    aws_stackname   = var.stackname
    aws_environment = var.aws_environment
  }
}
# --------------------------------------------------------------
# Lookups to existing resources which we need to reference

data "aws_subnet" "lb_subnets" {
  count = var.publishing_amazonmq_instance_count
  id    = sort(tolist(aws_mq_broker.publishing_amazonmq.subnet_ids))[count.index]
}

# Look up the existing SSL certificate for internal-facing infra
data "aws_acm_certificate" "internal_cert" {
  domain   = var.elb_internal_certname
  statuses = ["ISSUED"]
}

# The ip_address attributes of the AmazonMQ instances are blank in the outputs
# (see https://stackoverflow.com/a/69221987)
# So the only way we can get the IPs in order to add them to the 
# Load Balancer target group, is by a DNS lookup
data "dns_a_record_set" "mq_instances" {
  host = regex("://([^/:]+)", aws_mq_broker.publishing_amazonmq.instances.0.console_url)[0]
}

# --------------------------------------------------------------
# The broker itself
resource "aws_mq_broker" "publishing_amazonmq" {
  broker_name = var.publishing_amazonmq_broker_name

  engine_type         = var.engine_type
  engine_version      = var.engine_version
  deployment_mode     = var.deployment_mode
  host_instance_type  = var.host_instance_type
  publicly_accessible = var.publicly_accessible
  # use the existing RabbitMQ security group. We can move it
  # over to this module at the point of migration
  security_groups = ["${data.terraform_remote_state.infra_security_groups.outputs.sg_rabbitmq_id}"]
  subnet_ids      = var.deployment_mode == "SINGLE_INSTANCE" ? [data.terraform_remote_state.infra_networking.outputs.private_subnet_ids[0]] : data.terraform_remote_state.infra_networking.outputs.private_subnet_ids

  # The Terraform provider will only allow us to create a single user
  # All other users must be added from the web UI 
  user {
    console_access = true
    username       = "root"
    password       = local.publishing_amazonmq_passwords["root"]
  }

}

# --------------------------------------------------------------
# Security group rules

# Allow HTTPS access to Publishing's AmazonMQ from anything in the 'management' SG
# (i.e. all EC2 instances)
resource "aws_security_group_rule" "publishingamazonmq_ingress_management_https" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  description = "HTTPS ingress for Publishing AmazonMQ"

  # Which security group is the rule assigned to
  security_group_id        = data.terraform_remote_state.infra_security_groups.outputs.sg_rabbitmq_id
  source_security_group_id = data.terraform_remote_state.infra_security_groups.outputs.sg_management_id
}
# and also from the load balancer, so that the health checks don't fail
resource "aws_security_group_rule" "publishingamazonmq_ingress_lb_https" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  description = "HTTPS ingress for Publishing AmazonMQ"

  # Which security group is the rule assigned to
  security_group_id = data.terraform_remote_state.infra_security_groups.outputs.sg_rabbitmq_id
  cidr_blocks       = data.aws_subnet.lb_subnets[*].cidr_block
}

# existing RabbitMQ runs on port 5672, this AmazonMQ will be on port 5671
# so we need to allow that through the SG
resource "aws_security_group_rule" "publishingamazonmq_ingress_management_amqps" {
  type        = "ingress"
  from_port   = 5671
  to_port     = 5671
  protocol    = "tcp"
  description = "AMQPS ingress for Publishing AmazonMQ"

  # Which security group is the rule assigned to
  security_group_id        = data.terraform_remote_state.infra_security_groups.outputs.sg_rabbitmq_id
  source_security_group_id = data.terraform_remote_state.infra_security_groups.outputs.sg_management_id
}
# and also from the load balancer as before
resource "aws_security_group_rule" "publishingamazonmq_ingress_lb_amqps" {
  type        = "ingress"
  from_port   = 5671
  to_port     = 5671
  protocol    = "tcp"
  description = "AMQPS ingress for Publishing AmazonMQ"

  # Which security group is the rule assigned to
  security_group_id = data.terraform_remote_state.infra_security_groups.outputs.sg_rabbitmq_id
  cidr_blocks       = data.aws_subnet.lb_subnets[*].cidr_block
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

resource "aws_lb" "publishingmq_lb_internal" {
  name               = "publishingamazonmq-lb-internal"
  internal           = true
  load_balancer_type = "network"
  subnets            = aws_mq_broker.publishing_amazonmq.subnet_ids

  access_logs {
    bucket = data.terraform_remote_state.infra_monitoring.outputs.aws_logging_bucket_id
    prefix = "lb/${var.stackname}-publishingamazonmq-internal-lb"
  }

  enable_deletion_protection = var.lb_delete_protection

  tags = {
    "Name"            = "${var.stackname}-publishingamazonmq-internal"
    "Project"         = var.stackname
    "aws_environment" = var.aws_environment
    "aws_migration"   = "publishingamazonmq"
  }
}

# HTTPS listener & target group for web admin UI traffic
resource "aws_lb_listener" "internal_https" {
  load_balancer_arn = aws_lb.publishingmq_lb_internal.arn
  port              = "443"
  protocol          = "TLS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = data.aws_acm_certificate.internal_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.internal_https.arn
  }
}

resource "aws_lb_target_group" "internal_https" {
  name        = "publishingmq-lb-internal-https"
  target_type = "ip"
  port        = 443
  protocol    = "TLS"
  vpc_id      = data.terraform_remote_state.infra_vpc.outputs.vpc_id

  health_check {
    path     = "/"
    protocol = "HTTPS"
  }
}

# Attach all the IP addresses from the broker DNS lookup
# to the LB target group
resource "aws_lb_target_group_attachment" "internal_https_ips" {
  count            = var.publishing_amazonmq_instance_count
  target_group_arn = aws_lb_target_group.internal_https.arn
  target_id        = data.dns_a_record_set.mq_instances.addrs[count.index]
  port             = 443

  depends_on = [
    aws_mq_broker.publishing_amazonmq,
    aws_lb_target_group.internal_https
  ]
}

# AMQPS listener for port 5671 traffic
resource "aws_lb_listener" "internal_amqps" {
  load_balancer_arn = aws_lb.publishingmq_lb_internal.arn
  port              = "5671"
  protocol          = "TLS"
  certificate_arn   = data.aws_acm_certificate.internal_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.internal_amqps.arn
  }
}

resource "aws_lb_target_group" "internal_amqps" {
  name        = "publishingmq-lb-internal-amqps"
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

# Attach all the IP addresses from the broker DNS lookup
# to the LB target group
resource "aws_lb_target_group_attachment" "internal_amqps_ips" {
  count            = var.publishing_amazonmq_instance_count
  target_group_arn = aws_lb_target_group.internal_amqps.arn
  target_id        = data.dns_a_record_set.mq_instances.addrs[count.index]
  port             = 5671

  depends_on = [
    aws_mq_broker.publishing_amazonmq,
    aws_lb_target_group.internal_amqps
  ]
}


# --------------------------------------------------------------  
# DNS Entry

# DNS entry to go via the NLB
resource "aws_route53_record" "publishing_amazonmq_internal_root_domain_name" {
  zone_id = data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_zone_id
  name    = "${lower(aws_mq_broker.publishing_amazonmq.broker_name)}.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.publishingmq_lb_internal.dns_name
    zone_id                = aws_lb.publishingmq_lb_internal.zone_id
    evaluate_target_health = true
  }
}

# --------------------------------------------------------------
# POST full RabbitMQ config to the management API
# We have to do this by creating and invoking a Lambda function 
# in the target environment, as the Jenkins box in integration
# does not have access to other environments
#
# Write the decrypted definitions from govuk-aws-data to a local file
resource "local_sensitive_file" "amazonmq_rabbitmq_definitions" {
  filename = "/tmp/amazonmq_rabbitmq_definitions.json"
  content = templatefile("${path.cwd}/publishing-rabbitmq-schema.json.tpl", {
    publishing_amazonmq_passwords   = local.publishing_amazonmq_passwords
    publishing_amazonmq_broker_name = var.publishing_amazonmq_broker_name
  })
}

data "local_sensitive_file" "amazonmq_rabbitmq_definitions_interpolated" {
  filename = "/tmp/amazonmq_rabbitmq_definitions.json"
}


# Get the existing IAM policy by name
data "aws_iam_policy" "lambda_vpc_access" {
  name = "AWSLambdaVPCAccessExecutionRole"
}

# Build a zip file which can be deployed to AWS Lambda
data "archive_file" "artefact_lambda" {
  type        = "zip"
  source_file = "${path.module}/../../lambda/PostConfigToAmazonMQ/post_config_to_amazonmq.py"
  output_path = "${path.module}/../../lambda/PostConfigToAmazonMQ/post_config_to_amazonmq.zip"
}

# The Lambda function itself
resource "aws_lambda_function" "post_config_to_amazonmq" {
  filename         = data.archive_file.artefact_lambda.output_path
  source_code_hash = data.archive_file.artefact_lambda.output_base64sha256

  function_name = "govuk-${var.aws_environment}-post_config_to_amazonmq"
  role          = aws_iam_role.post_config_to_amazonmq_role.arn
  handler       = "post_config_to_amazonmq.lambda_handler"
  runtime       = "python3.8"

  vpc_config {
    subnet_ids         = aws_mq_broker.publishing_amazonmq.subnet_ids
    security_group_ids = [data.terraform_remote_state.infra_security_groups.outputs.sg_rabbitmq_id]
  }
}

# AWS Lambda Role
resource "aws_iam_role" "post_config_to_amazonmq_role" {
  name = "post_config_to_amazonmq_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "lambda_role_policy" {
  role       = aws_iam_role.post_config_to_amazonmq_role.name
  policy_arn = data.aws_iam_policy.lambda_vpc_access.arn
}

# Call the function
data "aws_lambda_invocation" "post_config_to_amazonmq" {
  function_name = aws_lambda_function.post_config_to_amazonmq.function_name

  input = <<JSON
{
  "url": "${aws_mq_broker.publishing_amazonmq.instances.0.console_url}/api/definitions",
  "username": "root",
  "password": "${local.publishing_amazonmq_passwords["root"]}",
  "json_b64": "${base64encode(data.local_sensitive_file.amazonmq_rabbitmq_definitions_interpolated.content)}"
}
JSON

  depends_on = [
    aws_security_group_rule.rabbitmq_egress_self_self
  ]
}

