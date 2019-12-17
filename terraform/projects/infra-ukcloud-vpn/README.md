## Module: projects/infra-ukcloud-vpn

Creates a VPN for AWS to connect to ukcloud

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws\_environment | AWS Environment | string | n/a | yes |
| aws\_region | AWS region | string | `"eu-west-1"` | no |
| aws\_tunnel1\_psk | Explicit PSK in format required by UKCloud | string | n/a | yes |
| aws\_tunnel2\_psk | Explicit PSK in format required by UKCloud | string | n/a | yes |
| aws\_vpn\_gateway\_id | ID of Virtual Private Gateway to use with VPN | string | `""` | no |
| civica\_cidr | Civica ip/network range | string | n/a | yes |
| remote\_state\_bucket | S3 bucket we store our terraform state in | string | n/a | yes |
| remote\_state\_infra\_networking\_key\_stack | Override stackname path to infra\_monitoring remote state | string | `""` | no |
| remote\_state\_infra\_vpc\_key\_stack | Override stackname path to infra\_monitoring remote state | string | `""` | no |
| stackname | Stackname | string | `""` | no |
| ukcloud\_vpn\_endpoint\_ip | Public IP address of the VPN gateway in ukcloud | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| aws\_vpn\_connection\_id | The ID of the AWS to ukcloud VPN |

