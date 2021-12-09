## Project: app-related-links

Related Links

Run resource intensive scripts for data science purposes.

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
| [aws_autoscaling_group.related-links-generation](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/autoscaling_group) | resource |
| [aws_autoscaling_group.related-links-ingestion](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/autoscaling_group) | resource |
| [aws_iam_instance_profile.related-links_instance-profile](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.read_content_store_backups_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.read_secrets_from_secrets_manager_policy](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.read_write_related_links_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.related_links_jenkins_policy](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.ec2_role](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.attach_read_content_store_backups_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.attach_read_secrets_from_secrets_manager_policy](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.attach_read_write_related_links_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_key_pair.jenkins_public_key](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/key_pair) | resource |
| [aws_launch_template.related-links-generation_launch-template](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/launch_template) | resource |
| [aws_launch_template.related-links-ingestion_launch-template](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/launch_template) | resource |
| [aws_s3_bucket.s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/s3_bucket) | resource |
| [aws_ami.ubuntu_bionic](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/data-sources/ami) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.read_content_store_backups_bucket_policy_document](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.read_secrets_from_secrets_manager_policy_document](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.read_write_related_links_bucket_policy_document](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.related_links_jenkins_policy_document](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/data-sources/region) | data source |
| [aws_secretsmanager_secret.secret_big_query_service_account_key](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/data-sources/secretsmanager_secret) | data source |
| [aws_secretsmanager_secret.secret_publishing_api_bearer_token](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/data-sources/secretsmanager_secret) | data source |
| [template_file.ec2_assume_policy_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.provision-generation-instance-userdata](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.provision-ingestion-instance-userdata](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
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
| <a name="input_remote_state_bucket"></a> [remote\_state\_bucket](#input\_remote\_state\_bucket) | S3 bucket we store our terraform state in | `string` | n/a | yes |
| <a name="input_remote_state_infra_database_backups_bucket_key_stack"></a> [remote\_state\_infra\_database\_backups\_bucket\_key\_stack](#input\_remote\_state\_infra\_database\_backups\_bucket\_key\_stack) | Override stackname path to infra\_database\_backups\_bucket remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_monitoring_key_stack"></a> [remote\_state\_infra\_monitoring\_key\_stack](#input\_remote\_state\_infra\_monitoring\_key\_stack) | Override stackname path to infra\_monitoring remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_networking_key_stack"></a> [remote\_state\_infra\_networking\_key\_stack](#input\_remote\_state\_infra\_networking\_key\_stack) | Override infra\_networking remote state path | `string` | `""` | no |
| <a name="input_remote_state_infra_root_dns_zones_key_stack"></a> [remote\_state\_infra\_root\_dns\_zones\_key\_stack](#input\_remote\_state\_infra\_root\_dns\_zones\_key\_stack) | Override stackname path to infra\_root\_dns\_zones remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_security_groups_key_stack"></a> [remote\_state\_infra\_security\_groups\_key\_stack](#input\_remote\_state\_infra\_security\_groups\_key\_stack) | Override infra\_security\_groups stackname path to infra\_vpc remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_stack_dns_zones_key_stack"></a> [remote\_state\_infra\_stack\_dns\_zones\_key\_stack](#input\_remote\_state\_infra\_stack\_dns\_zones\_key\_stack) | Override stackname path to infra\_stack\_dns\_zones remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_vpc_key_stack"></a> [remote\_state\_infra\_vpc\_key\_stack](#input\_remote\_state\_infra\_vpc\_key\_stack) | Override infra\_vpc remote state path | `string` | `""` | no |
| <a name="input_stackname"></a> [stackname](#input\_stackname) | Stackname | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_policy_read_content_store_backups_bucket_policy_arn"></a> [policy\_read\_content\_store\_backups\_bucket\_policy\_arn](#output\_policy\_read\_content\_store\_backups\_bucket\_policy\_arn) | ARN of the policy used to read content store backups from the database backups bucket |
| <a name="output_policy_read_write_related_links_bucket_policy_arn"></a> [policy\_read\_write\_related\_links\_bucket\_policy\_arn](#output\_policy\_read\_write\_related\_links\_bucket\_policy\_arn) | ARN of the policy used to read/write data from/to the related links bucket |
| <a name="output_policy_related_links_jenkins_policy_arn"></a> [policy\_related\_links\_jenkins\_policy\_arn](#output\_policy\_related\_links\_jenkins\_policy\_arn) | ARN of the policy used by Jenkins to manage related links generation and ingestion |
