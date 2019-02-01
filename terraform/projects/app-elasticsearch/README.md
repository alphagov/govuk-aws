## Project: app-elasticsearch

Elasticsearch cluster


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_environment | AWS Environment | string | - | yes |
| aws_region | AWS region | string | `eu-west-1` | no |
| stackname | Stackname | string | - | yes |
| remote_state_bucket | S3 bucket we store our terraform state in | string | - | yes |
| remote_state_infra_monitoring_key_stack | Override stackname path to infra_monitoring remote state | string | `` | no |
| remote_state_infra_networking_key_stack | Override infra_networking remote state path | string | `` | no |
| remote_state_infra_root_dns_zones_key_stack | Override stackname path to infra_root_dns_zones remote state | string | `` | no |
| remote_state_infra_security_groups_key_stack | Override infra_security_groups stackname path to infra_vpc remote state | string | `` | no |
| remote_state_infra_stack_dns_zones_key_stack | Override stackname path to infra_stack_dns_zones remote state | string | `` | no |
| remote_state_infra_vpc_key_stack | Override infra_vpc remote state path | string | `` | no |
| elasticsearch_version | Which version of ElasticSearch to use (eg 5.6) | string | `5.6` | no |
| elasticearch_instance_type | The instance type of the individual ElasticSearch nodes | string | `m4.2xlarge.elasticsearch` | no |
| elasticsearch_instance_count | The number of ElasticSearch nodes | string | `3` | no |
| elasticsearch_snapshot_start_hour | The hour in which the daily snapshot is taken | string | `01:00` | no |
| elastcisearch_subnet_names | Names of the subnets to place the ElasticSearch domain in | list | `<list>` | yes |

## Outputs

| Name | Description |
|------|-------------|
| service_role_id | Unique identifier for the service-linked role |
| service_endpoint | Endpoint to submit index, search, and upload requests |
