## Project: app-ci-agents

CI agents

## Requirements

| Name | Version |
|------|---------|
| terraform | = 0.11.14 |
| aws | 2.46.0 |

## Providers

| Name | Version |
|------|---------|
| aws | 2.46.0 |
| null | n/a |
| terraform | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_environment | AWS Environment | `string` | n/a | yes |
| aws\_region | AWS region | `string` | `"eu-west-1"` | no |
| ci\_agent\_1\_subnet | subnet to deploy EC2 and EBS of CI agent 1 | `string` | `"govuk_private_a"` | no |
| ci\_agent\_2\_subnet | subnet to deploy EC2 and EBS of CI agent 2 | `string` | `"govuk_private_b"` | no |
| ci\_agent\_3\_subnet | subnet to deploy EC2 and EBS of CI agent 3 | `string` | `"govuk_private_c"` | no |
| ci\_agent\_4\_subnet | subnet to deploy EC2 and EBS of CI agent 4 | `string` | `"govuk_private_a"` | no |
| ci\_agent\_5\_subnet | subnet to deploy EC2 and EBS of CI agent 5 | `string` | `"govuk_private_b"` | no |
| ci\_agent\_6\_subnet | subnet to deploy EC2 and EBS of CI agent 6 | `string` | `"govuk_private_c"` | no |
| ci\_agent\_7\_subnet | subnet to deploy EC2 and EBS of CI agent 7 | `string` | `"govuk_private_a"` | no |
| ci\_agent\_8\_subnet | subnet to deploy EC2 and EBS of CI agent 8 | `string` | `"govuk_private_b"` | no |
| ebs\_encrypted | whether or not the EBS volume is encrypted | `string` | `"true"` | no |
| elb\_internal\_certname | The ACM cert domain name to find the ARN of | `string` | n/a | yes |
| instance\_ami\_filter\_name | Name to use to find AMI images | `string` | `""` | no |
| instance\_type | Instance type used for EC2 resources | `string` | `"m5.2xlarge"` | no |
| internal\_app\_service\_records | List of application service names that get traffic via this loadbalancer | `list` | `[]` | no |
| internal\_domain\_name | The domain name of the internal DNS records, it could be different from the zone name | `string` | n/a | yes |
| internal\_zone\_name | The name of the Route53 zone that contains internal records | `string` | n/a | yes |
| remote\_state\_bucket | S3 bucket we store our terraform state in | `string` | n/a | yes |
| remote\_state\_infra\_monitoring\_key\_stack | Override stackname path to infra\_monitoring remote state | `string` | `""` | no |
| remote\_state\_infra\_networking\_key\_stack | Override infra\_networking remote state path | `string` | `""` | no |
| remote\_state\_infra\_root\_dns\_zones\_key\_stack | Override stackname path to infra\_root\_dns\_zones remote state | `string` | `""` | no |
| remote\_state\_infra\_security\_groups\_key\_stack | Override infra\_security\_groups stackname path to infra\_vpc remote state | `string` | `""` | no |
| remote\_state\_infra\_stack\_dns\_zones\_key\_stack | Override stackname path to infra\_stack\_dns\_zones remote state | `string` | `""` | no |
| remote\_state\_infra\_vpc\_key\_stack | Override infra\_vpc remote state path | `string` | `""` | no |
| root\_block\_device\_volume\_size | size of the root volume in GB | `string` | `"50"` | no |
| stackname | Stackname | `string` | n/a | yes |
| user\_data\_snippets | List of user-data snippets | `list` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| ci-agent-1\_elb\_dns\_name | DNS name to access the CI agent 1 service |
| ci-agent-1\_service\_dns\_name | DNS name to access the CI agent 1 service |
| ci-agent-2\_elb\_dns\_name | DNS name to access the CI agent 2 service |
| ci-agent-2\_service\_dns\_name | DNS name to access the CI agent 2 service |
| ci-agent-3\_elb\_dns\_name | DNS name to access the CI agent 3 service |
| ci-agent-3\_service\_dns\_name | DNS name to access the CI agent 3 service |
| ci-agent-4\_elb\_dns\_name | DNS name to access the CI agent 4 service |
| ci-agent-4\_service\_dns\_name | DNS name to access the CI agent 4 service |
| ci-agent-5\_elb\_dns\_name | DNS name to access the CI agent 5 service |
| ci-agent-5\_service\_dns\_name | DNS name to access the CI agent 5 service |
| ci-agent-6\_elb\_dns\_name | DNS name to access the CI agent 6 service |
| ci-agent-6\_service\_dns\_name | DNS name to access the CI agent 6 service |
| ci-agent-7\_elb\_dns\_name | DNS name to access the CI agent 7 service |
| ci-agent-7\_service\_dns\_name | DNS name to access the CI agent 7 service |
| ci-agent-8\_elb\_dns\_name | DNS name to access the CI agent 8 service |
| ci-agent-8\_service\_dns\_name | DNS name to access the CI agent 8 service |

