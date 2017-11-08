## Modules: aws/network/public_subnet

This module creates all resources necessary for an AWS public
subnet.

Subnet CIDR and AZ are specified in the maps `subnet_cidrs` and
`subnet_availability_zones`, where the key is the name of the
subnet and must be the same in both maps.

For instance, to create two public subnets named "my_subnet_a"
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


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| default_tags | Additional resource tags | map | `<map>` | no |
| route_table_public_id | The ID of the route table in the VPC | string | - | yes |
| subnet_availability_zones | A map of which AZs the subnets should be created in. | map | - | yes |
| subnet_cidrs | A map of the CIDRs for the subnets being created. | map | - | yes |
| vpc_id | The ID of the VPC in which the public subnet is created. | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| subnet_ids | List containing the IDs of the created subnets. |
| subnet_names_ids_map | Map containing the pair name-id for each subnet created. |

