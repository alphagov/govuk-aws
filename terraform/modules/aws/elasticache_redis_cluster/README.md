## Module: aws/elasticache_redis_cluster

Create a redis replication cluster and elasticache subnet group


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| default_tags | Additional resource tags | map | `<map>` | no |
| elasticache_node_type | The node type to use. Must not be t.* in order to use failover. | string | `cache.m3.medium` | no |
| enable_clustering | Set to true to enable clustering mode | string | `true` | no |
| name | The common name for all the resources created by this module | string | - | yes |
| security_group_ids | Security group IDs to apply to this cluster | list | - | yes |
| subnet_ids | Subnet IDs to assign to the aws_elasticache_subnet_group | list | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| configuration_endpoint_address | Configuration endpoint address of the redis cluster. |
| replication_group_id | The ID of the ElastiCache Replication Group. |

