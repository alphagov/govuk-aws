## Project: infra-networking

This module governs the creation of full network stacks.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 0.12.31 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 2.46.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_template"></a> [template](#provider\_template) | n/a |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_infra_alarms_natgateway"></a> [infra\_alarms\_natgateway](#module\_infra\_alarms\_natgateway) | ../../modules/aws/alarms/natgateway | n/a |
| <a name="module_infra_nat"></a> [infra\_nat](#module\_infra\_nat) | ../../modules/aws/network/nat | n/a |
| <a name="module_infra_private_subnet"></a> [infra\_private\_subnet](#module\_infra\_private\_subnet) | ../../modules/aws/network/private_subnet | n/a |
| <a name="module_infra_private_subnet_elasticache"></a> [infra\_private\_subnet\_elasticache](#module\_infra\_private\_subnet\_elasticache) | ../../modules/aws/network/private_subnet | n/a |
| <a name="module_infra_private_subnet_elasticsearch"></a> [infra\_private\_subnet\_elasticsearch](#module\_infra\_private\_subnet\_elasticsearch) | ../../modules/aws/network/private_subnet | n/a |
| <a name="module_infra_private_subnet_rds"></a> [infra\_private\_subnet\_rds](#module\_infra\_private\_subnet\_rds) | ../../modules/aws/network/private_subnet | n/a |
| <a name="module_infra_private_subnet_reserved_ips"></a> [infra\_private\_subnet\_reserved\_ips](#module\_infra\_private\_subnet\_reserved\_ips) | ../../modules/aws/network/private_subnet | n/a |
| <a name="module_infra_public_subnet"></a> [infra\_public\_subnet](#module\_infra\_public\_subnet) | ../../modules/aws/network/public_subnet | n/a |

## Resources

| Name | Type |
|------|------|
| [template_file.nat_gateway_association_nat_id](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.nat_gateway_association_subnet_id](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [terraform_remote_state.infra_monitoring](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_vpc](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"eu-west-1"` | no |
| <a name="input_private_subnet_availability_zones"></a> [private\_subnet\_availability\_zones](#input\_private\_subnet\_availability\_zones) | Map containing private subnet names and availability zones associated | `map` | n/a | yes |
| <a name="input_private_subnet_cidrs"></a> [private\_subnet\_cidrs](#input\_private\_subnet\_cidrs) | Map containing private subnet names and CIDR associated | `map` | n/a | yes |
| <a name="input_private_subnet_elasticache_availability_zones"></a> [private\_subnet\_elasticache\_availability\_zones](#input\_private\_subnet\_elasticache\_availability\_zones) | Map containing private elasticache subnet names and availability zones associated | `map` | `{}` | no |
| <a name="input_private_subnet_elasticache_cidrs"></a> [private\_subnet\_elasticache\_cidrs](#input\_private\_subnet\_elasticache\_cidrs) | Map containing private elasticache subnet names and CIDR associated | `map` | `{}` | no |
| <a name="input_private_subnet_elasticsearch_availability_zones"></a> [private\_subnet\_elasticsearch\_availability\_zones](#input\_private\_subnet\_elasticsearch\_availability\_zones) | Map containing private elasticsearch subnet names and availability zones associated | `map` | `{}` | no |
| <a name="input_private_subnet_elasticsearch_cidrs"></a> [private\_subnet\_elasticsearch\_cidrs](#input\_private\_subnet\_elasticsearch\_cidrs) | Map containing private elasticsearch subnet names and CIDR associated | `map` | `{}` | no |
| <a name="input_private_subnet_nat_gateway_association"></a> [private\_subnet\_nat\_gateway\_association](#input\_private\_subnet\_nat\_gateway\_association) | Map of private subnet names and public subnet used to route external traffic (the public subnet must be listed in public\_subnet\_nat\_gateway\_enable to ensure it has a NAT gateway attached) | `map` | n/a | yes |
| <a name="input_private_subnet_rds_availability_zones"></a> [private\_subnet\_rds\_availability\_zones](#input\_private\_subnet\_rds\_availability\_zones) | Map containing private rds subnet names and availability zones associated | `map` | `{}` | no |
| <a name="input_private_subnet_rds_cidrs"></a> [private\_subnet\_rds\_cidrs](#input\_private\_subnet\_rds\_cidrs) | Map containing private rds subnet names and CIDR associated | `map` | `{}` | no |
| <a name="input_private_subnet_reserved_ips_availability_zones"></a> [private\_subnet\_reserved\_ips\_availability\_zones](#input\_private\_subnet\_reserved\_ips\_availability\_zones) | Map containing private ENI subnet names and availability zones associated | `map` | `{}` | no |
| <a name="input_private_subnet_reserved_ips_cidrs"></a> [private\_subnet\_reserved\_ips\_cidrs](#input\_private\_subnet\_reserved\_ips\_cidrs) | Map containing private ENI subnet names and CIDR associated | `map` | `{}` | no |
| <a name="input_public_subnet_availability_zones"></a> [public\_subnet\_availability\_zones](#input\_public\_subnet\_availability\_zones) | Map containing public subnet names and availability zones associated | `map` | n/a | yes |
| <a name="input_public_subnet_cidrs"></a> [public\_subnet\_cidrs](#input\_public\_subnet\_cidrs) | Map containing public subnet names and CIDR associated | `map` | n/a | yes |
| <a name="input_public_subnet_nat_gateway_enable"></a> [public\_subnet\_nat\_gateway\_enable](#input\_public\_subnet\_nat\_gateway\_enable) | List of public subnet names where we want to create a NAT Gateway | `list` | n/a | yes |
| <a name="input_remote_state_bucket"></a> [remote\_state\_bucket](#input\_remote\_state\_bucket) | S3 bucket we store our terraform state in | `string` | n/a | yes |
| <a name="input_remote_state_infra_monitoring_key_stack"></a> [remote\_state\_infra\_monitoring\_key\_stack](#input\_remote\_state\_infra\_monitoring\_key\_stack) | Override stackname path to infra\_monitoring remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_vpc_key_stack"></a> [remote\_state\_infra\_vpc\_key\_stack](#input\_remote\_state\_infra\_vpc\_key\_stack) | Override infra\_vpc remote state path | `string` | `""` | no |
| <a name="input_shield_protection_enabled"></a> [shield\_protection\_enabled](#input\_shield\_protection\_enabled) | Whether or not to enable AWS Shield. Terraform 0.11 doesn't have booleans, so representing as string. | `string` | `"true"` | no |
| <a name="input_stackname"></a> [stackname](#input\_stackname) | Stackname | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nat_gateway_elastic_ips_list"></a> [nat\_gateway\_elastic\_ips\_list](#output\_nat\_gateway\_elastic\_ips\_list) | List containing the public IPs associated with the NAT gateways |
| <a name="output_private_subnet_elasticache_ids"></a> [private\_subnet\_elasticache\_ids](#output\_private\_subnet\_elasticache\_ids) | List of private subnet IDs |
| <a name="output_private_subnet_elasticache_names_azs_map"></a> [private\_subnet\_elasticache\_names\_azs\_map](#output\_private\_subnet\_elasticache\_names\_azs\_map) | n/a |
| <a name="output_private_subnet_elasticache_names_ids_map"></a> [private\_subnet\_elasticache\_names\_ids\_map](#output\_private\_subnet\_elasticache\_names\_ids\_map) | Map containing the pair name-id for each private subnet created |
| <a name="output_private_subnet_elasticache_names_route_tables_map"></a> [private\_subnet\_elasticache\_names\_route\_tables\_map](#output\_private\_subnet\_elasticache\_names\_route\_tables\_map) | Map containing the name of each private subnet and route\_table ID associated |
| <a name="output_private_subnet_elasticsearch_ids"></a> [private\_subnet\_elasticsearch\_ids](#output\_private\_subnet\_elasticsearch\_ids) | List of private subnet IDs |
| <a name="output_private_subnet_elasticsearch_names_azs_map"></a> [private\_subnet\_elasticsearch\_names\_azs\_map](#output\_private\_subnet\_elasticsearch\_names\_azs\_map) | n/a |
| <a name="output_private_subnet_elasticsearch_names_ids_map"></a> [private\_subnet\_elasticsearch\_names\_ids\_map](#output\_private\_subnet\_elasticsearch\_names\_ids\_map) | Map containing the pair name-id for each private subnet created |
| <a name="output_private_subnet_elasticsearch_names_route_tables_map"></a> [private\_subnet\_elasticsearch\_names\_route\_tables\_map](#output\_private\_subnet\_elasticsearch\_names\_route\_tables\_map) | Map containing the name of each private subnet and route\_table ID associated |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | List of private subnet IDs |
| <a name="output_private_subnet_names_azs_map"></a> [private\_subnet\_names\_azs\_map](#output\_private\_subnet\_names\_azs\_map) | n/a |
| <a name="output_private_subnet_names_ids_map"></a> [private\_subnet\_names\_ids\_map](#output\_private\_subnet\_names\_ids\_map) | Map containing the pair name-id for each private subnet created |
| <a name="output_private_subnet_names_route_tables_map"></a> [private\_subnet\_names\_route\_tables\_map](#output\_private\_subnet\_names\_route\_tables\_map) | Map containing the name of each private subnet and route\_table ID associated |
| <a name="output_private_subnet_rds_ids"></a> [private\_subnet\_rds\_ids](#output\_private\_subnet\_rds\_ids) | List of private subnet IDs |
| <a name="output_private_subnet_rds_names_azs_map"></a> [private\_subnet\_rds\_names\_azs\_map](#output\_private\_subnet\_rds\_names\_azs\_map) | n/a |
| <a name="output_private_subnet_rds_names_ids_map"></a> [private\_subnet\_rds\_names\_ids\_map](#output\_private\_subnet\_rds\_names\_ids\_map) | Map containing the pair name-id for each private subnet created |
| <a name="output_private_subnet_rds_names_route_tables_map"></a> [private\_subnet\_rds\_names\_route\_tables\_map](#output\_private\_subnet\_rds\_names\_route\_tables\_map) | Map containing the name of each private subnet and route\_table ID associated |
| <a name="output_private_subnet_reserved_ips_ids"></a> [private\_subnet\_reserved\_ips\_ids](#output\_private\_subnet\_reserved\_ips\_ids) | List of private subnet IDs |
| <a name="output_private_subnet_reserved_ips_names_azs_map"></a> [private\_subnet\_reserved\_ips\_names\_azs\_map](#output\_private\_subnet\_reserved\_ips\_names\_azs\_map) | n/a |
| <a name="output_private_subnet_reserved_ips_names_ids_map"></a> [private\_subnet\_reserved\_ips\_names\_ids\_map](#output\_private\_subnet\_reserved\_ips\_names\_ids\_map) | Map containing the pair name-id for each private subnet created |
| <a name="output_private_subnet_reserved_ips_names_route_tables_map"></a> [private\_subnet\_reserved\_ips\_names\_route\_tables\_map](#output\_private\_subnet\_reserved\_ips\_names\_route\_tables\_map) | Map containing the name of each private subnet and route\_table ID associated |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | List of public subnet IDs |
| <a name="output_public_subnet_names_azs_map"></a> [public\_subnet\_names\_azs\_map](#output\_public\_subnet\_names\_azs\_map) | n/a |
| <a name="output_public_subnet_names_ids_map"></a> [public\_subnet\_names\_ids\_map](#output\_public\_subnet\_names\_ids\_map) | Map containing the pair name-id for each public subnet created |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | VPC ID where the stack resources are created |
