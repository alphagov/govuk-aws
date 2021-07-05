## Project: app-ci-agents

CI agents

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | = 0.11.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 2.46.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 2.46.0 |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alarms-elb-ci-agent-1-internal"></a> [alarms-elb-ci-agent-1-internal](#module\_alarms-elb-ci-agent-1-internal) | ../../modules/aws/alarms/elb | n/a |
| <a name="module_alarms-elb-ci-agent-2-internal"></a> [alarms-elb-ci-agent-2-internal](#module\_alarms-elb-ci-agent-2-internal) | ../../modules/aws/alarms/elb | n/a |
| <a name="module_alarms-elb-ci-agent-3-internal"></a> [alarms-elb-ci-agent-3-internal](#module\_alarms-elb-ci-agent-3-internal) | ../../modules/aws/alarms/elb | n/a |
| <a name="module_alarms-elb-ci-agent-4-internal"></a> [alarms-elb-ci-agent-4-internal](#module\_alarms-elb-ci-agent-4-internal) | ../../modules/aws/alarms/elb | n/a |
| <a name="module_alarms-elb-ci-agent-5-internal"></a> [alarms-elb-ci-agent-5-internal](#module\_alarms-elb-ci-agent-5-internal) | ../../modules/aws/alarms/elb | n/a |
| <a name="module_alarms-elb-ci-agent-6-internal"></a> [alarms-elb-ci-agent-6-internal](#module\_alarms-elb-ci-agent-6-internal) | ../../modules/aws/alarms/elb | n/a |
| <a name="module_alarms-elb-ci-agent-7-internal"></a> [alarms-elb-ci-agent-7-internal](#module\_alarms-elb-ci-agent-7-internal) | ../../modules/aws/alarms/elb | n/a |
| <a name="module_alarms-elb-ci-agent-8-internal"></a> [alarms-elb-ci-agent-8-internal](#module\_alarms-elb-ci-agent-8-internal) | ../../modules/aws/alarms/elb | n/a |
| <a name="module_ci-agent-1"></a> [ci-agent-1](#module\_ci-agent-1) | ../../modules/aws/node_group | n/a |
| <a name="module_ci-agent-2"></a> [ci-agent-2](#module\_ci-agent-2) | ../../modules/aws/node_group | n/a |
| <a name="module_ci-agent-3"></a> [ci-agent-3](#module\_ci-agent-3) | ../../modules/aws/node_group | n/a |
| <a name="module_ci-agent-4"></a> [ci-agent-4](#module\_ci-agent-4) | ../../modules/aws/node_group | n/a |
| <a name="module_ci-agent-5"></a> [ci-agent-5](#module\_ci-agent-5) | ../../modules/aws/node_group | n/a |
| <a name="module_ci-agent-6"></a> [ci-agent-6](#module\_ci-agent-6) | ../../modules/aws/node_group | n/a |
| <a name="module_ci-agent-7"></a> [ci-agent-7](#module\_ci-agent-7) | ../../modules/aws/node_group | n/a |
| <a name="module_ci-agent-8"></a> [ci-agent-8](#module\_ci-agent-8) | ../../modules/aws/node_group | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ebs_volume.ci-agent-1-data](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/ebs_volume) | resource |
| [aws_ebs_volume.ci-agent-1-docker](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/ebs_volume) | resource |
| [aws_ebs_volume.ci-agent-2-data](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/ebs_volume) | resource |
| [aws_ebs_volume.ci-agent-2-docker](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/ebs_volume) | resource |
| [aws_ebs_volume.ci-agent-3-data](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/ebs_volume) | resource |
| [aws_ebs_volume.ci-agent-3-docker](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/ebs_volume) | resource |
| [aws_ebs_volume.ci-agent-4-data](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/ebs_volume) | resource |
| [aws_ebs_volume.ci-agent-4-docker](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/ebs_volume) | resource |
| [aws_ebs_volume.ci-agent-5-data](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/ebs_volume) | resource |
| [aws_ebs_volume.ci-agent-5-docker](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/ebs_volume) | resource |
| [aws_ebs_volume.ci-agent-6-data](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/ebs_volume) | resource |
| [aws_ebs_volume.ci-agent-6-docker](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/ebs_volume) | resource |
| [aws_ebs_volume.ci-agent-7-data](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/ebs_volume) | resource |
| [aws_ebs_volume.ci-agent-7-docker](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/ebs_volume) | resource |
| [aws_ebs_volume.ci-agent-8-data](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/ebs_volume) | resource |
| [aws_ebs_volume.ci-agent-8-docker](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/ebs_volume) | resource |
| [aws_elb.ci-agent-1_elb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/elb) | resource |
| [aws_elb.ci-agent-2_elb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/elb) | resource |
| [aws_elb.ci-agent-3_elb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/elb) | resource |
| [aws_elb.ci-agent-4_elb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/elb) | resource |
| [aws_elb.ci-agent-5_elb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/elb) | resource |
| [aws_elb.ci-agent-6_elb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/elb) | resource |
| [aws_elb.ci-agent-7_elb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/elb) | resource |
| [aws_elb.ci-agent-8_elb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/elb) | resource |
| [aws_iam_policy.ci-agent-2_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.ci-agent_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.ci-agent-1_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ci-agent-2_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ci-agent-3_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ci-agent-4_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ci-agent-5_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ci-agent-6_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ci-agent-7_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ci-agent-8_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_route53_record.ci-agent-1_service_record](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.ci-agent-2_service_record](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.ci-agent-3_service_record](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.ci-agent-4_service_record](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.ci-agent-5_service_record](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.ci-agent-6_service_record](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.ci-agent-7_service_record](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.ci-agent-8_service_record](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [null_resource.user_data](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_acm_certificate.elb_cert](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/acm_certificate) | data source |
| [aws_route53_zone.internal](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/route53_zone) | data source |
| [terraform_remote_state.infra_monitoring](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_networking](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_root_dns_zones](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_security_groups](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_stack_dns_zones](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_vpc](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_environment"></a> [aws\_environment](#input\_aws\_environment) | AWS Environment | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"eu-west-1"` | no |
| <a name="input_ci_agent_1_subnet"></a> [ci\_agent\_1\_subnet](#input\_ci\_agent\_1\_subnet) | subnet to deploy EC2 and EBS of CI agent 1 | `string` | `"govuk_private_a"` | no |
| <a name="input_ci_agent_2_subnet"></a> [ci\_agent\_2\_subnet](#input\_ci\_agent\_2\_subnet) | subnet to deploy EC2 and EBS of CI agent 2 | `string` | `"govuk_private_b"` | no |
| <a name="input_ci_agent_3_subnet"></a> [ci\_agent\_3\_subnet](#input\_ci\_agent\_3\_subnet) | subnet to deploy EC2 and EBS of CI agent 3 | `string` | `"govuk_private_c"` | no |
| <a name="input_ci_agent_4_subnet"></a> [ci\_agent\_4\_subnet](#input\_ci\_agent\_4\_subnet) | subnet to deploy EC2 and EBS of CI agent 4 | `string` | `"govuk_private_a"` | no |
| <a name="input_ci_agent_5_subnet"></a> [ci\_agent\_5\_subnet](#input\_ci\_agent\_5\_subnet) | subnet to deploy EC2 and EBS of CI agent 5 | `string` | `"govuk_private_b"` | no |
| <a name="input_ci_agent_6_subnet"></a> [ci\_agent\_6\_subnet](#input\_ci\_agent\_6\_subnet) | subnet to deploy EC2 and EBS of CI agent 6 | `string` | `"govuk_private_c"` | no |
| <a name="input_ci_agent_7_subnet"></a> [ci\_agent\_7\_subnet](#input\_ci\_agent\_7\_subnet) | subnet to deploy EC2 and EBS of CI agent 7 | `string` | `"govuk_private_a"` | no |
| <a name="input_ci_agent_8_subnet"></a> [ci\_agent\_8\_subnet](#input\_ci\_agent\_8\_subnet) | subnet to deploy EC2 and EBS of CI agent 8 | `string` | `"govuk_private_b"` | no |
| <a name="input_ebs_encrypted"></a> [ebs\_encrypted](#input\_ebs\_encrypted) | whether or not the EBS volume is encrypted | `string` | `"true"` | no |
| <a name="input_elb_internal_certname"></a> [elb\_internal\_certname](#input\_elb\_internal\_certname) | The ACM cert domain name to find the ARN of | `string` | n/a | yes |
| <a name="input_instance_ami_filter_name"></a> [instance\_ami\_filter\_name](#input\_instance\_ami\_filter\_name) | Name to use to find AMI images | `string` | `""` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type used for EC2 resources | `string` | `"m5.2xlarge"` | no |
| <a name="input_internal_app_service_records"></a> [internal\_app\_service\_records](#input\_internal\_app\_service\_records) | List of application service names that get traffic via this loadbalancer | `list` | `[]` | no |
| <a name="input_internal_domain_name"></a> [internal\_domain\_name](#input\_internal\_domain\_name) | The domain name of the internal DNS records, it could be different from the zone name | `string` | n/a | yes |
| <a name="input_internal_zone_name"></a> [internal\_zone\_name](#input\_internal\_zone\_name) | The name of the Route53 zone that contains internal records | `string` | n/a | yes |
| <a name="input_remote_state_bucket"></a> [remote\_state\_bucket](#input\_remote\_state\_bucket) | S3 bucket we store our terraform state in | `string` | n/a | yes |
| <a name="input_remote_state_infra_monitoring_key_stack"></a> [remote\_state\_infra\_monitoring\_key\_stack](#input\_remote\_state\_infra\_monitoring\_key\_stack) | Override stackname path to infra\_monitoring remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_networking_key_stack"></a> [remote\_state\_infra\_networking\_key\_stack](#input\_remote\_state\_infra\_networking\_key\_stack) | Override infra\_networking remote state path | `string` | `""` | no |
| <a name="input_remote_state_infra_root_dns_zones_key_stack"></a> [remote\_state\_infra\_root\_dns\_zones\_key\_stack](#input\_remote\_state\_infra\_root\_dns\_zones\_key\_stack) | Override stackname path to infra\_root\_dns\_zones remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_security_groups_key_stack"></a> [remote\_state\_infra\_security\_groups\_key\_stack](#input\_remote\_state\_infra\_security\_groups\_key\_stack) | Override infra\_security\_groups stackname path to infra\_vpc remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_stack_dns_zones_key_stack"></a> [remote\_state\_infra\_stack\_dns\_zones\_key\_stack](#input\_remote\_state\_infra\_stack\_dns\_zones\_key\_stack) | Override stackname path to infra\_stack\_dns\_zones remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_vpc_key_stack"></a> [remote\_state\_infra\_vpc\_key\_stack](#input\_remote\_state\_infra\_vpc\_key\_stack) | Override infra\_vpc remote state path | `string` | `""` | no |
| <a name="input_root_block_device_volume_size"></a> [root\_block\_device\_volume\_size](#input\_root\_block\_device\_volume\_size) | size of the root volume in GB | `string` | `"50"` | no |
| <a name="input_stackname"></a> [stackname](#input\_stackname) | Stackname | `string` | n/a | yes |
| <a name="input_user_data_snippets"></a> [user\_data\_snippets](#input\_user\_data\_snippets) | List of user-data snippets | `list` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ci-agent-1_elb_dns_name"></a> [ci-agent-1\_elb\_dns\_name](#output\_ci-agent-1\_elb\_dns\_name) | DNS name to access the CI agent 1 service |
| <a name="output_ci-agent-1_service_dns_name"></a> [ci-agent-1\_service\_dns\_name](#output\_ci-agent-1\_service\_dns\_name) | DNS name to access the CI agent 1 service |
| <a name="output_ci-agent-2_elb_dns_name"></a> [ci-agent-2\_elb\_dns\_name](#output\_ci-agent-2\_elb\_dns\_name) | DNS name to access the CI agent 2 service |
| <a name="output_ci-agent-2_service_dns_name"></a> [ci-agent-2\_service\_dns\_name](#output\_ci-agent-2\_service\_dns\_name) | DNS name to access the CI agent 2 service |
| <a name="output_ci-agent-3_elb_dns_name"></a> [ci-agent-3\_elb\_dns\_name](#output\_ci-agent-3\_elb\_dns\_name) | DNS name to access the CI agent 3 service |
| <a name="output_ci-agent-3_service_dns_name"></a> [ci-agent-3\_service\_dns\_name](#output\_ci-agent-3\_service\_dns\_name) | DNS name to access the CI agent 3 service |
| <a name="output_ci-agent-4_elb_dns_name"></a> [ci-agent-4\_elb\_dns\_name](#output\_ci-agent-4\_elb\_dns\_name) | DNS name to access the CI agent 4 service |
| <a name="output_ci-agent-4_service_dns_name"></a> [ci-agent-4\_service\_dns\_name](#output\_ci-agent-4\_service\_dns\_name) | DNS name to access the CI agent 4 service |
| <a name="output_ci-agent-5_elb_dns_name"></a> [ci-agent-5\_elb\_dns\_name](#output\_ci-agent-5\_elb\_dns\_name) | DNS name to access the CI agent 5 service |
| <a name="output_ci-agent-5_service_dns_name"></a> [ci-agent-5\_service\_dns\_name](#output\_ci-agent-5\_service\_dns\_name) | DNS name to access the CI agent 5 service |
| <a name="output_ci-agent-6_elb_dns_name"></a> [ci-agent-6\_elb\_dns\_name](#output\_ci-agent-6\_elb\_dns\_name) | DNS name to access the CI agent 6 service |
| <a name="output_ci-agent-6_service_dns_name"></a> [ci-agent-6\_service\_dns\_name](#output\_ci-agent-6\_service\_dns\_name) | DNS name to access the CI agent 6 service |
| <a name="output_ci-agent-7_elb_dns_name"></a> [ci-agent-7\_elb\_dns\_name](#output\_ci-agent-7\_elb\_dns\_name) | DNS name to access the CI agent 7 service |
| <a name="output_ci-agent-7_service_dns_name"></a> [ci-agent-7\_service\_dns\_name](#output\_ci-agent-7\_service\_dns\_name) | DNS name to access the CI agent 7 service |
| <a name="output_ci-agent-8_elb_dns_name"></a> [ci-agent-8\_elb\_dns\_name](#output\_ci-agent-8\_elb\_dns\_name) | DNS name to access the CI agent 8 service |
| <a name="output_ci-agent-8_service_dns_name"></a> [ci-agent-8\_service\_dns\_name](#output\_ci-agent-8\_service\_dns\_name) | DNS name to access the CI agent 8 service |
