## Module: projects/infra-carrenza-vpn

Creates a VPN for AWS to connect to Carrenza


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_region | AWS region | string | `eu-west-1` | no |
| aws_tunnel1_psk | Explicit PSK in format required by Carrenza | string | - | yes |
| aws_tunnel2_psk | Explicit PSK in format required by Carrenza | string | - | yes |
| carrenza_internal_net_cidr | Internal network range of the environment in Carrenza | string | - | yes |
| carrenza_vpn_endpoint_ip | Public IP address of the VPN gateway in Carrenza | string | - | yes |
| remote_state_bucket | S3 bucket we store our terraform state in | string | - | yes |
| remote_state_infra_networking_key_stack | Override stackname path to infra_monitoring remote state | string | `` | no |
| remote_state_infra_vpc_key_stack | Override stackname path to infra_monitoring remote state | string | `` | no |
| stackname | Stackname | string | `` | no |

## Outputs

| Name | Description |
|------|-------------|
| aws_vpn_connection_id | The ID of the AWS to Carrenza VPN |

