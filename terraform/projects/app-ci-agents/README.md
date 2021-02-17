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

## Modules

| Name | Source | Version |
|------|--------|---------|
| alarms-elb-ci-agent-1-internal | ../../modules/aws/alarms/elb |  |
| alarms-elb-ci-agent-2-internal | ../../modules/aws/alarms/elb |  |
| alarms-elb-ci-agent-3-internal | ../../modules/aws/alarms/elb |  |
| alarms-elb-ci-agent-4-internal | ../../modules/aws/alarms/elb |  |
| alarms-elb-ci-agent-5-internal | ../../modules/aws/alarms/elb |  |
| alarms-elb-ci-agent-6-internal | ../../modules/aws/alarms/elb |  |
| alarms-elb-ci-agent-7-internal | ../../modules/aws/alarms/elb |  |
| alarms-elb-ci-agent-8-internal | ../../modules/aws/alarms/elb |  |
| ci-agent-1 | ../../modules/aws/node_group |  |
| ci-agent-2 | ../../modules/aws/node_group |  |
| ci-agent-3 | ../../modules/aws/node_group |  |
| ci-agent-4 | ../../modules/aws/node_group |  |
| ci-agent-5 | ../../modules/aws/node_group |  |
| ci-agent-6 | ../../modules/aws/node_group |  |
| ci-agent-7 | ../../modules/aws/node_group |  |
| ci-agent-8 | ../../modules/aws/node_group |  |

## Resources

| Name |
|------|
| [aws_acm_certificate](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/acm_certificate) |
| [aws_ebs_volume](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/ebs_volume) |
| [aws_elb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/elb) |
| [aws_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy) |
| [aws_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy_attachment) |
| [aws_route53_record](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) |
| [aws_route53_zone](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/route53_zone) |
| [null_resource](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) |
| [terraform_remote_state](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) |

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
