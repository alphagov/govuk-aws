## Project: projects/app-warehouse

RDS PostgreSQL instance for the GOV.UK data warehouse


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_environment | AWS Environment | string | - | yes |
| aws_region | AWS region | string | `eu-west-1` | no |
| cloudwatch_log_retention | Number of days to retain Cloudwatch logs for | string | - | yes |
| multi_az | Enable multi-az. | string | `false` | no |
| password | DB password | string | - | yes |
| remote_state_bucket | S3 bucket we store our terraform state in | string | - | yes |
| remote_state_infra_monitoring_key_stack | Override stackname path to infra_monitoring remote state | string | `` | no |
| remote_state_infra_networking_key_stack | Override infra_networking remote state path | string | `` | no |
| remote_state_infra_root_dns_zones_key_stack | Override stackname path to infra_root_dns_zones remote state | string | `` | no |
| remote_state_infra_security_groups_key_stack | Override infra_security_groups stackname path to infra_vpc remote state | string | `` | no |
| remote_state_infra_stack_dns_zones_key_stack | Override stackname path to infra_stack_dns_zones remote state | string | `` | no |
| remote_state_infra_vpc_key_stack | Override infra_vpc remote state path | string | `` | no |
| snapshot_identifier | Specifies whether or not to create the database from this snapshot | string | `` | no |
| stackname | Stackname | string | - | yes |
| username | PostgreSQL username | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| postgresql-standby_address | postgresql replica instance address |
| postgresql-standby_endpoint | postgresql replica instance endpoint |
| warehouse-postgresql-primary_address | postgresql instance address |
| warehouse-postgresql-primary_endpoint | postgresql instance endpoint |
| warehouse-postgresql-primary_id | postgresql instance ID |
| warehouse-postgresql-primary_resource_id | postgresql instance resource ID |

