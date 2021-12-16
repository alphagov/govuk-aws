variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-1"
}

variable "stackname" {
  type        = string
  description = "Stackname"
  default     = "blue"
}

variable "aws_environment" {
  type        = string
  description = "AWS Environment"
}

variable "databases" {
  type        = map(any)
  description = "Databases to create and their configuration."
}

variable "database_credentials" {
  type        = map(any)
  description = "RDS root account credentials for each database."
}

variable "multi_az" {
  type        = bool
  description = "Set to true to deploy the RDS instance in multiple AZs."
  default     = false
}

variable "maintenance_window" {
  type        = string
  description = "The window to perform maintenance in"
  default     = "Mon:04:00-Mon:06:00"
}

variable "backup_window" {
  type        = string
  description = "The daily time range during which automated backups are created if automated backups are enabled."
  default     = "01:00-03:00"
}

variable "backup_retention_period" {
  type        = string
  description = "The days to retain backups for."
  default     = "7"
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Set to true to NOT create a final snapshot when the cluster is deleted."
  default     = false
}

variable "terraform_create_rds_timeout" {
  type        = string
  description = "Set the timeout time for AWS RDS creation."
  default     = "2h"
}

variable "terraform_update_rds_timeout" {
  type        = string
  description = "Set the timeout time for AWS RDS modification."
  default     = "2h"
}

variable "terraform_delete_rds_timeout" {
  type        = string
  description = "Set the timeout time for AWS RDS deletion."
  default     = "2h"
}

variable "internal_zone_name" {
  type        = string
  description = "The name of the Route53 zone that contains internal records"
}

variable "internal_domain_name" {
  type        = string
  description = "The domain name of the internal DNS records, it could be different from the zone name"
}

variable "instance_ami_filter_name" {
  type        = string
  description = "Name to use to find AMI images for the instance"
  default     = "ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"
}

variable "instance_key_name" {
  type        = string
  description = "Name of the instance key"
  default     = "govuk-infra"
}

locals {
  tags = {
    Project         = var.stackname
    aws_stackname   = var.stackname
    aws_environment = var.aws_environment
  }
}
