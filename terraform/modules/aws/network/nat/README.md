## Module: aws/network/nat

Create a NAT gateway and associated EIP on each one of the public
subnets provided.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_nat_gateway.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_shield_protection.aws_eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/shield_protection) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_shield_protection_enabled"></a> [shield\_protection\_enabled](#input\_shield\_protection\_enabled) | Whether or not to enable AWS Shield. Terraform 0.11 doesn't have booleans, so representing as string. | `string` | `"true"` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of public subnet IDs where you want to create a NAT Gateway | `list` | n/a | yes |
| <a name="input_subnet_ids_length"></a> [subnet\_ids\_length](#input\_subnet\_ids\_length) | Length of subnet\_ids variable | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nat_gateway_elastic_ips_list"></a> [nat\_gateway\_elastic\_ips\_list](#output\_nat\_gateway\_elastic\_ips\_list) | List containing the public IPs associated with the NAT gateways |
| <a name="output_nat_gateway_ids"></a> [nat\_gateway\_ids](#output\_nat\_gateway\_ids) | List containing the IDs of the NAT gateways |
| <a name="output_nat_gateway_subnets_ids_map"></a> [nat\_gateway\_subnets\_ids\_map](#output\_nat\_gateway\_subnets\_ids\_map) | Map containing the NAT gateway IDs and the public subnet ID where each one is located |
