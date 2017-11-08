/**
* ## Modules: aws/network/vpc
*
* This module creates a VPC, Internet Gateway and route associated
*/
variable "default_tags" {
  type        = "map"
  description = "Additional resource tags"
  default     = {}
}

variable "name" {
  type        = "string"
  description = "A name tag for the VPC"
}

variable "cidr" {
  type        = "string"
  description = "The cidr block of the desired VPC"
}

# Resources
#--------------------------------------------------------------

resource "aws_vpc" "vpc" {
  cidr_block           = "${var.cidr}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = "${merge(var.default_tags, map("Name", var.name))}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_internet_gateway" "public" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = "${merge(var.default_tags, map("Name", var.name))}"
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.public.id}"
  }

  tags = "${merge(var.default_tags, map("Name", var.name))}"
}

# Outputs
#--------------------------------------------------------------

output "vpc_id" {
  value       = "${aws_vpc.vpc.id}"
  description = "The ID of the VPC."
}

output "vpc_cidr" {
  value       = "${aws_vpc.vpc.cidr_block}"
  description = "The CIDR block of the VPC."
}

output "internet_gateway_id" {
  value       = "${aws_internet_gateway.public.id}"
  description = "The ID of the Internet Gateway."
}

output "route_table_public_id" {
  value       = "${aws_route_table.public.id}"
  description = "The ID of the public routing table associated with the Internet Gateway."
}
