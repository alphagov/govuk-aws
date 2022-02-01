## Project: projects/app-locations-api-postgresql

RDS PostgreSQL instance for the Locations API

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | = 0.11.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 2.46.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 2.46.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alarms-rds-locations-api-postgresql-primary"></a> [alarms-rds-locations-api-postgresql-primary](#module\_alarms-rds-locations-api-postgresql-primary) | ../../modules/aws/alarms/rds | n/a |
| <a name="module_locations-api-postgresql-primary_rds_instance"></a> [locations-api-postgresql-primary\_rds\_instance](#module\_locations-api-postgresql-primary\_rds\_instance) | ../../modules/aws/rds_instance | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_db_parameter_group.locations_api](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/db_parameter_group) | resource |
| [aws_route53_record.service_record](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_environment"></a> [aws\_environment](#input\_aws\_environment) | AWS Environment | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"eu-west-1"` | no |
| <a name="input_cloudwatch_log_retention"></a> [cloudwatch\_log\_retention](#input\_cloudwatch\_log\_retention) | Number of days to retain Cloudwatch logs for | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type used for RDS resources | `string` | `"db.m5.large"` | no |
| <a name="input_multi_az"></a> [multi\_az](#input\_multi\_az) | Enable multi-az. | `string` | `true` | no |
| <a name="input_password"></a> [password](#input\_password) | DB password | `string` | n/a | yes |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | Set to true to NOT create a final snapshot when the cluster is deleted. | `string` | n/a | yes |
| <a name="input_snapshot_identifier"></a> [snapshot\_identifier](#input\_snapshot\_identifier) | Specifies whether or not to create the database from this snapshot | `string` | `""` | no |
| <a name="input_stackname"></a> [stackname](#input\_stackname) | Stackname | `string` | n/a | yes |
| <a name="input_username"></a> [username](#input\_username) | PostgreSQL username | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_locations-api-postgresql-primary_address"></a> [locations-api-postgresql-primary\_address](#output\_locations-api-postgresql-primary\_address) | postgresql instance address |
| <a name="output_locations-api-postgresql-primary_endpoint"></a> [locations-api-postgresql-primary\_endpoint](#output\_locations-api-postgresql-primary\_endpoint) | postgresql instance endpoint |
| <a name="output_locations-api-postgresql-primary_id"></a> [locations-api-postgresql-primary\_id](#output\_locations-api-postgresql-primary\_id) | postgresql instance ID |
| <a name="output_locations-api-postgresql-primary_resource_id"></a> [locations-api-postgresql-primary\_resource\_id](#output\_locations-api-postgresql-primary\_resource\_id) | postgresql instance resource ID |
