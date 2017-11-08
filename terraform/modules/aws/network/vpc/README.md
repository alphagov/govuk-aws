## Modules: aws/network/vpc

This module creates a VPC, Internet Gateway and route associated


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| cidr | The cidr block of the desired VPC | string | - | yes |
| default_tags | Additional resource tags | map | `<map>` | no |
| name | A name tag for the VPC | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| internet_gateway_id | The ID of the Internet Gateway. |
| route_table_public_id | The ID of the public routing table associated with the Internet Gateway. |
| vpc_cidr | The CIDR block of the VPC. |
| vpc_id | The ID of the VPC. |

