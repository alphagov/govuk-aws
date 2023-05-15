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

variable "asg_max_size" {
  description = "The maximum size of the autoscaling group"
  default     = "2"
}

variable "asg_min_size" {
  description = "The minimum size of the autoscaling group"
  default     = "2"
}

variable "asg_desired_capacity" {
  description = "The desired capacity of the autoscaling group"
  default     = "2"
}

variable "instance_type" {
  description = "Instance type used for EC2 resources"
  default     = "c5.xlarge"
}
