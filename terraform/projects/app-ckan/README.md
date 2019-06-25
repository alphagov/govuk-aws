## Project: app-ckan

CKAN node


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| app_service_records | List of application service names that get traffic via this loadbalancer | list | `<list>` | no |
| aws_environment | AWS Environment | string | - | yes |
| aws_region | AWS region | string | `eu-west-1` | no |
| ckan_subnet | Name of the subnet to place the ckan instance and the EBS volume | string | - | yes |
| ebs_encrypted | Whether or not the EBS volume is encrypted | string | - | yes |
| elb_external_certname | The ACM cert domain name to find the ARN of | string | - | yes |
| elb_internal_certname | The ACM cert domain name to find the ARN of | string | - | yes |
| instance_ami_filter_name | Name to use to find AMI images | string | `` | no |
| instance_type | Instance type used for EC2 resources | string | `m5.xlarge` | no |
| remote_state_bucket | S3 bucket we store our terraform state in | string | - | yes |
| remote_state_infra_monitoring_key_stack | Override stackname path to infra_monitoring remote state | string | `` | no |
| remote_state_infra_networking_key_stack | Override infra_networking remote state path | string | `` | no |
| remote_state_infra_root_dns_zones_key_stack | Override stackname path to infra_root_dns_zones remote state | string | `` | no |
| remote_state_infra_security_groups_key_stack | Override infra_security_groups stackname path to infra_vpc remote state | string | `` | no |
| remote_state_infra_stack_dns_zones_key_stack | Override stackname path to infra_stack_dns_zones remote state | string | `` | no |
| remote_state_infra_vpc_key_stack | Override infra_vpc remote state path | string | `` | no |
| stackname | Stackname | string | - | yes |
| user_data_snippets | List of user-data snippets | list | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| app_service_records_external_dns_name | DNS name to access the app service records |
| app_service_records_internal_dns_name | DNS name to access the app service records |
| ckan_elb_external_address | AWS' external DNS name for the ckan ELB |
| ckan_elb_internal_address | AWS' internal DNS name for the ckan ELB |
| service_dns_name_external | DNS name to access the node service |
| service_dns_name_internal | DNS name to access the node service |

