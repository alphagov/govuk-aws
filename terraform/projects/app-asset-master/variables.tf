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

variable "internal_zone_name" {
  description = "The name of the Route53 zone that contains internal records"
}

variable "internal_domain_name" {
  description = "The domain name of the internal DNS records, it could be different from the zone name"
}
