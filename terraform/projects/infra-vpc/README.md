## Module: projects/infra-vpc

Creates the base VPC layer for an AWS stack, with VPC flow logs
and resources to export these logs to S3


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_region | AWS region | string | `eu-west-1` | no |
| carrenza_internal_net_cidr | Internal network range of the environment in Carrenza | string | - | yes |
| carrenza_vpn_endpoint_ip | Public IP address of the VPN gateway in Carrenza | string | - | yes |
| cloudwatch_log_retention | Number of days to retain Cloudwatch logs for | string | - | yes |
| remote_state_bucket | S3 bucket we store our terraform state in | string | - | yes |
| remote_state_infra_monitoring_key_stack | Override stackname path to infra_monitoring remote state | string | `` | no |
| stackname | Stackname | string | `` | no |
| traffic_type | The traffic type to capture. Allows ACCEPT, ALL or REJECT | string | `REJECT` | no |
| vpc_cidr | VPC IP address range, represented as a CIDR block | string | - | yes |
| vpc_name | A name tag for the VPC | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| aws_vpn_connection_id | The ID of the AWS to Carrenza VPN |
| internet_gateway_id | The ID of the Internet Gateway |
| route_table_public_id | The ID of the public routing table |
| vpc_cidr | The CIDR block of the VPC |
| vpc_id | The ID of the VPC |

