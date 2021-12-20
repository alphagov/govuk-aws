## Project: app-data-science-data

Data science data

A central place where data is generated on a daily basis to be used by multiple data science projects, including related links and the knowledge graph.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | = 0.11.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 1.40.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 1.40.0 |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.data-science-data_asg](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/autoscaling_group) | resource |
| [aws_autoscaling_schedule.data-science-data_schedule-spin-down](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/autoscaling_schedule) | resource |
| [aws_autoscaling_schedule.data-science-data_schedule-spin-up](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/autoscaling_schedule) | resource |
| [aws_iam_instance_profile.data-science-data_instance_profile](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.data-science-data_read_ssm_policy](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.invoke_sagemaker_govner_endpoint_policy](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.read_secrets_from_secrets_manager_policy](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.data-science-data_role](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.data-science-data_read_content_store_backups_bucket_role_attachment](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.data-science-data_read_related_links_bucket_role_attachment](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.data-science-data_read_ssm_role_attachment](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.invoke_sagemaker_govner_endpoint_role_attachment](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.read_secrets_from_secrets_manager_role_attachment](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.read_write_data_infrastructure_bucket_role_attachment](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_launch_template.data-science-data_launch_template](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/launch_template) | resource |
| [aws_security_group_rule.publishing-api-rds_ingress_data-science-data_postgres](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/security_group_rule) | resource |
| [aws_ami.ubuntu_bionic](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/data-sources/ami) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.data-science-data_read_ssm_policy_document](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.invoke_sagemaker_govner_endpoint_policy_document](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.read_secrets_from_secrets_manager_policy_document](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/data-sources/iam_policy_document) | data source |
| [aws_secretsmanager_secret.secret_big_query_service_account_key](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/data-sources/secretsmanager_secret) | data source |
| [aws_security_group.publishing-api-rds](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/data-sources/security_group) | data source |
| [template_file.data-science-data_userdata](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.ec2_assume_policy_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [terraform_remote_state.app_knowledge_graph](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.app_related_links](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_database_backups_bucket](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
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
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"eu-west-1"` | no |
| <a name="input_remote_state_app_knowledge_graph_key_stack"></a> [remote\_state\_app\_knowledge\_graph\_key\_stack](#input\_remote\_state\_app\_knowledge\_graph\_key\_stack) | Override app\_knowledge\_graph remote state path | `string` | `""` | no |
| <a name="input_remote_state_app_related_links_key_stack"></a> [remote\_state\_app\_related\_links\_key\_stack](#input\_remote\_state\_app\_related\_links\_key\_stack) | Override stackname path to app\_related\_links remote state | `string` | `""` | no |
| <a name="input_remote_state_bucket"></a> [remote\_state\_bucket](#input\_remote\_state\_bucket) | S3 bucket we store our terraform state in | `string` | n/a | yes |
| <a name="input_remote_state_infra_database_backups_bucket_key_stack"></a> [remote\_state\_infra\_database\_backups\_bucket\_key\_stack](#input\_remote\_state\_infra\_database\_backups\_bucket\_key\_stack) | Override stackname path to infra\_database\_backups\_bucket remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_monitoring_key_stack"></a> [remote\_state\_infra\_monitoring\_key\_stack](#input\_remote\_state\_infra\_monitoring\_key\_stack) | Override stackname path to infra\_monitoring remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_networking_key_stack"></a> [remote\_state\_infra\_networking\_key\_stack](#input\_remote\_state\_infra\_networking\_key\_stack) | Override infra\_networking remote state path | `string` | `""` | no |
| <a name="input_remote_state_infra_root_dns_zones_key_stack"></a> [remote\_state\_infra\_root\_dns\_zones\_key\_stack](#input\_remote\_state\_infra\_root\_dns\_zones\_key\_stack) | Override stackname path to infra\_root\_dns\_zones remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_security_groups_key_stack"></a> [remote\_state\_infra\_security\_groups\_key\_stack](#input\_remote\_state\_infra\_security\_groups\_key\_stack) | Override infra\_security\_groups stackname path to infra\_vpc remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_stack_dns_zones_key_stack"></a> [remote\_state\_infra\_stack\_dns\_zones\_key\_stack](#input\_remote\_state\_infra\_stack\_dns\_zones\_key\_stack) | Override stackname path to infra\_stack\_dns\_zones remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_vpc_key_stack"></a> [remote\_state\_infra\_vpc\_key\_stack](#input\_remote\_state\_infra\_vpc\_key\_stack) | Override infra\_vpc remote state path | `string` | `""` | no |
| <a name="input_stackname"></a> [stackname](#input\_stackname) | Stackname | `string` | n/a | yes |
| <a name="input_use_split_database"></a> [use\_split\_database](#input\_use\_split\_database) | Set to 1 to use the new split database instances | `string` | `"0"` | no |

## Outputs

No outputs.
