## Project: app-rummager-elasticsearch

Rummager Elasticsearch cluster


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_environment | AWS Environment | string | - | yes |
| aws_region | AWS region | string | `eu-west-1` | no |
| cluster_name | Name of the Elasticsearch cluster to use for discovery | string | - | yes |
| instance_ami_filter_name | Name to use to find AMI images | string | `` | no |
| remote_state_bucket | S3 bucket we store our terraform state in | string | - | yes |
| remote_state_infra_aws_logging_key_stack | Override stackname path to infra_aws_logging remote state | string | `` | no |
| remote_state_infra_database_backups_bucket_key_stack | Override stackname path to infra_database_backups_bucket remote state | string | `` | no |
| remote_state_infra_networking_key_stack | Override infra_networking remote state path | string | `` | no |
| remote_state_infra_security_groups_key_stack | Override infra_security_groups stackname path to infra_vpc remote state | string | `` | no |
| remote_state_infra_stack_dns_zones_key_stack | Override stackname path to infra_vpc remote state | string | `` | no |
| remote_state_infra_stack_sns_alerts_key_stack | Override stackname path to infra_stack_sns_alerts remote state | string | `` | no |
| remote_state_infra_vpc_key_stack | Override infra_vpc remote state path | string | `` | no |
| rummager_elasticsearch_1_subnet | Name of the subnet to place the Elasticsearch instance 1 and EBS volume | string | - | yes |
| rummager_elasticsearch_2_subnet | Name of the subnet to place the Elasticsearch 2 and EBS volume | string | - | yes |
| rummager_elasticsearch_3_subnet | Name of the subnet to place the Elasticsearch instance 3 and EBS volume | string | - | yes |
| ssh_public_key | Default public key material | string | - | yes |
| stackname | Stackname | string | - | yes |
| user_data_snippets | List of user-data snippets | list | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| rummager_elasticsearch_elb_dns_name | DNS name to access the Elasticsearch ELB |
| service_dns_name | DNS name to access the Elasticsearch internal service |

