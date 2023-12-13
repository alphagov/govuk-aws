/**
* ## Module: aws/network/nat
*
* Create a NAT gateway and associated EIP on each one of the public
* subnets provided.
*/

variable "shield_protection_enabled" {
  type        = string
  description = "Whether or not to enable AWS Shield. Terraform 0.11 doesn't have booleans, so representing as string."
  default     = "true"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs where you want to create a NAT Gateway"
}

variable "subnet_ids_length" {
  type        = string
  description = "Length of subnet_ids variable"
}

# Resources
# --------------------------------------------------------------
resource "aws_eip" "nat" {
  count = var.subnet_ids_length
  vpc   = true

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_shield_protection" "aws_eip" {
  count        = var.shield_protection_enabled ? length(aws_eip.nat.*.id) : 0
  name         = "${element(aws_eip.nat.*.id, count.index)}_shield"
  resource_arn = "arn:aws:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:eip-allocation/${element(aws_eip.nat.*.id, count.index)}"
}

resource "aws_nat_gateway" "nat" {
  count         = var.subnet_ids_length
  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(var.subnet_ids, count.index)

  lifecycle {
    create_before_destroy = true
  }
}

# Outputs
#--------------------------------------------------------------

output "nat_gateway_ids" {
  value       = aws_nat_gateway.nat.*.id
  description = "List containing the IDs of the NAT gateways"
}

output "nat_gateway_subnets_ids_map" {
  value       = zipmap(aws_nat_gateway.nat.*.subnet_id, aws_nat_gateway.nat.*.id)
  description = "Map containing the NAT gateway IDs and the public subnet ID where each one is located"
}

output "nat_gateway_elastic_ips_list" {
  value       = aws_eip.nat.*.public_ip
  description = "List containing the public IPs associated with the NAT gateways"
}
