## Project: app-email-alert-api

email-alert-api node


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| asg_size | The autoscaling groups desired/max/min capacity | string | `2` | no |
| aws_environment | AWS Environment | string | - | yes |
| aws_region | AWS region | string | `eu-west-1` | no |
| create_external_elb | Create the external ELB | string | `true` | no |
| elb_external_certname | The ACM cert domain name to find the ARN of | string | - | yes |
| elb_internal_certname | The ACM cert domain name to find the ARN of | string | - | yes |
| external_domain_name | The domain name of the external DNS records, it could be different from the zone name | string | - | yes |
| external_zone_name | The name of the Route53 zone that contains external records | string | - | yes |
| instance_ami_filter_name | Name to use to find AMI images | string | `` | no |
| internal_domain_name | The domain name of the internal DNS records, it could be different from the zone name | string | - | yes |
| internal_zone_name | The name of the Route53 zone that contains internal records | string | - | yes |
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
| email-alert-api_elb_address_external | AWS' external DNS name for the email-alert-api ELB |
| email-alert-api_elb_address_internal | AWS' internal DNS name for the email-alert-api ELB |
| service_dns_name_external | DNS name to access the external node service |
| service_dns_name_internal | DNS name to access the internal node service |

