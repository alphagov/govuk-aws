variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-1"
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
  default     = "3.9.27"
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

variable "maintenance_window_start_day_of_week" {
  type        = string
  description = "Day of the week of the start of the maintenance window"
  default     = "WEDNESDAY"
}

variable "maintenance_window_start_time_utc" {
  type        = string
  description = "Time of day of the start of the maintenance window in UTC"
  default     = "06:00"
}

variable "publishing_amazonmq_broker_name" {
  type        = string
  description = "Unique name given to the broker, and the first part of the internal domain name. Must be a valid domain part (i.e. stick to a-z, 0-9, and - as a separator, no spaces)."
  default     = "PublishingMQ"
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
