## Project: projects/app-postgresql

RDS PostgreSQL instances

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | = 0.11.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 2.46.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 2.46.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alarms-rds-postgresql-primary"></a> [alarms-rds-postgresql-primary](#module\_alarms-rds-postgresql-primary) | ../../modules/aws/alarms/rds | n/a |
| <a name="module_alarms-rds-postgresql-standby"></a> [alarms-rds-postgresql-standby](#module\_alarms-rds-postgresql-standby) | ../../modules/aws/alarms/rds | n/a |
| <a name="module_postgresql-primary_rds_instance"></a> [postgresql-primary\_rds\_instance](#module\_postgresql-primary\_rds\_instance) | ../../modules/aws/rds_instance | n/a |
| <a name="module_postgresql-standby_rds_instance"></a> [postgresql-standby\_rds\_instance](#module\_postgresql-standby\_rds\_instance) | ../../modules/aws/rds_instance | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_db_parameter_group.postgresql_pg](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/db_parameter_group) | resource |
| [aws_route53_record.replica_service_record](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.service_record](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_zone.internal](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/route53_zone) | data source |
| [terraform_remote_state.infra_monitoring](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_networking](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_root_dns_zones](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_security_groups](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_stack_dns_zones](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_vpc](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allocated_storage"></a> [allocated\_storage](#input\_allocated\_storage) | current set minimum storage in GB for the RDS | `string` | `"300"` | no |
| <a name="input_aws_environment"></a> [aws\_environment](#input\_aws\_environment) | AWS Environment | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"eu-west-1"` | no |
| <a name="input_cloudwatch_log_retention"></a> [cloudwatch\_log\_retention](#input\_cloudwatch\_log\_retention) | Number of days to retain Cloudwatch logs for | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type used for RDS resources | `string` | `"db.m5.12xlarge"` | no |
| <a name="input_internal_domain_name"></a> [internal\_domain\_name](#input\_internal\_domain\_name) | The domain name of the internal DNS records, it could be different from the zone name | `string` | n/a | yes |
| <a name="input_internal_zone_name"></a> [internal\_zone\_name](#input\_internal\_zone\_name) | The name of the Route53 zone that contains internal records | `string` | n/a | yes |
| <a name="input_max_allocated_storage"></a> [max\_allocated\_storage](#input\_max\_allocated\_storage) | current maximum storage in GB that AWS can autoscale the RDS storage to | `string` | `"500"` | no |
| <a name="input_multi_az"></a> [multi\_az](#input\_multi\_az) | Enable multi-az. | `string` | `true` | no |
| <a name="input_password"></a> [password](#input\_password) | DB password | `string` | n/a | yes |
| <a name="input_remote_state_bucket"></a> [remote\_state\_bucket](#input\_remote\_state\_bucket) | S3 bucket we store our terraform state in | `string` | n/a | yes |
| <a name="input_remote_state_infra_monitoring_key_stack"></a> [remote\_state\_infra\_monitoring\_key\_stack](#input\_remote\_state\_infra\_monitoring\_key\_stack) | Override stackname path to infra\_monitoring remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_networking_key_stack"></a> [remote\_state\_infra\_networking\_key\_stack](#input\_remote\_state\_infra\_networking\_key\_stack) | Override infra\_networking remote state path | `string` | `""` | no |
| <a name="input_remote_state_infra_root_dns_zones_key_stack"></a> [remote\_state\_infra\_root\_dns\_zones\_key\_stack](#input\_remote\_state\_infra\_root\_dns\_zones\_key\_stack) | Override stackname path to infra\_root\_dns\_zones remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_security_groups_key_stack"></a> [remote\_state\_infra\_security\_groups\_key\_stack](#input\_remote\_state\_infra\_security\_groups\_key\_stack) | Override infra\_security\_groups stackname path to infra\_vpc remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_stack_dns_zones_key_stack"></a> [remote\_state\_infra\_stack\_dns\_zones\_key\_stack](#input\_remote\_state\_infra\_stack\_dns\_zones\_key\_stack) | Override stackname path to infra\_stack\_dns\_zones remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_vpc_key_stack"></a> [remote\_state\_infra\_vpc\_key\_stack](#input\_remote\_state\_infra\_vpc\_key\_stack) | Override infra\_vpc remote state path | `string` | `""` | no |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | Set to true to NOT create a final snapshot when the cluster is deleted. | `string` | n/a | yes |
| <a name="input_snapshot_identifier"></a> [snapshot\_identifier](#input\_snapshot\_identifier) | Specifies whether or not to create the database from this snapshot | `string` | `""` | no |
| <a name="input_stackname"></a> [stackname](#input\_stackname) | Stackname | `string` | n/a | yes |
| <a name="input_standby_instance_type"></a> [standby\_instance\_type](#input\_standby\_instance\_type) | Instance type used for standby RDS | `string` | `"db.m5.4xlarge"` | no |
| <a name="input_username"></a> [username](#input\_username) | PostgreSQL username | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_postgresql-primary_address"></a> [postgresql-primary\_address](#output\_postgresql-primary\_address) | postgresql instance address |
| <a name="output_postgresql-primary_endpoint"></a> [postgresql-primary\_endpoint](#output\_postgresql-primary\_endpoint) | postgresql instance endpoint |
| <a name="output_postgresql-primary_id"></a> [postgresql-primary\_id](#output\_postgresql-primary\_id) | postgresql instance ID |
| <a name="output_postgresql-primary_resource_id"></a> [postgresql-primary\_resource\_id](#output\_postgresql-primary\_resource\_id) | postgresql instance resource ID |
| <a name="output_postgresql-standby_address"></a> [postgresql-standby\_address](#output\_postgresql-standby\_address) | postgresql replica instance address |
| <a name="output_postgresql-standby_endpoint"></a> [postgresql-standby\_endpoint](#output\_postgresql-standby\_endpoint) | postgresql replica instance endpoint |
