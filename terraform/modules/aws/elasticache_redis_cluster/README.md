## Module: aws/elasticache\_redis\_cluster

Create a redis replication cluster and elasticache subnet group

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
| [aws_elasticache_replication_group.redis_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) | resource |
| [aws_elasticache_replication_group.redis_master_with_replica](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) | resource |
| [aws_elasticache_subnet_group.redis_cluster_subnet_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | Additional resource tags | `map` | `{}` | no |
| <a name="input_elasticache_node_number"></a> [elasticache\_node\_number](#input\_elasticache\_node\_number) | The number of nodes per cluster. | `string` | `"2"` | no |
| <a name="input_elasticache_node_type"></a> [elasticache\_node\_type](#input\_elasticache\_node\_type) | The node type to use. Must not be t.* in order to use failover. | `string` | `"cache.m3.medium"` | no |
| <a name="input_enable_clustering"></a> [enable\_clustering](#input\_enable\_clustering) | Set to true to enable clustering mode | `string` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | The common name for all the resources created by this module | `string` | n/a | yes |
| <a name="input_redis_engine_version"></a> [redis\_engine\_version](#input\_redis\_engine\_version) | The Elasticache Redis engine version. | `string` | n/a | yes |
| <a name="input_redis_parameter_group_name"></a> [redis\_parameter\_group\_name](#input\_redis\_parameter\_group\_name) | The Elasticache Redis parameter group name. | `string` | n/a | yes |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | Security group IDs to apply to this cluster | `list` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Subnet IDs to assign to the aws\_elasticache\_subnet\_group | `list` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_configuration_endpoint_address"></a> [configuration\_endpoint\_address](#output\_configuration\_endpoint\_address) | Configuration endpoint address of the redis cluster. |
| <a name="output_replication_group_id"></a> [replication\_group\_id](#output\_replication\_group\_id) | The ID of the ElastiCache Replication Group. |
