## Module: aws/elasticache_redis_cluster

Create a redis replication cluster and elasticache subnet group

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| default\_tags | Additional resource tags | map | `<map>` | no |
| elasticache\_node\_type | The node type to use. Must not be t.\* in order to use failover. | string | `"cache.m3.medium"` | no |
| enable\_clustering | Set to true to enable clustering mode | string | `"true"` | no |
| name | The common name for all the resources created by this module | string | n/a | yes |
| security\_group\_ids | Security group IDs to apply to this cluster | list | n/a | yes |
| subnet\_ids | Subnet IDs to assign to the aws\_elasticache\_subnet\_group | list | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| configuration\_endpoint\_address | Configuration endpoint address of the redis cluster. |
| replication\_group\_id | The ID of the ElastiCache Replication Group. |

