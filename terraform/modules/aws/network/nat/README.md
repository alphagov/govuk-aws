## Module: aws/network/nat

Create a NAT gateway and associated EIP on each one of the public
subnets provided.


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| subnet_ids | List of public subnet IDs where you want to create a NAT Gateway | list | - | yes |
| subnet_ids_length | Length of subnet_ids variable | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| nat_gateway_ids | List containing the IDs of the NAT gateways |
| nat_gateway_subnets_ids_map | Map containing the NAT gateway IDs and the public subnet ID where each one is located |

