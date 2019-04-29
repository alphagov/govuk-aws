## Project: fastly-datagovuk

Manages the Fastly service for data.gov.uk


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_environment | AWS Environment | string | - | yes |
| aws_region | AWS region | string | `eu-west-1` | no |
| backend_domain | The domain of the data.gov.uk PaaS instance to forward requests to | string | - | yes |
| domain | The domain of the data.gov.uk service to manage | string | - | yes |
| fastly_api_key | API key to authenticate with Fastly | string | - | yes |
| logging_aws_access_key_id | IAM key ID with access to put logs into the S3 bucket | string | - | yes |
| logging_aws_secret_access_key | IAM secret key with access to put logs into the S3 bucket | string | - | yes |
| remote_state_bucket | S3 bucket we store our terraform state in | string | - | yes |
| remote_state_infra_monitoring_key_stack | Override stackname path to infra_monitoring remote state | string | `` | no |
| remote_state_infra_networking_key_stack | Override infra_networking remote state path | string | `` | no |
| remote_state_infra_root_dns_zones_key_stack | Override stackname path to infra_root_dns_zones remote state | string | `` | no |
| remote_state_infra_security_groups_key_stack | Override infra_security_groups stackname path to infra_vpc remote state | string | `` | no |
| remote_state_infra_stack_dns_zones_key_stack | Override stackname path to infra_stack_dns_zones remote state | string | `` | no |
| remote_state_infra_vpc_key_stack | Override infra_vpc remote state path | string | `` | no |
| stackname | Stackname | string | - | yes |

