## Project: infra-networking

This module governs the creation of full network stacks.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws\_region | AWS region | string | `"eu-west-1"` | no |
| private\_subnet\_availability\_zones | Map containing private subnet names and availability zones associated | map | n/a | yes |
| private\_subnet\_cidrs | Map containing private subnet names and CIDR associated | map | n/a | yes |
| private\_subnet\_elasticache\_availability\_zones | Map containing private elasticache subnet names and availability zones associated | map | `<map>` | no |
| private\_subnet\_elasticache\_cidrs | Map containing private elasticache subnet names and CIDR associated | map | `<map>` | no |
| private\_subnet\_elasticsearch\_availability\_zones | Map containing private elasticsearch subnet names and availability zones associated | map | `<map>` | no |
| private\_subnet\_elasticsearch\_cidrs | Map containing private elasticsearch subnet names and CIDR associated | map | `<map>` | no |
| private\_subnet\_nat\_gateway\_association | Map of private subnet names and public subnet used to route external traffic \(the public subnet must be listed in public\_subnet\_nat\_gateway\_enable to ensure it has a NAT gateway attached\) | map | n/a | yes |
| private\_subnet\_rds\_availability\_zones | Map containing private rds subnet names and availability zones associated | map | `<map>` | no |
| private\_subnet\_rds\_cidrs | Map containing private rds subnet names and CIDR associated | map | `<map>` | no |
| private\_subnet\_reserved\_ips\_availability\_zones | Map containing private ENI subnet names and availability zones associated | map | `<map>` | no |
| private\_subnet\_reserved\_ips\_cidrs | Map containing private ENI subnet names and CIDR associated | map | `<map>` | no |
| public\_subnet\_availability\_zones | Map containing public subnet names and availability zones associated | map | n/a | yes |
| public\_subnet\_cidrs | Map containing public subnet names and CIDR associated | map | n/a | yes |
| public\_subnet\_nat\_gateway\_enable | List of public subnet names where we want to create a NAT Gateway | list | n/a | yes |
| remote\_state\_bucket | S3 bucket we store our terraform state in | string | n/a | yes |
| remote\_state\_infra\_monitoring\_key\_stack | Override stackname path to infra\_monitoring remote state | string | `""` | no |
| remote\_state\_infra\_vpc\_key\_stack | Override infra\_vpc remote state path | string | `""` | no |
| stackname | Stackname | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| nat\_gateway\_elastic\_ips\_list | List containing the public IPs associated with the NAT gateways |
| private\_subnet\_elasticache\_ids | List of private subnet IDs |
| private\_subnet\_elasticache\_names\_azs\_map |  |
| private\_subnet\_elasticache\_names\_ids\_map | Map containing the pair name-id for each private subnet created |
| private\_subnet\_elasticache\_names\_route\_tables\_map | Map containing the name of each private subnet and route\_table ID associated |
| private\_subnet\_elasticsearch\_ids | List of private subnet IDs |
| private\_subnet\_elasticsearch\_names\_azs\_map |  |
| private\_subnet\_elasticsearch\_names\_ids\_map | Map containing the pair name-id for each private subnet created |
| private\_subnet\_elasticsearch\_names\_route\_tables\_map | Map containing the name of each private subnet and route\_table ID associated |
| private\_subnet\_ids | List of private subnet IDs |
| private\_subnet\_names\_azs\_map |  |
| private\_subnet\_names\_ids\_map | Map containing the pair name-id for each private subnet created |
| private\_subnet\_names\_route\_tables\_map | Map containing the name of each private subnet and route\_table ID associated |
| private\_subnet\_rds\_ids | List of private subnet IDs |
| private\_subnet\_rds\_names\_azs\_map |  |
| private\_subnet\_rds\_names\_ids\_map | Map containing the pair name-id for each private subnet created |
| private\_subnet\_rds\_names\_route\_tables\_map | Map containing the name of each private subnet and route\_table ID associated |
| private\_subnet\_reserved\_ips\_ids | List of private subnet IDs |
| private\_subnet\_reserved\_ips\_names\_azs\_map |  |
| private\_subnet\_reserved\_ips\_names\_ids\_map | Map containing the pair name-id for each private subnet created |
| private\_subnet\_reserved\_ips\_names\_route\_tables\_map | Map containing the name of each private subnet and route\_table ID associated |
| public\_subnet\_ids | List of public subnet IDs |
| public\_subnet\_names\_azs\_map |  |
| public\_subnet\_names\_ids\_map | Map containing the pair name-id for each public subnet created |
| vpc\_id | VPC ID where the stack resources are created |

