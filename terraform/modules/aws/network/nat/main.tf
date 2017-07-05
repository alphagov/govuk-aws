# == Module: aws::network::nat
#
# Create a NAT gateway and associated EIP on each one of the public
# subnets provided.
#
# === Variables:
#
# subnet_ids
# subnet_ids_length
#
# === Outputs:
#
# nat_gateway_ids
# nat_gateway_subnets_ids_map
#

variable "subnet_ids" {
  type        = "list"
  description = "List of public subnet IDs where you want to create a NAT Gateway"
}

variable "subnet_ids_length" {
  type        = "string"
  description = "Length of subnet_ids variable"
}

# Resources
# --------------------------------------------------------------
resource "aws_eip" "nat" {
  count = "${var.subnet_ids_length}"
  vpc   = true

  lifecycle { create_before_destroy = true }
}

resource "aws_nat_gateway" "nat" {
  count         = "${var.subnet_ids_length}"
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id     = "${element(var.subnet_ids, count.index)}"

  lifecycle { create_before_destroy = true }
}

# Outputs
#--------------------------------------------------------------
output "nat_gateway_ids" {
  value       = ["${aws_nat_gateway.nat.*.id}"]
  description = "List containing the IDs of the NAT gateways"
}

output "nat_gateway_subnets_ids_map" {
  value       = "${zipmap(aws_nat_gateway.nat.*.subnet_id, aws_nat_gateway.nat.*.id)}"
  description = "Map containing the NAT gateway IDs and the public subnet ID where each one is located"
}

