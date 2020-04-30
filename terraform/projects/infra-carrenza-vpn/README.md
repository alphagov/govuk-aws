## Module: projects/infra-carrenza-vpn

Creates a VPN for AWS to connect to Carrenza

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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_region | AWS region | `string` | `"eu-west-1"` | no |
| aws\_tunnel1\_psk | Explicit PSK in format required by Carrenza | `string` | n/a | yes |
| aws\_tunnel2\_psk | Explicit PSK in format required by Carrenza | `string` | n/a | yes |
| carrenza\_internal\_net\_cidr | Internal network range of the environment in Carrenza | `string` | n/a | yes |
| carrenza\_vpn\_endpoint\_ip | Public IP address of the VPN gateway in Carrenza | `string` | n/a | yes |
| remote\_state\_bucket | S3 bucket we store our terraform state in | `string` | n/a | yes |
| remote\_state\_infra\_networking\_key\_stack | Override stackname path to infra\_monitoring remote state | `string` | `""` | no |
| remote\_state\_infra\_vpc\_key\_stack | Override stackname path to infra\_monitoring remote state | `string` | `""` | no |
| stackname | Stackname | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| aws\_vpn\_connection\_id | The ID of the AWS to Carrenza VPN |

