# == Modules: aws::network::private_subnet
#
# This module creates AWS private subnets on a given VPC, each one
# with a route table and route table association.
#
# You can optionally provide a subnet_nat_gateways variable, indicating
# the NAT Gateway ID that a subnet can use. If specified, then a
# route will also be added by this module, enabling Internet access.
#
# If you provide subnet_nat_gateways, then subnet_nat_gateways_length
# must also be provided with the number of elements in the subnet_nat_gateways
# map. This is necessary to get around a Terraform issue that prevents a
# "count" from evaluating computed values. Probably referenced here:
# https://github.com/hashicorp/terraform/issues/10857
#
# === Variables:
#
# tag_project
# vpc_id
# subnet_cidrs
# subnet_availability_zones
# subnet_nat_gateways
# subnet_nat_gateways_length
#
# === Outputs:
#
# subnet_ids
# subnet_names_ids_map
# subnet_route_table_ids
# subnet_names_route_tables_map
#
variable "tag_project" {
  type        = "string"
  description = "The project tag."
  default     = ""
}

variable "vpc_id" {
  type        = "string"
  description = "The ID of the VPC in which the private subnet is created."
}

variable "subnet_cidrs" {
  type        = "map"
  description = "A map of the CIDRs for the subnets being created."
}

variable "subnet_availability_zones" {
  type        = "map"
  description = "A map of which AZs the subnets should be created in."
}

variable "subnet_nat_gateways" {
  type        = "map"
  description = "A map containing the NAT gateway IDs for the subnets being created."
  default     = { }
}

variable "subnet_nat_gateways_length" {
  type        = "string"
  description = "Provide the number of elements in the map subnet_nat_gateways (https://github"
  default     = "0"
}

# Resources
#--------------------------------------------------------------
resource "aws_subnet" "private" {
  count             = "${length(keys(var.subnet_cidrs))}"
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "${element(values(var.subnet_cidrs), count.index)}"
  availability_zone = "${lookup(var.subnet_availability_zones, element(keys(var.subnet_cidrs), count.index))}"

  tags {
    Name    = "${element(keys(var.subnet_cidrs), count.index)}"
    Project = "${var.tag_project}"
  }

  lifecycle {
    create_before_destroy = true
  }

  map_public_ip_on_launch = false
}

resource "aws_route_table" "private" {
  count  = "${length(keys(var.subnet_cidrs))}"
  vpc_id = "${var.vpc_id}"

  tags {
    Name    = "${element(keys(var.subnet_cidrs), count.index)}"
    Project = "${var.tag_project}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table_association" "private" {
  count          = "${length(keys(var.subnet_cidrs))}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}

resource "aws_route" "nat" {
  count                  = "${var.subnet_nat_gateways_length}"
  route_table_id         = "${lookup(zipmap(aws_route_table.private.*.tags.Name, aws_route_table.private.*.id), element(keys(var.subnet_nat_gateways), count.index))}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(values(var.subnet_nat_gateways), count.index)}"
}

# Outputs
#--------------------------------------------------------------
output "subnet_ids" {
  value       = ["${aws_subnet.private.*.id}"]
  description = "List of private subnet IDs"
}

output "subnet_names_ids_map" {
  value       = "${zipmap(aws_subnet.private.*.tags.Name, aws_subnet.private.*.id)}"
  description = "Map containing the name of each subnet created and ID associated"
}

output "subnet_route_table_ids" {
  value       = ["${aws_route_table.private.*.id}"]
  description = "List of route_table IDs"
}

output "subnet_names_route_tables_map" {
  value       = "${zipmap(aws_route_table.private.*.tags.Name, aws_route_table.private.*.id)}"
  description = "Map containing the name of each subnet and route_table ID associated"
}
