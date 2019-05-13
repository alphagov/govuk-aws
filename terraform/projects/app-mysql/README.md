## Project: app-mysql

RDS Mysql Primary instance


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_environment | AWS Environment | string | - | yes |
| aws_region | AWS region | string | `eu-west-1` | no |
| cloudwatch_log_retention | Number of days to retain Cloudwatch logs for | string | - | yes |
| instance_name | The RDS Instance Name. | string | `` | no |
| internal_domain_name | The domain name of the internal DNS records, it could be different from the zone name | string | - | yes |
| internal_zone_name | The name of the Route53 zone that contains internal records | string | - | yes |
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
| storage_size | Defines the AWS RDS storage capacity, in gigabytes. | string | `30` | no |
| username | Mysql username | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| mysql_primary_address | Mysql instance address |
| mysql_primary_endpoint | Mysql instance endpoint |
| mysql_primary_id | Mysql instance ID |
| mysql_primary_resource_id | Mysql instance resource ID |
| mysql_replica_address | Mysql instance address |
| mysql_replica_endpoint | Mysql instance endpoint |

