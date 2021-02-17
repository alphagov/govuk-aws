## Module: projects/infra-ukcloud-vpn

Creates a VPN for AWS to connect to ukcloud

## Requirements

| Name | Version |
|------|---------|
| terraform | = 0.11.14 |
| aws | 2.46.0 |

## Providers

| Name | Version |
|------|---------|
| aws | 2.46.0 |
| terraform | n/a |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_customer_gateway](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/customer_gateway) |
| [aws_vpn_connection](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/vpn_connection) |
| [aws_vpn_connection_route](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/vpn_connection_route) |
| [aws_vpn_gateway_route_propagation](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/vpn_gateway_route_propagation) |
| [terraform_remote_state](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_environment | AWS Environment | `string` | n/a | yes |
| aws\_region | AWS region | `string` | `"eu-west-1"` | no |
| aws\_tunnel1\_psk | Explicit PSK in format required by UKCloud | `string` | n/a | yes |
| aws\_tunnel2\_psk | Explicit PSK in format required by UKCloud | `string` | n/a | yes |
| aws\_vpn\_gateway\_id | ID of Virtual Private Gateway to use with VPN | `string` | `""` | no |
| civica\_cidr | Civica ip/network range | `string` | n/a | yes |
| remote\_state\_bucket | S3 bucket we store our terraform state in | `string` | n/a | yes |
| remote\_state\_infra\_networking\_key\_stack | Override stackname path to infra\_monitoring remote state | `string` | `""` | no |
| remote\_state\_infra\_vpc\_key\_stack | Override stackname path to infra\_monitoring remote state | `string` | `""` | no |
| stackname | Stackname | `string` | `""` | no |
| ukcloud\_vpn\_endpoint\_ip | Public IP address of the VPN gateway in ukcloud | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| aws\_vpn\_connection\_id | The ID of the AWS to ukcloud VPN |
