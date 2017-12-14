## Project: infra-public-services

This project adds public facing LBs and DNS entries
for the app components of the infrastructure


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| apt_public_service_cnames | List of application service names that get traffic via this loadbalancer | list | `<list>` | no |
| apt_public_service_names | List of application service names that get traffic via this loadbalancer | list | `<list>` | no |
| aws_environment | AWS Environment | string | - | yes |
| aws_region | AWS region | string | `eu-west-1` | no |
| backend_public_service_cnames | List of application service names that get traffic via this loadbalancer | list | `<list>` | no |
| backend_public_service_names | List of application service names that get traffic via this loadbalancer | list | `<list>` | no |
| bouncer_public_service_names | List of application service names that get traffic via this loadbalancer | list | `<list>` | no |
| cache_public_service_cnames | List of application service names that get traffic via this loadbalancer | list | `<list>` | no |
| cache_public_service_names | List of application service names that get traffic via this loadbalancer | list | `<list>` | no |
| deploy_public_service_names | List of application service names that get traffic via this loadbalancer | list | `<list>` | no |
| elb_public_certname | The ACM cert domain name to find the ARN of | string | - | yes |
| graphite_public_service_names | List of application service names that get traffic via this loadbalancer | list | `<list>` | no |
| jumpbox_public_service_names | List of application service names that get traffic via this loadbalancer | list | `<list>` | no |
| logs_cdn_public_service_names | List of application service names that get traffic via this loadbalancer | list | `<list>` | no |
| monitoring_public_service_names | List of application service names that get traffic via this loadbalancer | list | `<list>` | no |
| remote_state_bucket | S3 bucket we store our terraform state in | string | - | yes |
| remote_state_infra_monitoring_key_stack | Override stackname path to infra_monitoring remote state | string | `` | no |
| remote_state_infra_networking_key_stack | Override infra_networking remote state path | string | `` | no |
| remote_state_infra_root_dns_zones_key_stack | Override stackname path to infra_root_dns_zones remote state | string | `` | no |
| remote_state_infra_security_groups_key_stack | Override infra_security_groups stackname path to infra_vpc remote state | string | `` | no |
| remote_state_infra_stack_dns_zones_key_stack | Override stackname path to infra_stack_dns_zones remote state | string | `` | no |
| remote_state_infra_vpc_key_stack | Override infra_vpc remote state path | string | `` | no |
| stackname | Stackname | string | - | yes |
| whitehall_backend_public_service_cnames | List of application service names that get traffic via this loadbalancer | list | `<list>` | no |
| whitehall_backend_public_service_names | List of application service names that get traffic via this loadbalancer | list | `<list>` | no |

