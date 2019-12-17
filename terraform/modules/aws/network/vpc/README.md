## Modules: aws/network/vpc

This module creates a VPC, Internet Gateway and route associated

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| cidr | The cidr block of the desired VPC | string | n/a | yes |
| default\_tags | Additional resource tags | map | `<map>` | no |
| name | A name tag for the VPC | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| internet\_gateway\_id | The ID of the Internet Gateway. |
| route\_table\_public\_id | The ID of the public routing table associated with the Internet Gateway. |
| vpc\_cidr | The CIDR block of the VPC. |
| vpc\_id | The ID of the VPC. |

