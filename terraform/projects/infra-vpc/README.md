## Project: infra-vpc

Creates the base VPC layer for an AWS stack.


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_region | AWS region | string | `eu-west-1` | no |
| log_retention | Number of days to retain flow logs for | string | `3` | no |
| stackname | Stackname | string | `` | no |
| traffic_type | The traffic type to capture. Allows ACCEPT, ALL or REJECT | string | `REJECT` | no |
| vpc_cidr | VPC IP address range, represented as a CIDR block | string | - | yes |
| vpc_name | A name tag for the VPC | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| flow_log_id | AWS VPC Flog log ID |
| internet_gateway_id |  |
| route_table_public_id |  |
| vpc_cidr |  |
| vpc_id |  |

