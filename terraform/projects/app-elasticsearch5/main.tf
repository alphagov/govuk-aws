/**
* ## Project: app-elasticsearch5
*
* Managed Elasticsearch 5 cluster
*/
variable "aws_environment" {
  type        = "string"
  description = "AWS Environment"
}

variable "aws_region" {
  type        = "string"
  description = "AWS region"
  default     = "eu-west-1"
}

variable "stackname" {
  type        = "string"
  description = "Stackname"
}

variable "elasticsearch5_instance_type" {
  type        = "string"
  description = "The instance type of the individual ElasticSearch nodes, only instances which allow EBS volumes are supported"
  default     = "m4.2xlarge.elasticsearch"
}

variable "elasticsearch5_instance_count" {
  type        = "string"
  description = "The number of ElasticSearch nodes"
  default     = "4"
}

variable "elasticsearch5_ebs_encrypt" {
  type        = "string"
  description = "Whether to encrypt the EBS volume at rest"
}

variable "elasticsearch5_ebs_size" {
  type        = "string"
  description = "The amount of EBS storage to attach"
  default     = 32
}

variable "elasticsearch5_snapshot_start_hour" {
  type        = "string"
  description = "The hour in which the daily snapshot is taken"
  default     = 1
}

variable "elasticsearch_subnet_names" {
  type        = "list"
  description = "Names of the subnets to place the ElasticSearch domain in"
}

# Resources
# --------------------------------------------------------------
terraform {
  backend          "s3"             {}
  required_version = "= 0.11.7"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "1.40.0"
}

resource "aws_iam_service_linked_role" "role" {
  aws_service_name = "es.amazonaws.com"
}

resource "aws_elasticsearch_domain" "elasticsearch5" {
  domain_name           = "${var.stackname}-elasticsearch5-domain"
  elasticsearch_version = "5.6"

  cluster_config {
    instance_type          = "${var.elasticsearch5_instance_type}"
    instance_count         = "${var.elasticsearch5_instance_count}"
    zone_awareness_enabled = true
  }

  ebs_options {
    ebs_enabled = true
    volume_type = "gp2"
    volume_size = "${var.elasticsearch5_ebs_size}"
  }

  encrypt_at_rest {
    enabled = "${var.elasticsearch5_ebs_encrypt}"
  }

  vpc_options {
    subnet_ids         = ["${matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_elasticsearch_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_elasticsearch_names_ids_map), var.elasticsearch_subnet_names)}"]
    security_group_ids = ["${data.terraform_remote_state.infra_security_groups.sg_elasticsearch5_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  }

  snapshot_options {
    automated_snapshot_start_hour = "${var.elasticsearch5_snapshot_start_hour}"
  }

  tags {
    Name            = "${var.stackname}-elasticsearch5"
    Project         = "${var.stackname}"
    aws_stackname   = "${var.stackname}"
    aws_environment = "${var.aws_environment}"
  }

  depends_on = [
    "aws_iam_service_linked_role.role",
  ]
}

resource "aws_route53_record" "service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.internal_zone_id}"
  name    = "elasticsearch5.${data.terraform_remote_state.infra_stack_dns_zones.internal_domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = ["${aws_elasticsearch_domain.elasticsearch5.endpoint}"]
}

# Outputs
# --------------------------------------------------------------

output "service_role_id" {
  value       = "${aws_iam_service_linked_role.role.id}"
  description = "Unique identifier for the service-linked role"
}

output "service_endpoint" {
  value       = "${aws_elasticsearch_domain.elasticsearch5.endpoint}"
  description = "Endpoint to submit index, search, and upload requests"
}

output "service_dns_name" {
  value       = "${aws_route53_record.service_record.fqdn}"
  description = "DNS name to access the Elasticsearch internal service"
}
