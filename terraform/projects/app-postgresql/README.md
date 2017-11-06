## Project: projects/app-postgresql

RDS PostgreSQL instances


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_environment | AWS Environment | string | - | yes |
| aws_region | AWS region | string | `eu-west-1` | no |
| cloudwatch_log_retention | Number of days to retain Cloudwatch logs for | string | - | yes |
| multi_az | Enable multi-az. | string | `false` | no |
| password | DB password | string | - | yes |
| remote_state_bucket | S3 bucket we store our terraform state in | string | - | yes |
| remote_state_infra_aws_logging_key_stack | Override stackname path to infra_aws_logging remote state | string | `` | no |
| remote_state_infra_networking_key_stack | Override infra_networking remote state path | string | `` | no |
| remote_state_infra_security_groups_key_stack | Override infra_security_groups stackname path to infra_vpc remote state | string | `` | no |
| remote_state_infra_stack_dns_zones_key_stack | Override stackname path to infra_vpc remote state | string | `` | no |
| remote_state_infra_stack_sns_alerts_key_stack | Override stackname path to infra_stack_sns_alerts remote state | string | `` | no |
| remote_state_infra_vpc_key_stack | Override infra_vpc remote state path | string | `` | no |
| stackname | Stackname | string | - | yes |
| username | PostgreSQL username | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| postgresql-primary_address | postgresql instance address |
| postgresql-primary_endpoint | postgresql instance endpoint |
| postgresql-primary_id | postgresql instance ID |
| postgresql-primary_resource_id | postgresql instance resource ID |
| postgresql-standby_address | postgresql replica instance address |
| postgresql-standby_endpoint | postgresql replica instance endpoint |

