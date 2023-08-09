variable "aws_environment" {
  description = "AWS Environment"
}

variable "aws_region" {
  description = "AWS region"
  default     = "eu-west-1"
}

variable "stackname" {
  description = "Stackname"
}

variable "elasticsearch6_instance_type" {
  description = "Instance type of the ElasticSearch data nodes"
  default     = "r5.xlarge.elasticsearch"
}

variable "elasticsearch6_instance_count" {
  description = "Number of ElasticSearch data nodes"
  default     = "6"
}

variable "elasticsearch6_dedicated_master_enabled" {
  description = "Indicates whether dedicated master nodes are enabled for the cluster"
  default     = "true"
}

variable "elasticsearch6_master_instance_type" {
  description = "Instance type of the dedicated master nodes"
  default     = "c5.large.elasticsearch"
}

variable "elasticsearch6_master_instance_count" {
  description = "Number of dedicated master nodes in the cluster"
  default     = "3"
}

variable "elasticsearch6_ebs_size" {
  description = "Size of each node's EBS volume in GB"
  default     = 85
}

variable "elasticsearch6_snapshot_start_hour" {
  description = "The hour in which the daily snapshot is taken"
  default     = 1
}

variable "elasticsearch_subnet_names" {
  type        = list(string)
  description = "Names of the subnets to place the ElasticSearch domain in"
}

variable "cloudwatch_log_retention" {
  description = "Number of days to retain Cloudwatch logs for"
  default     = 90
}

variable "elasticsearch6_manual_snapshot_bucket_arns" {
  type        = list(string)
  description = "Bucket ARNs this domain can read/write for manual snapshots"
  default     = []
}

variable "internal_zone_name" {
  description = "Name of the Route53 zone for internal-only records"
}

variable "internal_domain_name" {
  description = "Domain name for internal-only DNS records. Can be different from the zone name."
}
