## Project: app-mongo

Mongo hosts


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_environment | AWS Environment | string | - | yes |
| aws_region | AWS region | string | `eu-west-1` | no |
| ebs_encrypted | Whether or not the EBS volume is encrypted | string | - | yes |
| instance_ami_filter_name | Name to use to find AMI images | string | `` | no |
| mongo_1_ip | IP address of the private IP to assign to the instance | string | - | yes |
| mongo_1_reserved_ips_subnet | Name of the subnet to place the reserved IP of the instance | string | - | yes |
| mongo_1_subnet | Name of the subnet to place the Mongo instance 1 and EBS volume | string | - | yes |
| mongo_2_ip | IP address of the private IP to assign to the instance | string | - | yes |
| mongo_2_reserved_ips_subnet | Name of the subnet to place the reserved IP of the instance | string | - | yes |
| mongo_2_subnet | Name of the subnet to place the Mongo 2 and EBS volume | string | - | yes |
| mongo_3_ip | IP address of the private IP to assign to the instance | string | - | yes |
| mongo_3_reserved_ips_subnet | Name of the subnet to place the reserved IP of the instance | string | - | yes |
| mongo_3_subnet | Name of the subnet to place the Mongo 3 and EBS volume | string | - | yes |
| remote_state_bucket | S3 bucket we store our terraform state in | string | - | yes |
| remote_state_infra_database_backups_bucket_key_stack | Override stackname path to infra_database_backups_bucket remote state | string | `` | no |
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
| mongo_1_service_dns_name | DNS name to access the Mongo 1 internal service |
| mongo_2_service_dns_name | DNS name to access the Mongo 2 internal service |
| mongo_3_service_dns_name | DNS name to access the Mongo 3 internal service |

