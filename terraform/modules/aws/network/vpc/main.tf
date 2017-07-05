# == Modules: aws::network::vpc
#
# This module creates a VPC, Internet Gateway and route associated
#
# === Variables:
#
# tag_project
# name
# cidr
#
# === Outputs:
#
# vpc_id
# vpc_cidr
# internet_gateway_id
# route_table_public_id
#

variable "tag_project" {
  type        = "string"
  description = "The project tag."
  default     = ""
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

  tags {
    Name    = "${var.name}"
    Project = "${var.tag_project}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_internet_gateway" "public" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name    = "${var.name}"
    Project = "${var.tag_project}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.public.id}"
  }

  tags {
    Name    = "${var.name}"
    Project = "${var.tag_project}"
  }
}

# Outputs
#--------------------------------------------------------------
output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "vpc_cidr" {
  value = "${aws_vpc.vpc.cidr_block}"
}

output "internet_gateway_id" {
  value = "${aws_internet_gateway.public.id}"
}

output "route_table_public_id" {
  value = "${aws_route_table.public.id}"
}
