
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

variable "engine_type" {
  type        = string
  description = "ActiveMQ or RabbitMQ"
  default     = "RabbitMQ"
}

variable "engine_version" {
  type        = string
  description = "broker engine version"
  default     = "3.9.16"
}

variable "deployment_mode" {
  type        = string
  description = "SINGLE_INSTANCE, ACTIVE_STANDBY_MULTI_AZ, or CLUSTER_MULTI_AZ"
  default     = "SINGLE_INSTANCE"
}

variable "host_instance_type" {
  type        = string
  description = "Broker's instance type. For example, mq.t3.micro, mq.m5.large"
  default     = "mq.t3.micro"
}

variable "publicly_accessible" {
  type        = bool
  description = "Whether to enable connections from applications outside of the VPC that hosts the broker's subnets. Default false"
  default     = false
}

variable "office_ips" {
  type        = list(any)
  description = "An array of CIDR blocks that will be allowed offsite access."
}

variable "internal_zone_name" {
  type        = string
  description = "The name of the Route53 zone that contains internal records"
}

variable "internal_domain_name" {
  type        = string
  description = "The domain name of the internal DNS records, it could be different from the zone name"
}

variable "amazonmq_root_password" {
  type      = string
  sensitive = true
}

variable "amazonmq_definitions" {
  type        = string
  description = "JSON definitions exported from existing RabbitMQ web management UI. The root user definition should be removed before use."
}

locals {
  tags = {
    Project         = var.stackname
    aws_stackname   = var.stackname
    aws_environment = var.aws_environment
  }
}