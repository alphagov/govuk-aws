## Project: app-elasticsearch5

Managed Elasticsearch 5 cluster


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_environment | AWS Environment | string | - | yes |
| aws_region | AWS region | string | `eu-west-1` | no |
| cloudwatch_log_retention | Number of days to retain Cloudwatch logs for | string | `90` | no |
| elasticsearch5_dedicated_master_enabled | Indicates whether dedicated master nodes are enabled for the cluster | boolean | `true` | no |
| elasticsearch5_ebs_encrypt | Whether to encrypt the EBS volume at rest | string | - | yes |
| elasticsearch5_ebs_size | The amount of EBS storage to attach | string | `32` | no |
| elasticsearch5_ebs_type | The type of EBS storage to attach | string | `gp2` | no |
| elasticsearch5_instance_count | The number of ElasticSearch nodes | string | `3` | no |
| elasticsearch5_instance_type | The instance type of the individual ElasticSearch nodes, only instances which allow EBS volumes are supported | string | `r4.large.elasticsearch` | no |
| elasticsearch5_master_instance_count | Number of dedicated master nodes in the cluster | string | `3` | no |
| elasticsearch5_master_instance_type | Instance type of the dedicated master nodes in the cluster | string | `c4.large.elasticsearch` | no |
| elasticsearch5_snapshot_start_hour | The hour in which the daily snapshot is taken | string | `1` | no |
| elasticsearch_subnet_names | Names of the subnets to place the ElasticSearch domain in | list | - | yes |
| remote_state_bucket | S3 bucket we store our terraform state in | string | - | yes |
| remote_state_infra_monitoring_key_stack | Override stackname path to infra_monitoring remote state | string | `` | no |
| remote_state_infra_networking_key_stack | Override infra_networking remote state path | string | `` | no |
| remote_state_infra_root_dns_zones_key_stack | Override stackname path to infra_root_dns_zones remote state | string | `` | no |
| remote_state_infra_security_groups_key_stack | Override infra_security_groups stackname path to infra_vpc remote state | string | `` | no |
| remote_state_infra_stack_dns_zones_key_stack | Override stackname path to infra_stack_dns_zones remote state | string | `` | no |
| remote_state_infra_vpc_key_stack | Override infra_vpc remote state path | string | `` | no |
| stackname | Stackname | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| service_dns_name | DNS name to access the Elasticsearch internal service |
| service_endpoint | Endpoint to submit index, search, and upload requests |
| service_role_id | Unique identifier for the service-linked role |

