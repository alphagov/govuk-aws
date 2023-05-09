variable "aws_region" {
  description = "AWS region"
  default     = "eu-west-1"
}

variable "stackname" {
  description = "Stackname"
}

variable "aws_environment" {
  description = "AWS Environment"
}

variable "instance_ami_filter_name" {
  description = "Name to use to find AMI images"
  default     = ""
}

variable "router-backend_1_subnet" {
  description = "Name of the subnet to place the Router Mongo 1"
}

variable "router-backend_2_subnet" {
  description = "Name of the subnet to place the Router Mongo 2"
}

variable "router-backend_3_subnet" {
  description = "Name of the subnet to place the Router Mongo 3"
}

variable "router-backend_1_reserved_ips_subnet" {
  description = "Name of the subnet to place the reserved IP of the instance"
}

variable "router-backend_2_reserved_ips_subnet" {
  description = "Name of the subnet to place the reserved IP of the instance"
}

variable "router-backend_3_reserved_ips_subnet" {
  description = "Name of the subnet to place the reserved IP of the instance"
}

variable "router-backend_1_ip" {
  description = "IP address of the private IP to assign to the instance"
}

variable "router-backend_2_ip" {
  description = "IP address of the private IP to assign to the instance"
}

variable "router-backend_3_ip" {
  description = "IP address of the private IP to assign to the instance"
}

variable "remote_state_infra_database_backups_bucket_key_stack" {
  description = "Override stackname path to infra_database_backups_bucket remote state"
  default     = ""
}

variable "internal_zone_name" {
  description = "The name of the Route53 zone that contains internal records"
}

variable "internal_domain_name" {
  description = "The domain name of the internal DNS records, it could be different from the zone name"
}

variable "instance_type" {
  description = "Instance type used for EC2 resources"
  default     = "t2.medium"
}
