/**
* ## Modules: aws/network/private_subnet
*
* This module creates AWS private subnets on a given VPC, each one
* with a route table and route table association.
*
* Subnet CIDR and AZ are specified in the maps `subnet_cidrs` and
* `subnet_availability_zones`, where the key is the name of the
* subnet and must be the same in both maps.
*
* For instance, to create two private subnets named "my_subnet_a"
* and "my_subnet_b" on eu-west-1a and eu-west-1b, you can do:
*
* ```
* subnet_cidrs = {
*   "my_subnet_a" = "10.0.0.0/24"
*   "my_subnet_b" = "10.0.1.0/24"
* }
*
* subnet_availability_zones = {
*   "my_subnet_a" = "eu-west-1a"
*   "my_subnet_b" = "eu-west-1b"
* }
* ```
*
* You can optionally provide a subnet_nat_gateways variable, indicating
* the NAT Gateway ID that a subnet can use. If specified, then a
* route will also be added by this module, enabling Internet access. The
* keys in subnet_nat_gateways that identify the subnet name must match the
* keys provided in subnet_cidrs and subnet_availability_zones.
*
* If you provide subnet_nat_gateways, then subnet_nat_gateways_length
* must also be provided with the number of elements in the subnet_nat_gateways
* map. This is necessary to get around a Terraform issue that prevents a
* "count" from evaluating computed values. Probably referenced here:
* https://github.com/hashicorp/terraform/issues/10857
*/

variable "default_tags" {
  type        = map(string)
  description = "Additional resource tags"
  default     = {}
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC in which the private subnet is created."
}

variable "subnet_cidrs" {
  type        = map(string)
  description = "A map of the CIDRs for the subnets being created."
}

variable "subnet_availability_zones" {
  type        = map(string)
  description = "A map of which AZs the subnets should be created in."
}

variable "s3_gateway_id" {
  type        = string
  description = "The ID of the AWS VPC Endpoint to use to communicate with S3"
}

variable "subnet_nat_gateways" {
  type        = map(string)
  description = "A map containing the NAT gateway IDs for the subnets being created."
  default     = {}
}

variable "subnet_nat_gateways_length" {
  type        = string
  description = "Provide the number of elements in the map subnet_nat_gateways."
  default     = "0"
}

# Resources
#--------------------------------------------------------------

resource "aws_subnet" "private" {
  count             = length(keys(var.subnet_cidrs))
  vpc_id            = var.vpc_id
  cidr_block        = element(values(var.subnet_cidrs), count.index)
  availability_zone = lookup(var.subnet_availability_zones, element(keys(var.subnet_cidrs), count.index))

  tags = merge(var.default_tags, map("Name", element(keys(var.subnet_cidrs), count.index)))

  lifecycle {
    create_before_destroy = true
  }

  map_public_ip_on_launch = false
}

resource "aws_route_table" "private" {
  count  = length(keys(var.subnet_cidrs))
  vpc_id = var.vpc_id

  tags = merge(var.default_tags, map("Name", element(keys(var.subnet_cidrs), count.index)))

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table_association" "private" {
  count          = length(keys(var.subnet_cidrs))
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

resource "aws_route" "nat" {
  count                  = var.subnet_nat_gateways_length
  route_table_id         = lookup(zipmap(aws_route_table.private.*.tags.Name, aws_route_table.private.*.id), element(keys(var.subnet_nat_gateways), count.index))
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(values(var.subnet_nat_gateways), count.index)
}

resource "aws_vpc_endpoint_route_table_association" "private_s3" {
  count           = length(keys(var.subnet_cidrs))
  vpc_endpoint_id = var.s3_gateway_id
  route_table_id  = element(aws_route_table.private.*.id, count.index)
}

# Outputs
#--------------------------------------------------------------

output "subnet_ids" {
  value       = aws_subnet.private.*.id
  description = "List of private subnet IDs"
}

output "subnet_names_ids_map" {
  value       = zipmap(aws_subnet.private.*.tags.Name, aws_subnet.private.*.id)
  description = "Map containing the name of each subnet created and ID associated"
}

output "subnet_route_table_ids" {
  value       = aws_route_table.private.*.id
  description = "List of route_table IDs"
}

output "subnet_names_route_tables_map" {
  value       = zipmap(aws_route_table.private.*.tags.Name, aws_route_table.private.*.id)
  description = "Map containing the name of each subnet and route_table ID associated"
}
