## Project: projects/app-content-data-api-postgresql

RDS PostgreSQL instance for the Content Data API


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_environment | AWS Environment | string | - | yes |
| aws_region | AWS region | string | `eu-west-1` | no |
| cloudwatch_log_retention | Number of days to retain Cloudwatch logs for | string | - | yes |
| instance_type | Instance type used for RDS resources | string | `db.m4.large` | no |
| multi_az | Enable multi-az. | string | `true` | no |
| password | DB password | string | - | yes |
| remote_state_bucket | S3 bucket we store our terraform state in | string | - | yes |
| remote_state_infra_monitoring_key_stack | Override stackname path to infra_monitoring remote state | string | `` | no |
| remote_state_infra_networking_key_stack | Override infra_networking remote state path | string | `` | no |
| remote_state_infra_root_dns_zones_key_stack | Override stackname path to infra_root_dns_zones remote state | string | `` | no |
| remote_state_infra_security_groups_key_stack | Override infra_security_groups stackname path to infra_vpc remote state | string | `` | no |
| remote_state_infra_stack_dns_zones_key_stack | Override stackname path to infra_stack_dns_zones remote state | string | `` | no |
| remote_state_infra_vpc_key_stack | Override infra_vpc remote state path | string | `` | no |
| skip_final_snapshot | Set to true to NOT create a final snapshot when the cluster is deleted. | string | - | yes |
| snapshot_identifier | Specifies whether or not to create the database from this snapshot | string | `` | no |
| stackname | Stackname | string | - | yes |
| username | PostgreSQL username | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| content-data-api-postgresql-primary_address | postgresql instance address |
| content-data-api-postgresql-primary_endpoint | postgresql instance endpoint |
| content-data-api-postgresql-primary_id | postgresql instance ID |
| content-data-api-postgresql-primary_resource_id | postgresql instance resource ID |
| postgresql-standby_address | postgresql replica instance address |
| postgresql-standby_endpoint | postgresql replica instance endpoint |

