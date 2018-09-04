## Project: app-email-alert-api-postgresql

RDS email-alert-api PostgreSQL Primary instance


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_environment | AWS Environment | string | - | yes |
| aws_region | AWS region | string | `eu-west-1` | no |
| cloudwatch_log_retention | Number of days to retain Cloudwatch logs for | string | - | yes |
| instance_name | The RDS Instance Name. | string | `` | no |
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
| email-alert-api-postgresql-primary_address | email-alert-api-postgresql instance address |
| email-alert-api-postgresql-primary_endpoint | email-alert-api-postgresql instance endpoint |
| email-alert-api-postgresql-primary_id | email-alert-api-postgresql instance ID |
| email-alert-api-postgresql-primary_resource_id | email-alert-api-postgresql instance resource ID |
| email-alert-api-postgresql-standby-address | email-alert-api-postgresql replica instance address |
| email-alert-api-postgresql-standby-endpoint | email-alert-api-postgresql replica instance endpoint |

