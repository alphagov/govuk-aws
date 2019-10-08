## Project: app-mapit

Mapit node


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_environment | AWS environment | string | - | yes |
| aws_region | AWS region | string | `eu-west-1` | no |
| ebs_device_name | Name of the block device to mount on the instance, e.g. xvdf | string | - | yes |
| ebs_device_volume_size | Size of additional ebs volume in GB | string | `20` | no |
| ebs_encrypted | Whether or not the EBS volume is encrypted | string | - | yes |
| elb_internal_certname | The ACM cert domain name to find the ARN of | string | - | yes |
| instance_ami_filter_name | Name to use to find AMI images | string | `` | no |
| instance_type | Instance type used for EC2 resources | string | `t2.medium` | no |
| internal_domain_name | The domain name of the internal DNS records, it could be different from the zone name | string | - | yes |
| internal_zone_name | The name of the Route53 zone that contains internal records | string | - | yes |
| lc_create_ebs_volume | Creates a launch configuration which will add an additional ebs volume to the instance if this value is set to 1 | string | - | yes |
| mapit_1_subnet | Name of the subnet to place the mapit instance 1 and EBS volume | string | - | yes |
| mapit_2_subnet | Name of the subnet to place the mapit instance 1 and EBS volume | string | - | yes |
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
| mapit_service_dns_name | DNS name to access the mapit internal service |

