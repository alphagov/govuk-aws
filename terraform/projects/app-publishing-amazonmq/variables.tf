
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

variable "maintenance_window_start_time_day_of_week" {
  type        = string
  description = "Day of the week of the start of the maintenance window"
  default     = "WEDNESDAY"
}

variable "maintenance_window_start_time_time_of_day" {
  type        = string
  description = "Time of day of the start of the maintenance window"
  default     = "07:00"
}

variable "maintenance_window_start_time_time_zone" {
  type        = string
  description = "Time zone of the start of the maintenance window"
  default     = "UTC"
}

variable "publicly_accessible" {
  type        = bool
  description = "Whether to enable connections from applications outside of the VPC that hosts the broker's subnets. Default false"
  default     = false
}

variable "gds_egress_ips" {
  type        = list(any)
  description = "An array of CIDR blocks that will be allowed offsite access."
}

variable "publishing_amazonmq_broker_name" {
  type        = string
  description = "Unique name given to the broker, and the first part of the internal domain name. Must be a valid domain part (i.e. stick to a-z, 0-9, and - as a separator, no spaces)."
  default     = "PublishingMQ"
}

# We need to use count when creating load balancer target group attachments
# This must be defined before apply, which means it can't be derived from the 
# outputs of the broker, if the broker doesn't already exist. 
# The only alternatives are 
# a) run terraform with -target to create the broker first, before any other run
# b) define the number of instances in advance
# We chose b) as the least-worst option
variable "publishing_amazonmq_instance_count" {
  type        = number
  description = "Number of instances the broker has/should have. This would normally be 1 for a deployment_mode of SINGLE_INSTANCE, 2 for ACTIVE_STANDBY_MULTI_AZ, 3 for CLUSTER_MULTI_AZ. Defaults to 1."
  default     = 1
}

variable "elb_internal_certname" {
  type        = string
  description = "The ACM cert domain name to find the ARN of, so that it can be applied to the Network Load Balancer"
}

variable "lb_delete_protection" {
  type        = bool
  description = "Whether to enable delete protection on the Network Load Balancer. Defaults to false."
  default     = false
}
