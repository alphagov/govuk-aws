## Modules: aws/network/private_subnet

This module creates AWS private subnets on a given VPC, each one
with a route table and route table association.

Subnet CIDR and AZ are specified in the maps `subnet_cidrs` and
`subnet_availability_zones`, where the key is the name of the
subnet and must be the same in both maps.

For instance, to create two private subnets named "my_subnet_a"
and "my_subnet_b" on eu-west-1a and eu-west-1b, you can do:

```
subnet_cidrs = {
  "my_subnet_a" = "10.0.0.0/24"
  "my_subnet_b" = "10.0.1.0/24"
}

subnet_availability_zones = {
  "my_subnet_a" = "eu-west-1a"
  "my_subnet_b" = "eu-west-1b"
}
```

You can optionally provide a subnet_nat_gateways variable, indicating
the NAT Gateway ID that a subnet can use. If specified, then a
route will also be added by this module, enabling Internet access. The
keys in subnet_nat_gateways that identify the subnet name must match the
keys provided in subnet_cidrs and subnet_availability_zones.

If you provide subnet_nat_gateways, then subnet_nat_gateways_length
must also be provided with the number of elements in the subnet_nat_gateways
map. This is necessary to get around a Terraform issue that prevents a
"count" from evaluating computed values. Probably referenced here:
https://github.com/hashicorp/terraform/issues/10857

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| default\_tags | Additional resource tags | map | `<map>` | no |
| subnet\_availability\_zones | A map of which AZs the subnets should be created in. | map | n/a | yes |
| subnet\_cidrs | A map of the CIDRs for the subnets being created. | map | n/a | yes |
| subnet\_nat\_gateways | A map containing the NAT gateway IDs for the subnets being created. | map | `<map>` | no |
| subnet\_nat\_gateways\_length | Provide the number of elements in the map subnet\_nat\_gateways. | string | `"0"` | no |
| vpc\_id | The ID of the VPC in which the private subnet is created. | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| subnet\_ids | List of private subnet IDs |
| subnet\_names\_ids\_map | Map containing the name of each subnet created and ID associated |
| subnet\_names\_route\_tables\_map | Map containing the name of each subnet and route\_table ID associated |
| subnet\_route\_table\_ids | List of route\_table IDs |

