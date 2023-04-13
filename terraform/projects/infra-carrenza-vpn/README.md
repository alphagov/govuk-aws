## Module: projects/infra-carrenza-vpn

Creates a VPN for AWS to connect to Carrenza

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | = 0.12.30 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 2.46.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 2.46.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_customer_gateway.carrenza_vpn_gateway](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/customer_gateway) | resource |
| [aws_vpn_connection.aws_carrenza_vpn](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/vpn_connection) | resource |
| [aws_vpn_connection_route.Carrenza](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/vpn_connection_route) | resource |
| [aws_vpn_gateway.aws_vpn_gateway](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/vpn_gateway) | resource |
| [aws_vpn_gateway_route_propagation.Carrenza_route_propagation](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/vpn_gateway_route_propagation) | resource |
| [aws_vpn_gateway_route_propagation.Carrenza_route_propagation_reserved_ips](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/vpn_gateway_route_propagation) | resource |
| [terraform_remote_state.infra_networking](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_vpc](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"eu-west-1"` | no |
| <a name="input_aws_tunnel1_psk"></a> [aws\_tunnel1\_psk](#input\_aws\_tunnel1\_psk) | Explicit PSK in format required by Carrenza | `string` | n/a | yes |
| <a name="input_aws_tunnel2_psk"></a> [aws\_tunnel2\_psk](#input\_aws\_tunnel2\_psk) | Explicit PSK in format required by Carrenza | `string` | n/a | yes |
| <a name="input_carrenza_internal_net_cidr"></a> [carrenza\_internal\_net\_cidr](#input\_carrenza\_internal\_net\_cidr) | Internal network range of the environment in Carrenza | `string` | n/a | yes |
| <a name="input_carrenza_vpn_endpoint_ip"></a> [carrenza\_vpn\_endpoint\_ip](#input\_carrenza\_vpn\_endpoint\_ip) | Public IP address of the VPN gateway in Carrenza | `string` | n/a | yes |
| <a name="input_remote_state_bucket"></a> [remote\_state\_bucket](#input\_remote\_state\_bucket) | S3 bucket we store our terraform state in | `string` | n/a | yes |
| <a name="input_remote_state_infra_networking_key_stack"></a> [remote\_state\_infra\_networking\_key\_stack](#input\_remote\_state\_infra\_networking\_key\_stack) | Override stackname path to infra\_monitoring remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_vpc_key_stack"></a> [remote\_state\_infra\_vpc\_key\_stack](#input\_remote\_state\_infra\_vpc\_key\_stack) | Override stackname path to infra\_monitoring remote state | `string` | `""` | no |
| <a name="input_stackname"></a> [stackname](#input\_stackname) | Stackname | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_vpn_connection_id"></a> [aws\_vpn\_connection\_id](#output\_aws\_vpn\_connection\_id) | The ID of the AWS to Carrenza VPN |
