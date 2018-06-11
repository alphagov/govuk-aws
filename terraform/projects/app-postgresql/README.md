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
| postgresql-primary_address | postgresql instance address |
| postgresql-primary_endpoint | postgresql instance endpoint |
| postgresql-primary_id | postgresql instance ID |
| postgresql-primary_resource_id | postgresql instance resource ID |
| postgresql-standby_address | postgresql replica instance address |
| postgresql-standby_endpoint | postgresql replica instance endpoint |


## Monitoring
We can monitor AWS RDS Instances via Icinga. This can be done by adding the instance name inside the 'hieradata_aws/common.yaml' file in the GOV.UK Pupet repository, under the 'monitoring::checks::rds::servers:'.

If you do need additional matics to be checked, you will have to add some additional files to the GOV.UK Puppet repository.
1) Create a plugin [ inside modules/monitoring/files/usr/lib/nagios/plugins/].
2) We have to specify the command format. [ inside modules/monitoring/files/etc/nagios3/conf.d/]
3) We have to create a puppet class that will map the plugin to the command. Also, here you will be able to create a "config" file that will provide the alert values to the command. [inside modules/monitoring/manifests/checks/]
