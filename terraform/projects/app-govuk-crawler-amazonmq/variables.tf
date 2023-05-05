variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-1"
}

variable "govuk_crawler_amazonmq_broker_name" {
  type        = string
  description = "Unique name given to the broker, and the first part of the internal domain name. Must be a valid domain part (i.e. stick to a-z, 0-9, and - as a separator, no spaces)."
  default     = "govukCrawlerMQ"
}

variable "engine_type" {
  type        = string
  description = "Type of broker engine. Either ActiveMQ or RabbitMQ"
  default     = "RabbitMQ"
}

variable "engine_version" {
  type        = string
  description = "Version of the broker engine"
  default     = "3.9.16"
}

variable "host_instance_type" {
  type        = string
  description = "Broker's instance type. For example, mq.t3.micro, mq.m5.large"
  default     = "mq.t3.micro"
}

variable "deployment_mode" {
  type        = string
  description = "SINGLE_INSTANCE, ACTIVE_STANDBY_MULTI_AZ, or CLUSTER_MULTI_AZ"
  default     = "SINGLE_INSTANCE"
}

variable "publicly_accessible" {
  type        = bool
  description = "Whether to enable connections from applications outside of the VPC that hosts the broker's subnets. Default false"
  default     = false
}

variable "lb_delete_protection" {
  type        = bool
  description = "Whether to enable delete protection on the Network Load Balancer. Defaults to false."
  default     = false
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

variable "elb_internal_certname" {
  type        = string
  description = "The ACM cert domain name to find the ARN of, so that it can be applied to the Network Load Balancer"
}
