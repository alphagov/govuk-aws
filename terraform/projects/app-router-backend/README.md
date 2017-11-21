## Project: app-router-backend

Router backend hosts both Mongo and router-api


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_environment | AWS Environment | string | - | yes |
| aws_region | AWS region | string | `eu-west-1` | no |
| elb_internal_certname | The ACM cert domain name to find the ARN of | string | - | yes |
| instance_ami_filter_name | Name to use to find AMI images | string | `` | no |
| remote_state_bucket | S3 bucket we store our terraform state in | string | - | yes |
| remote_state_infra_database_backups_bucket_key_stack | Override stackname path to infra_database_backups_bucket remote state | string | `` | no |
| remote_state_infra_monitoring_key_stack | Override stackname path to infra_monitoring remote state | string | `` | no |
| remote_state_infra_networking_key_stack | Override infra_networking remote state path | string | `` | no |
| remote_state_infra_security_groups_key_stack | Override infra_security_groups stackname path to infra_vpc remote state | string | `` | no |
| remote_state_infra_stack_dns_zones_key_stack | Override stackname path to infra_vpc remote state | string | `` | no |
| remote_state_infra_vpc_key_stack | Override infra_vpc remote state path | string | `` | no |
| router-backend_1_subnet | Name of the subnet to place the Router Mongo 1 | string | - | yes |
| router-backend_2_subnet | Name of the subnet to place the Router Mongo 2 | string | - | yes |
| router-backend_3_subnet | Name of the subnet to place the Router Mongo 3 | string | - | yes |
| ssh_public_key | Default public key material | string | - | yes |
| stackname | Stackname | string | - | yes |
| user_data_snippets | List of user-data snippets | list | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| router_api_service_dns_name | DNS name to access the router-api internal service |
| router_backend_1_service_dns_name | DNS name to access the Router Mongo 1 internal service |
| router_backend_2_service_dns_name | DNS name to access the Router Mongo 2 internal service |
| router_backend_3_service_dns_name | DNS name to access the Router Mongo 3 internal service |

