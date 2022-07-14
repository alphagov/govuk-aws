## Project: app-data-science

Data science experimentation playground.

Run resource intensive scripts for data science purposes.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | = 0.11.15 |
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
| <a name="module_alarms-elb-data-science-internal"></a> [alarms-elb-data-science-internal](#module\_alarms-elb-data-science-internal) | ../../modules/aws/alarms/elb | n/a |
| <a name="module_data-science-1"></a> [data-science-1](#module\_data-science-1) | ../../modules/aws/node_group | n/a |
| <a name="module_data-science-2"></a> [data-science-2](#module\_data-science-2) | ../../modules/aws/node_group | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_elb.data-science_external_elb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/elb) | resource |
| [aws_security_group.data-science](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group_rule.data-science_egress_any_any](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.data-science_ingress_offsite-ssh_ssh](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [null_resource.user_data](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [terraform_remote_state.infra_monitoring](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_networking](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_root_dns_zones](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_security_groups](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_stack_dns_zones](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_vpc](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_environment"></a> [aws\_environment](#input\_aws\_environment) | AWS environment | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"eu-west-2"` | no |
| <a name="input_esm_trusty_token"></a> [esm\_trusty\_token](#input\_esm\_trusty\_token) | n/a | `string` | n/a | yes |
| <a name="input_instance_ami_filter_name"></a> [instance\_ami\_filter\_name](#input\_instance\_ami\_filter\_name) | Name to use to find AMI images | `string` | `""` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type used for EC2 resources | `string` | `"c5.4xlarge"` | no |
| <a name="input_machine_learning_instance_type"></a> [machine\_learning\_instance\_type](#input\_machine\_learning\_instance\_type) | Instance type used for EC2 resources | `string` | `"p3.8xlarge"` | no |
| <a name="input_office_ips"></a> [office\_ips](#input\_office\_ips) | An array of CIDR blocks that will be allowed offsite access. | `list` | n/a | yes |
| <a name="input_remote_state_bucket"></a> [remote\_state\_bucket](#input\_remote\_state\_bucket) | S3 bucket we store our terraform state in | `string` | n/a | yes |
| <a name="input_remote_state_infra_monitoring_key_stack"></a> [remote\_state\_infra\_monitoring\_key\_stack](#input\_remote\_state\_infra\_monitoring\_key\_stack) | Override stackname path to infra\_monitoring remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_networking_key_stack"></a> [remote\_state\_infra\_networking\_key\_stack](#input\_remote\_state\_infra\_networking\_key\_stack) | Override infra\_networking remote state path | `string` | `""` | no |
| <a name="input_remote_state_infra_root_dns_zones_key_stack"></a> [remote\_state\_infra\_root\_dns\_zones\_key\_stack](#input\_remote\_state\_infra\_root\_dns\_zones\_key\_stack) | Override stackname path to infra\_root\_dns\_zones remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_security_groups_key_stack"></a> [remote\_state\_infra\_security\_groups\_key\_stack](#input\_remote\_state\_infra\_security\_groups\_key\_stack) | Override infra\_security\_groups stackname path to infra\_vpc remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_stack_dns_zones_key_stack"></a> [remote\_state\_infra\_stack\_dns\_zones\_key\_stack](#input\_remote\_state\_infra\_stack\_dns\_zones\_key\_stack) | Override stackname path to infra\_stack\_dns\_zones remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_vpc_key_stack"></a> [remote\_state\_infra\_vpc\_key\_stack](#input\_remote\_state\_infra\_vpc\_key\_stack) | Override infra\_vpc remote state path | `string` | `""` | no |
| <a name="input_stackname"></a> [stackname](#input\_stackname) | Stackname | `string` | n/a | yes |
| <a name="input_user_data_snippets"></a> [user\_data\_snippets](#input\_user\_data\_snippets) | List of user-data snippets | `list` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_data-science_elb_address"></a> [data-science\_elb\_address](#output\_data-science\_elb\_address) | AWS' internal DNS name for the data-science ELB |
