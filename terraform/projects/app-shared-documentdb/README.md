## Project: app-shared-documentdb

Shared DocumentDB to support the following apps:
  1. asset-manager


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_environment | AWS environment | string | - | yes |
| aws_region | AWS region | string | `eu-west-1` | no |
| backup_retention_period | Retention period in days for DocumentDB automatic snapshots | string | `1` | no |
| instance_count | Instance count used for DocumentDB resources | string | `3` | no |
| instance_type | Instance type used for DocumentDB resources | string | `db.r5.large` | no |
| master_password | Password of master user on DocumentDB cluster | string | - | yes |
| master_username | Username of master user on DocumentDB cluster | string | - | yes |
| remote_state_bucket | S3 bucket we store our terraform state in | string | - | yes |
| remote_state_infra_monitoring_key_stack | Override stackname path to infra_monitoring remote state | string | `` | no |
| remote_state_infra_networking_key_stack | Override infra_networking remote state path | string | `` | no |
| remote_state_infra_root_dns_zones_key_stack | Override stackname path to infra_root_dns_zones remote state | string | `` | no |
| remote_state_infra_security_groups_key_stack | Override infra_security_groups stackname path to infra_vpc remote state | string | `` | no |
| remote_state_infra_stack_dns_zones_key_stack | Override stackname path to infra_stack_dns_zones remote state | string | `` | no |
| remote_state_infra_vpc_key_stack | Override infra_vpc remote state path | string | `` | no |
| stackname | Stackname | string | - | yes |
| tls | Whether to enable or disable TLS for the DocumentDB cluster. Must be either 'enabled' or 'disabled'. | string | `disabled` | no |

## Outputs

| Name | Description |
|------|-------------|
| shared_documentdb_endpoint | Outputs -------------------------------------------------------------- |

