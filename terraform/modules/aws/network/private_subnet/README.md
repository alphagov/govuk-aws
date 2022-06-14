## Modules: aws/network/private\_subnet

This module creates AWS private subnets on a given VPC, each one
with a route table and route table association.

Subnet CIDR and AZ are specified in the maps `subnet_cidrs` and
`subnet_availability_zones`, where the key is the name of the
subnet and must be the same in both maps.

For instance, to create two private subnets named "my\_subnet\_a"
and "my\_subnet\_b" on eu-west-1a and eu-west-1b, you can do:

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

You can optionally provide a subnet\_nat\_gateways variable, indicating
the NAT Gateway ID that a subnet can use. If specified, then a
route will also be added by this module, enabling Internet access. The
keys in subnet\_nat\_gateways that identify the subnet name must match the
keys provided in subnet\_cidrs and subnet\_availability\_zones.

If you provide subnet\_nat\_gateways, then subnet\_nat\_gateways\_length
must also be provided with the number of elements in the subnet\_nat\_gateways
map. This is necessary to get around a Terraform issue that prevents a
"count" from evaluating computed values. Probably referenced here:
https://github.com/hashicorp/terraform/issues/10857

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
| [aws_route.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc_endpoint_route_table_association.private_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_route_table_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | Additional resource tags | `map` | `{}` | no |
| <a name="input_s3_gateway_id"></a> [s3\_gateway\_id](#input\_s3\_gateway\_id) | The ID of the AWS VPC Endpoint to use to communicate with S3 | `string` | n/a | yes |
| <a name="input_subnet_availability_zones"></a> [subnet\_availability\_zones](#input\_subnet\_availability\_zones) | A map of which AZs the subnets should be created in. | `map` | n/a | yes |
| <a name="input_subnet_cidrs"></a> [subnet\_cidrs](#input\_subnet\_cidrs) | A map of the CIDRs for the subnets being created. | `map` | n/a | yes |
| <a name="input_subnet_nat_gateways"></a> [subnet\_nat\_gateways](#input\_subnet\_nat\_gateways) | A map containing the NAT gateway IDs for the subnets being created. | `map` | `{}` | no |
| <a name="input_subnet_nat_gateways_length"></a> [subnet\_nat\_gateways\_length](#input\_subnet\_nat\_gateways\_length) | Provide the number of elements in the map subnet\_nat\_gateways. | `string` | `"0"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC in which the private subnet is created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | List of private subnet IDs |
| <a name="output_subnet_names_ids_map"></a> [subnet\_names\_ids\_map](#output\_subnet\_names\_ids\_map) | Map containing the name of each subnet created and ID associated |
| <a name="output_subnet_names_route_tables_map"></a> [subnet\_names\_route\_tables\_map](#output\_subnet\_names\_route\_tables\_map) | Map containing the name of each subnet and route\_table ID associated |
| <a name="output_subnet_route_table_ids"></a> [subnet\_route\_table\_ids](#output\_subnet\_route\_table\_ids) | List of route\_table IDs |
