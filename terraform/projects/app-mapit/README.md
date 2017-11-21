## Project: app-mapit

Mapit node


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_environment | AWS environment | string | - | yes |
| aws_region | AWS region | string | `eu-west-1` | no |
| elb_internal_certname | The ACM cert domain name to find the ARN of | string | - | yes |
| instance_ami_filter_name | Name to use to find AMI images | string | `` | no |
| instance_type | The type of EC2 instance to use for both ASGs. | string | `t2.medium` | no |
| mapit_1_subnet | Name of the subnet to place the mapit instance 1 and EBS volume | string | - | yes |
| mapit_2_subnet | Name of the subnet to place the mapit instance 1 and EBS volume | string | - | yes |
| remote_state_bucket | S3 bucket we store our terraform state in | string | - | yes |
| remote_state_infra_monitoring_key_stack | Override stackname path to infra_monitoring remote state | string | `` | no |
| remote_state_infra_networking_key_stack | Override infra_networking remote state path | string | `` | no |
| remote_state_infra_security_groups_key_stack | Override infra_security_groups stackname path to infra_vpc remote state | string | `` | no |
| remote_state_infra_stack_dns_zones_key_stack | Override stackname path to infra_vpc remote state | string | `` | no |
| remote_state_infra_vpc_key_stack | Override infra_vpc remote state path | string | `` | no |
| ssh_public_key | Default public key material | string | - | yes |
| stackname | Stackname | string | - | yes |
| user_data_snippets | List of user-data snippets | list | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| mapit_service_dns_name | DNS name to access the mapit internal service |

