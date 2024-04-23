/**
 * app-publishing-amazonmq creates an Amazon MQ RabbitMQ instance or cluster.
 *
 * The Terraform provider can only create a single user account on the MQ, so
 * we create other users by installing and invoking a Lambda that talks to the
 * MQ's REST API.
 */
terraform {
  backend "s3" {}
  required_version = "~> 1.7"
  required_providers {
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Product              = "GOV.UK"
      Environment          = var.aws_environment
      Owner                = "govuk-platform-engineering@digital.cabinet-office.gov.uk"
      repository           = "govuk-aws"
      terraform_deployment = basename(abspath(path.root))
    }
  }
}

locals {
  mq_instance_count = {
    SINGLE_INSTANCE         = 1
    ACTIVE_STANDBY_MULTI_AZ = 2
    CLUSTER_MULTI_AZ        = 3
  }[var.deployment_mode]
}

resource "random_password" "mq_user" {
  for_each = toset([
    "root",
    "content_data_api",
    "email_alert_service",
    "monitoring",
    "publishing_api",
    "search_api",
    "search_api_v2",
  ])
  length  = 24
  special = false
}

data "aws_subnet" "lb_subnets" {
  count = local.mq_instance_count
  id    = sort(tolist(aws_mq_broker.publishing_amazonmq.subnet_ids))[count.index]
}

data "aws_acm_certificate" "internal_cert" {
  domain   = var.elb_internal_certname
  statuses = ["ISSUED"]
}

data "aws_vpc_endpoint" "mq" {
  depends_on = [aws_mq_broker.publishing_amazonmq]
  vpc_id     = data.terraform_remote_state.infra_vpc.outputs.vpc_id
  tags       = { Broker = aws_mq_broker.publishing_amazonmq.id }
}

data "aws_network_interface" "mq" {
  count = local.mq_instance_count
  id    = sort(tolist(data.aws_vpc_endpoint.mq.network_interface_ids))[count.index]
}

resource "aws_mq_broker" "publishing_amazonmq" {
  broker_name = var.publishing_amazonmq_broker_name

  engine_type         = "RabbitMQ"
  engine_version      = var.engine_version
  deployment_mode     = var.deployment_mode
  host_instance_type  = var.host_instance_type
  publicly_accessible = false
  # use the existing RabbitMQ security group. We can move it
  # over to this module at the point of migration
  security_groups = [data.terraform_remote_state.infra_security_groups.outputs.sg_rabbitmq_id]
  subnet_ids = (
    var.deployment_mode == "SINGLE_INSTANCE"
    ? [data.terraform_remote_state.infra_networking.outputs.private_subnet_ids[0]]
    : data.terraform_remote_state.infra_networking.outputs.private_subnet_ids
  )

  auto_minor_version_upgrade = true
  maintenance_window_start_time {
    day_of_week = var.maintenance_window_start_day_of_week
    time_of_day = var.maintenance_window_start_time_utc
    time_zone   = "UTC"
  }

  logs { general = true }

  # The Terraform provider can only create a single user.
  user {
    console_access = true
    username       = "root"
    password       = random_password.mq_user["root"].result
  }
}

resource "aws_security_group_rule" "publishingamazonmq_ingress_lb_https" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  description = "LB healthchecks to Publishing AmazonMQ"

  security_group_id = data.terraform_remote_state.infra_security_groups.outputs.sg_rabbitmq_id
  cidr_blocks       = data.aws_subnet.lb_subnets[*].cidr_block
}

resource "aws_security_group_rule" "publishingamazonmq_ingress_lb_amqps" {
  type        = "ingress"
  from_port   = 5671
  to_port     = 5671
  protocol    = "tcp"
  description = "AMQPS ingress for Publishing AmazonMQ"

  security_group_id = data.terraform_remote_state.infra_security_groups.outputs.sg_rabbitmq_id
  cidr_blocks       = data.aws_subnet.lb_subnets[*].cidr_block
}

resource "aws_security_group_rule" "rabbitmq_egress_self_self" {
  type      = "egress"
  from_port = 0
  to_port   = 0
  protocol  = "-1"

  source_security_group_id = data.terraform_remote_state.infra_security_groups.outputs.sg_rabbitmq_id
  security_group_id        = data.terraform_remote_state.infra_security_groups.outputs.sg_rabbitmq_id
}

resource "aws_lb" "publishingmq_lb_internal" {
  name               = "publishingamazonmq-lb-internal"
  tags               = { "Name" = "publishingamazonmq-lb-internal" }
  internal           = true
  load_balancer_type = "network"
  subnets            = aws_mq_broker.publishing_amazonmq.subnet_ids

  access_logs {
    bucket = data.terraform_remote_state.infra_monitoring.outputs.aws_logging_bucket_id
    prefix = "lb/publishingamazonmq-internal-lb"
  }
  enable_deletion_protection = var.lb_delete_protection
}

