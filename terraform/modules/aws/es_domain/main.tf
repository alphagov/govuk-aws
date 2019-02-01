/**
* ## Module: aws::es_domain
*
* Create an ElasticSearch domain
*/
variable "name" {
  type        = "string"
  description = "The common name for all the resources created by this module"
}

variable "elasticsearch_version" {
  type        = "string"
  description = "Which version of ElasticSearch to use (eg 5.6)"
  default     = "5.6"
}

variable "default_tags" {
  type        = "map"
  description = "Additional resource tags"
  default     = {}
}

variable "instance_type" {
  type        = "string"
  description = "The instance type of the individual ElasticSearch nodes, only instances which allow EBS volumes are supported"
  default     = "m4.2xlarge.elasticsearch"
}

variable "instance_count" {
  type        = "string"
  description = "The number of ElasticSearch nodes"
  default     = "3"
}

variable "ebs_encrypt" {
  type        = "string"
  description = "Whether to encrypt the EBS volume at rest"
}

variable "ebs_size" {
  type        = "string"
  description = "The amount of EBS storage to attach"
  default     = 32
}

variable "subnet_ids" {
  type        = "list"
  description = "Subnet IDs to assign to the aws_elasticsearch_domain"
  default     = []
}

variable "security_group_ids" {
  type        = "list"
  description = "Security group IDs to apply to this cluster"
}

variable "snapshot_start_hour" {
  type        = "string"
  description = "The hour in which the daily snapshot is taken"
  default     = "01:00"
}

# Resources
# --------------------------------------------------------------

resource "aws_iam_service_linked_role" "es" {
  name             = "${var.name}-role"
  aws_service_name = "elasticsearch.amazonaws.com"
}

resource "aws_elasticsearch_domain" "es" {
  domain_name           = "${var.name}-domain"
  elasticsearch_version = "${var.elasticsearch_version}"

  cluster_config {
    instance_type  = "${var.instance_type}"
    instance_count = "${var.instance_count}"
  }

  ebs_options {
    ebs_enabled = true
    volume_size = "${var.ebs_size}"
  }

  encrypt_at_rest {
    enabled = "${var.ebs_encrypt}"
  }

  vpc_options {
    subnet_ids         = ["${var.subnet_ids}"]
    security_group_ids = ["${var.security_group_ids}"]
  }

  advanced_options {
    "action.destructive_requires_name" = "true"
  }

  snapshot_options {
    automated_snapshot_start_hour = "${var.snapshot_start_hour}"
  }

  tags = "${merge(var.default_tags, map("Name", var.name))}"

  depends_on = [
    "aws_iam_service_linked_role.es",
  ]
}

# Outputs
#--------------------------------------------------------------

output "es_domain_id" {
  value       = "${aws_elasticsearch_domain.es.domain_id}"
  description = "Unique identifier for the domain"
}

output "es_role_id" {
  value       = "${aws_iam_service_linked_role.es.id}"
  description = "Unique identifier for the service-linked role"
}

output "es_endpoint" {
  value       = "${aws_elasticsearch_domain.es.endpoint}"
  description = "Endpoint to submit index, search, and upload requests"
}
