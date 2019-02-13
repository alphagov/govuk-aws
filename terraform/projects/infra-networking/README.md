## Project: infra-networking

This module governs the creation of full network stacks.


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_region | AWS region | string | `eu-west-1` | no |
| private_subnet_availability_zones | Map containing private subnet names and availability zones associated | map | - | yes |
| private_subnet_cidrs | Map containing private subnet names and CIDR associated | map | - | yes |
| private_subnet_elasticache_availability_zones | Map containing private elasticache subnet names and availability zones associated | map | `<map>` | no |
| private_subnet_elasticache_cidrs | Map containing private elasticache subnet names and CIDR associated | map | `<map>` | no |
| private_subnet_elasticsearch_availability_zones | Map containing private elasticsearch subnet names and availability zones associated | map | `<map>` | no |
| private_subnet_elasticsearch_cidrs | Map containing private elasticsearch subnet names and CIDR associated | map | `<map>` | no |
| private_subnet_nat_gateway_association | Map of private subnet names and public subnet used to route external traffic (the public subnet must be listed in public_subnet_nat_gateway_enable to ensure it has a NAT gateway attached) | map | - | yes |
| private_subnet_rds_availability_zones | Map containing private rds subnet names and availability zones associated | map | `<map>` | no |
| private_subnet_rds_cidrs | Map containing private rds subnet names and CIDR associated | map | `<map>` | no |
| private_subnet_reserved_ips_availability_zones | Map containing private ENI subnet names and availability zones associated | map | `<map>` | no |
| private_subnet_reserved_ips_cidrs | Map containing private ENI subnet names and CIDR associated | map | `<map>` | no |
| public_subnet_availability_zones | Map containing public subnet names and availability zones associated | map | - | yes |
| public_subnet_cidrs | Map containing public subnet names and CIDR associated | map | - | yes |
| public_subnet_nat_gateway_enable | List of public subnet names where we want to create a NAT Gateway | list | - | yes |
| remote_state_bucket | S3 bucket we store our terraform state in | string | - | yes |
| remote_state_infra_monitoring_key_stack | Override stackname path to infra_monitoring remote state | string | `` | no |
| remote_state_infra_vpc_key_stack | Override infra_vpc remote state path | string | `` | no |
| stackname | Stackname | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| private_subnet_elasticache_ids | List of private subnet IDs |
| private_subnet_elasticache_names_azs_map |  |
| private_subnet_elasticache_names_ids_map | Map containing the pair name-id for each private subnet created |
| private_subnet_elasticache_names_route_tables_map | Map containing the name of each private subnet and route_table ID associated |
| private_subnet_elasticsearch_ids | List of private subnet IDs |
| private_subnet_elasticsearch_names_azs_map |  |
| private_subnet_elasticsearch_names_ids_map | Map containing the pair name-id for each private subnet created |
| private_subnet_elasticsearch_names_route_tables_map | Map containing the name of each private subnet and route_table ID associated |
| private_subnet_ids | List of private subnet IDs |
| private_subnet_names_azs_map |  |
| private_subnet_names_ids_map | Map containing the pair name-id for each private subnet created |
| private_subnet_names_route_tables_map | Map containing the name of each private subnet and route_table ID associated |
| private_subnet_rds_ids | List of private subnet IDs |
| private_subnet_rds_names_azs_map |  |
| private_subnet_rds_names_ids_map | Map containing the pair name-id for each private subnet created |
| private_subnet_rds_names_route_tables_map | Map containing the name of each private subnet and route_table ID associated |
| private_subnet_reserved_ips_ids | List of private subnet IDs |
| private_subnet_reserved_ips_names_azs_map |  |
| private_subnet_reserved_ips_names_ids_map | Map containing the pair name-id for each private subnet created |
| private_subnet_reserved_ips_names_route_tables_map | Map containing the name of each private subnet and route_table ID associated |
| public_subnet_ids | List of public subnet IDs |
| public_subnet_names_azs_map |  |
| public_subnet_names_ids_map | Map containing the pair name-id for each public subnet created |
| vpc_id | Outputs -------------------------------------------------------------- |

