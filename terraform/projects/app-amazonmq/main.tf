/**
 * ## Project: app-amazonmq
 * 
 * Module app-amazonmq creates an Amazon MQ instance or cluster for GOV.UK.
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
    password       = var.amazonmq_root_password
  }

}

# Allow HTTPS access to AmazonMQ from anything in the 'management' SG
# (i.e. all EC2 instances)
resource "aws_security_group_rule" "amazonmq_ingress_management_https" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  description = "HTTPS ingress for AmazonMQ"

  # Which security group is the rule assigned to
  security_group_id        = data.terraform_remote_state.infra_security_groups.outputs.sg_rabbitmq_id
  source_security_group_id = data.terraform_remote_state.infra_security_groups.outputs.sg_management_id
}
# existing RabbitMQ runs on port 5672, this AmazonMQ will be on port 5671
# so we need to allow that through the SG
resource "aws_security_group_rule" "amazonmq_ingress_management_amqps" {
  type        = "ingress"
  from_port   = 5671
  to_port     = 5671
  protocol    = "tcp"
  description = "AMQPS ingress for AmazonMQ"

  # Which security group is the rule assigned to
  security_group_id        = data.terraform_remote_state.infra_security_groups.outputs.sg_rabbitmq_id
  source_security_group_id = data.terraform_remote_state.infra_security_groups.outputs.sg_management_id
}


# --------------------------------------------------------------  
data "aws_route53_zone" "internal" {
  name         = var.internal_zone_name
  private_zone = true
}

# internal_domain_name is ${var.stackname}.${internal_root_domain_name}
resource "aws_route53_record" "amazonmq_internal_root_domain_name" {
  zone_id = data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_zone_id
  name    = "${lower(aws_mq_broker.publishing_amazonmq.broker_name)}.${data.terraform_remote_state.infra_root_dns_zones.outputs.internal_root_domain_name}"
  type    = "CNAME"
  ttl     = 300
  # TODO: this version will only work with a single instance, as on integration. 
  # For staging/production, we'll have a highly-available cluster, at which point
  # we'll need to repoint this Route53 record at a Network Load Balancer that balances
  # between the instances. See Amazon's article about how to do that here:
  # https://aws.amazon.com/blogs/compute/creating-static-custom-domain-endpoints-with-amazon-mq-for-rabbitmq/
  records = [regex("://([^/:]+)", aws_mq_broker.publishing_amazonmq.instances.0.console_url)[0]]

}