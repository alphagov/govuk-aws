variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-1"
}

variable "aws_environment" {
  type        = string
  description = "AWS Environment"
}

variable "engine_version" {
  type        = string
  description = "Broker engine version. https://docs.aws.amazon.com/amazon-mq/latest/developer-guide/rabbitmq-version-management"
  default     = "3.11.28"
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

variable "govuk_chat_retry_message-ttl" {
  type        = number
  description = "Time in miliseconds before messages in the govuk_chat_retry queue expires and are sent back to the govuk_chat_published_ducoments queue through the dead letter mechanism"
  default     = 300000
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
