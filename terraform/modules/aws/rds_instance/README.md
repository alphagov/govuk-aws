## Module: aws::rds\_instance

Create an RDS instance

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_db_event_subscription.event_subscription](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_event_subscription) | resource |
| [aws_db_event_subscription.event_subscription_replica](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_event_subscription) | resource |
| [aws_db_instance.db_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_instance.db_instance_replica](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_subnet_group.subnet_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allocated_storage"></a> [allocated\_storage](#input\_allocated\_storage) | The allocated storage in gigabytes. | `string` | `"10"` | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | The days to retain backups for. | `string` | `"7"` | no |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | The daily time range during which automated backups are created if automated backups are enabled. | `string` | `"01:00-03:00"` | no |
| <a name="input_copy_tags_to_snapshot"></a> [copy\_tags\_to\_snapshot](#input\_copy\_tags\_to\_snapshot) | Whether to copy the instance tags to the snapshot. | `string` | `"true"` | no |
| <a name="input_create_rds_notifications"></a> [create\_rds\_notifications](#input\_create\_rds\_notifications) | Enable RDS events notifications | `string` | `true` | no |
| <a name="input_create_replicate_source_db"></a> [create\_replicate\_source\_db](#input\_create\_replicate\_source\_db) | Specifies that this resource is a Replicate database, and to use this value as the source database. This correlates to the identifier of another Amazon RDS Database to replicate | `string` | `"0"` | no |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | Additional resource tags | `map(string)` | `{}` | no |
| <a name="input_engine_name"></a> [engine\_name](#input\_engine\_name) | RDS engine (eg mysql, postgresql) | `string` | `""` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | Which version of MySQL to use (eg 5.5.46) | `string` | `""` | no |
| <a name="input_event_categories"></a> [event\_categories](#input\_event\_categories) | A list of event categories for a SourceType that you want to subscribe to. See http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide//USER_Events.html | `list(string)` | <pre>[<br>  "availability",<br>  "deletion",<br>  "failure",<br>  "low storage"<br>]</pre> | no |
| <a name="input_event_sns_topic_arn"></a> [event\_sns\_topic\_arn](#input\_event\_sns\_topic\_arn) | The SNS topic to send events to. | `string` | `""` | no |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | The instance type of the RDS instance. | `string` | `"db.t1.micro"` | no |
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | The RDS Instance Name. | `string` | `""` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | The window to perform maintenance in. | `string` | `"Mon:04:00-Mon:06:00"` | no |
| <a name="input_max_allocated_storage"></a> [max\_allocated\_storage](#input\_max\_allocated\_storage) | current maximum storage in GB that AWS can autoscale the RDS storage to, 0 means disabled autoscaling | `string` | `"100"` | no |
| <a name="input_monitoring_interval"></a> [monitoring\_interval](#input\_monitoring\_interval) | Collection interval in seconds for Enhanced Monitoring metrics. Default is 0, which disables Enhanced Monitoring. Valid values are 0, 1, 5, 10, 15, 30, 60. | `string` | `"0"` | no |
| <a name="input_monitoring_role_arn"></a> [monitoring\_role\_arn](#input\_monitoring\_role\_arn) | ARN of the IAM role which lets RDS send Enhanced Monitoring logs to CloudWatch. Must be specified if monitoring\_interval is non-zero. | `string` | `""` | no |
| <a name="input_multi_az"></a> [multi\_az](#input\_multi\_az) | Specifies if the RDS instance is multi-AZ | `string` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | The common name for all the resources created by this module | `string` | n/a | yes |
| <a name="input_parameter_group_name"></a> [parameter\_group\_name](#input\_parameter\_group\_name) | Name of the parameter group to make the instance a member of. | `string` | `""` | no |
| <a name="input_password"></a> [password](#input\_password) | Password for accessing the database. | `string` | `""` | no |
| <a name="input_replicate_source_db"></a> [replicate\_source\_db](#input\_replicate\_source\_db) | Specifies that this resource is a Replicate database, and to use this value as the source database. This correlates to the identifier of another Amazon RDS Database to replicate | `string` | `"false"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | Security group IDs to apply to this cluster | `list(string)` | n/a | yes |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | Set to true to NOT create a final snapshot when the cluster is deleted. | `string` | `"false"` | no |
| <a name="input_snapshot_identifier"></a> [snapshot\_identifier](#input\_snapshot\_identifier) | Specifies whether or not to create this database from a snapshot. | `string` | `""` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | One of standard (magnetic), gp2 (general purpose SSD), or io1 (provisioned IOPS SSD). The default is gp2 | `string` | `"gp2"` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Subnet IDs to assign to the aws\_elasticache\_subnet\_group | `list(string)` | `[]` | no |
| <a name="input_terraform_create_rds_timeout"></a> [terraform\_create\_rds\_timeout](#input\_terraform\_create\_rds\_timeout) | Set the timeout time for AWS RDS creation. | `string` | `"2h"` | no |
| <a name="input_terraform_delete_rds_timeout"></a> [terraform\_delete\_rds\_timeout](#input\_terraform\_delete\_rds\_timeout) | Set the timeout time for AWS RDS deletion. | `string` | `"2h"` | no |
| <a name="input_terraform_update_rds_timeout"></a> [terraform\_update\_rds\_timeout](#input\_terraform\_update\_rds\_timeout) | Set the timeout time for AWS RDS modification. | `string` | `"2h"` | no |
| <a name="input_username"></a> [username](#input\_username) | User to create on the database | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rds_instance_address"></a> [rds\_instance\_address](#output\_rds\_instance\_address) | n/a |
| <a name="output_rds_instance_endpoint"></a> [rds\_instance\_endpoint](#output\_rds\_instance\_endpoint) | n/a |
| <a name="output_rds_instance_id"></a> [rds\_instance\_id](#output\_rds\_instance\_id) | n/a |
| <a name="output_rds_instance_resource_id"></a> [rds\_instance\_resource\_id](#output\_rds\_instance\_resource\_id) | n/a |
| <a name="output_rds_replica_address"></a> [rds\_replica\_address](#output\_rds\_replica\_address) | n/a |
| <a name="output_rds_replica_endpoint"></a> [rds\_replica\_endpoint](#output\_rds\_replica\_endpoint) | n/a |
| <a name="output_rds_replica_id"></a> [rds\_replica\_id](#output\_rds\_replica\_id) | n/a |
| <a name="output_rds_replica_resource_id"></a> [rds\_replica\_resource\_id](#output\_rds\_replica\_resource\_id) | n/a |
