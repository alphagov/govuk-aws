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
data "aws_subnet" "lb_subnets" {
  count = length(aws_mq_broker.publishing_amazonmq.subnet_ids)
  id    = aws_mq_broker.publishing_amazonmq.subnet_ids
}

# --------------------------------------------------------------
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
# and also from the load balancer
resource "aws_security_group_rule" "publishingamazonmq_ingress_lb_https" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  description = "HTTPS ingress for Publishing AmazonMQ"

  # Which security group is the rule assigned to
  security_group_id = data.terraform_remote_state.infra_security_groups.outputs.sg_rabbitmq_id
  cidr_blocks       = data.aws_subnet.lb_subnets[*].cidr_blocks
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
# and also from the load balancer
resource "aws_security_group_rule" "publishingamazonmq_ingress_lb_amqps" {
  type        = "ingress"
  from_port   = 5671
  to_port     = 5671
  protocol    = "tcp"
  description = "AMQPS ingress for Publishing AmazonMQ"

  # Which security group is the rule assigned to
  security_group_id = data.terraform_remote_state.infra_security_groups.outputs.sg_rabbitmq_id
  cidr_blocks       = data.aws_subnet.lb_subnets[*].cidr_blocks
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

  enable_deletion_protection = true

  tags = {
    "Name"            = "${var.stackname}-publishingamazonmq-internal"
    "Project"         = var.stackname
    "aws_environment" = var.aws_environment
    "aws_migration"   = "publishingamazonmq"
  }
}


data "aws_acm_certificate" "internal_cert" {
  domain   = var.elb_internal_certname
  statuses = ["ISSUED"]
}

# The ip_address attributes of the AmazonMQ instances turn out blank
# (see https://stackoverflow.com/a/69221987)
# So the only way we can get the IPs is by a DNS lookup
data "dns_a_record_set" "mq_instances" {
  host = regex("://([^/:]+)", aws_mq_broker.publishing_amazonmq.instances.0.console_url)[0]
}

resource "aws_lb_listener_certificate" "internal" {
  listener_arn    = aws_lb_listener.internal_https.arn
  certificate_arn = data.aws_acm_certificate.internal_cert.arn
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
    path = "/"
    protocol = "HTTPS"
  }
}

resource "aws_lb_target_group_attachment" "internal_https_ips" {
  count            = length(aws_mq_broker.publishing_amazonmq.instances)
  target_group_arn = aws_lb_target_group.internal_https.arn
  #target_id        = aws_mq_broker.publishing_amazonmq.instances[count.index].ip_address
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

  # ... BUT use port 443 HTTPS for the healthcheck, as the LB
  # might not get a recognisable response on port 5671
  health_check {
    path = "/"
    port = 443
    protocol = "HTTPS"
  }
}


resource "aws_lb_target_group_attachment" "internal_amqps_ips" {
  count            = length(aws_mq_broker.publishing_amazonmq.instances)
  target_group_arn = aws_lb_target_group.internal_amqps.arn
  # target_id        = aws_mq_broker.publishing_amazonmq.instances[count.index].ip_address
  target_id        = data.dns_a_record_set.mq_instances.addrs[count.index]
  port             = 5671
  depends_on = [
    aws_mq_broker.publishing_amazonmq,
    aws_lb_target_group.internal_amqps
  ]
}


# --------------------------------------------------------------  
# DNS Entry

# internal_domain_name is ${var.stackname}.${internal_root_domain_name}
resource "aws_route53_record" "publishing_amazonmq_internal_root_domain_name" {
  zone_id = data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_zone_id
  name    = "${lower(aws_mq_broker.publishing_amazonmq.broker_name)}.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"
  type    = "CNAME"

  # TODO: this version will only work with a single instance, as on integration. 
  # For staging/production, we'll have a highly-available cluster, at which point
  # we'll need to repoint this Route53 record at a Network Load Balancer that balances
  # between the instances. See Amazon's article about how to do that here:
  # https://aws.amazon.com/blogs/compute/creating-static-custom-domain-endpoints-with-amazon-mq-for-rabbitmq/
  records = [regex("://([^/:]+)", aws_mq_broker.publishing_amazonmq.instances.0.console_url)[0]]
  ttl     = 300
}

# TEMP: separate DNS entry to go via the NLB
resource "aws_route53_record" "publishing_amazonmq_internal_via_nlb" {
  zone_id = data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_zone_id
  name    = "${lower(aws_mq_broker.publishing_amazonmq.broker_name)}-via-nlb.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.publishingmq_lb_internal.dns_name
    zone_id                = aws_lb.publishingmq_lb_internal.zone_id
    evaluate_target_health = true
  }
}

# --------------------------------------------------------------
# POST full RabbitMQ config to the management API

# Write the decrypted definitions from govuk-aws-data to a local file
resource "local_sensitive_file" "amazonmq_rabbitmq_definitions" {
  filename = "/tmp/amazonmq_rabbitmq_definitions.json"
  content = templatefile("${path.cwd}/publishing-rabbitmq-schema.json.tpl", {
    publishing_amazonmq_passwords   = local.publishing_amazonmq_passwords
    publishing_amazonmq_broker_name = var.publishing_amazonmq_broker_name
  })
}

# POST that definitions file to the Rabbitmq HTTP API (see https://pulse.mozilla.org/api/index.html)
resource "null_resource" "upload_definitions" {
  triggers = {
    # make this run on every apply
    build_number = "${timestamp()}"
  }
  provisioner "local-exec" {
    environment = {
      AMAZONMQ_USER     = "root"
      AMAZONMQ_PASSWORD = local.publishing_amazonmq_passwords["root"]
    }
    command = "curl -i -XPOST -u $AMAZONMQ_USER:$AMAZONMQ_PASSWORD -H 'Content-type: application/json' -d '@${local_sensitive_file.amazonmq_rabbitmq_definitions.filename}' ${aws_mq_broker.publishing_amazonmq.instances.0.console_url}/api/definitions && rm ${local_sensitive_file.amazonmq_rabbitmq_definitions.filename}"
  }
}