resource "aws_lb_listener" "internal_https" {
  load_balancer_arn = aws_lb.publishingmq_lb_internal.arn
  port              = "443"
  protocol          = "TLS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = data.aws_acm_certificate.internal_cert.arn
  tags              = { Description = "MQ admin web UI" }

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

resource "aws_lb_target_group_attachment" "internal_https_ips" {
  count = local.mq_instance_count
  depends_on = [
    aws_mq_broker.publishing_amazonmq,
    aws_lb_target_group.internal_https,
  ]
  target_group_arn = aws_lb_target_group.internal_https.arn
  target_id        = data.aws_network_interface.mq[count.index].private_ip
  port             = 443
}

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

  health_check {
    path     = "/"
    port     = 443
    protocol = "HTTPS"
  }
}

resource "aws_lb_target_group_attachment" "internal_amqps_ips" {
  count = local.mq_instance_count
  depends_on = [
    aws_mq_broker.publishing_amazonmq,
    aws_lb_target_group.internal_amqps,
  ]
  target_group_arn = aws_lb_target_group.internal_amqps.arn
  target_id        = data.aws_network_interface.mq[count.index].private_ip
  port             = 5671
}


resource "aws_route53_record" "publishing_amazonmq_internal_root_domain_name" {
  zone_id = data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_zone_id
  # TODO: remove redundant FQDN.
  name = "${lower(aws_mq_broker.publishing_amazonmq.broker_name)}.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"
  type = "A"

  alias {
    name                   = aws_lb.publishingmq_lb_internal.dns_name
    zone_id                = aws_lb.publishingmq_lb_internal.zone_id
    evaluate_target_health = true
  }
}

# Create and invoke a Lambda function to POST the full RabbitMQ config to the
# management API in the target environment.

resource "local_sensitive_file" "amazonmq_rabbitmq_definitions" {
  filename = join(".", [
    "/tmp/amazonmq_rabbitmq_definitions",
    formatdate("YYYY-MM-DD-hhmm-ZZZ", timestamp()),
    "json",
  ])
  content = templatefile("${path.cwd}/publishing-rabbitmq-schema.json.tpl", {
    publishing_amazonmq_passwords = {
      for user, pw in random_password.mq_user : user => pw.result
    }
    publishing_amazonmq_broker_name = var.publishing_amazonmq_broker_name
  })
}

data "local_sensitive_file" "amazonmq_rabbitmq_definitions_interpolated" {
  depends_on = [local_sensitive_file.amazonmq_rabbitmq_definitions]
  filename   = local_sensitive_file.amazonmq_rabbitmq_definitions.filename
}


data "aws_iam_policy" "lambda_vpc_access" {
  name = "AWSLambdaVPCAccessExecutionRole"
}

data "archive_file" "artefact_lambda" {
  type        = "zip"
  source_file = "${path.module}/../../lambda/PostConfigToAmazonMQ/post_config_to_amazonmq.py"
  output_path = "${path.module}/../../lambda/PostConfigToAmazonMQ/post_config_to_amazonmq.zip"
}

resource "aws_lambda_function" "post_config_to_amazonmq" {
  filename         = data.archive_file.artefact_lambda.output_path
  source_code_hash = data.archive_file.artefact_lambda.output_base64sha256

  function_name = "govuk-${var.aws_environment}-post_config_to_amazonmq"
  role          = aws_iam_role.post_config_to_amazonmq.arn
  handler       = "post_config_to_amazonmq.lambda_handler"
  runtime       = "python3.12"

  vpc_config {
    subnet_ids         = aws_mq_broker.publishing_amazonmq.subnet_ids
    security_group_ids = [data.terraform_remote_state.infra_security_groups.outputs.sg_rabbitmq_id]
  }
}

data "aws_iam_policy_document" "lambda_assumerole" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "post_config_to_amazonmq" {
  name               = "post_config_to_amazonmq"
  assume_role_policy = data.aws_iam_policy_document.lambda_assumerole.json
}

resource "aws_iam_role_policy_attachment" "lambda_role_policy" {
  role       = aws_iam_role.post_config_to_amazonmq.name
  policy_arn = data.aws_iam_policy.lambda_vpc_access.arn
}

data "aws_lambda_invocation" "post_config_to_amazonmq" {
  depends_on    = [aws_security_group_rule.rabbitmq_egress_self_self]
  function_name = aws_lambda_function.post_config_to_amazonmq.function_name
  input = jsonencode({
    url      = "${aws_mq_broker.publishing_amazonmq.instances[0].console_url}/api/definitions"
    username = "root"
    password = random_password.mq_user["root"].result
    json_b64 = base64encode(data.local_sensitive_file.amazonmq_rabbitmq_definitions_interpolated.content)
  })
}
