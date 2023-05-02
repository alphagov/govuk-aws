/**
* ## Modules: aws/network/public_subnet
*
* This module creates all resources necessary for an AWS public
* subnet.
*
* Subnet CIDR and AZ are specified in the maps `subnet_cidrs` and
* `subnet_availability_zones`, where the key is the name of the
* subnet and must be the same in both maps.
*
* For instance, to create two public subnets named "my_subnet_a"
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
*/

variable "default_tags" {
  type        = "map"
  description = "Additional resource tags"
  default     = {}
}

variable "vpc_id" {
  type        = "string"
  description = "The ID of the VPC in which the public subnet is created."
}

variable "route_table_public_id" {
  type        = "string"
  description = "The ID of the route table in the VPC"
}

variable "subnet_cidrs" {
  type        = "map"
  description = "A map of the CIDRs for the subnets being created."
}

variable "subnet_availability_zones" {
  type        = "map"
  description = "A map of which AZs the subnets should be created in."
}

# Resources
#--------------------------------------------------------------

resource "aws_subnet" "public" {
  count             = "${length(keys(var.subnet_cidrs))}"
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "${element(values(var.subnet_cidrs), count.index)}"
  availability_zone = "${lookup(var.subnet_availability_zones, element(keys(var.subnet_cidrs), count.index))}"

  tags = "${merge(var.default_tags, map("Name", element(keys(var.subnet_cidrs), count.index)))}"

  lifecycle {
    create_before_destroy = true
  }

  map_public_ip_on_launch = true
}

resource "aws_route_table_association" "public" {
  count          = "${length(keys(var.subnet_cidrs))}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${var.route_table_public_id}"
}

# Outputs
#--------------------------------------------------------------

output "subnet_ids" {
  value       = "${aws_subnet.public.*.id}"
  description = "List containing the IDs of the created subnets."
}

output "subnet_names_ids_map" {
  value       = "${zipmap(aws_subnet.public.*.tags.Name, aws_subnet.public.*.id)}"
  description = "Map containing the pair name-id for each subnet created."
}
