## Modules: aws/network/vpc

This module creates a VPC, Internet Gateway and route associated

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) |
| [aws_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) |
| [aws_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cidr | The cidr block of the desired VPC | `string` | n/a | yes |
| default\_tags | Additional resource tags | `map` | `{}` | no |
| name | A name tag for the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| internet\_gateway\_id | The ID of the Internet Gateway. |
| route\_table\_public\_id | The ID of the public routing table associated with the Internet Gateway. |
| vpc\_cidr | The CIDR block of the VPC. |
| vpc\_id | The ID of the VPC. |
