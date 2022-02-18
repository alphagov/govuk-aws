## Project: app-licensify-documentdb

DocumentDB cluster for Licensify

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | = 0.11.15 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 2.46.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 2.46.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_docdb_cluster.licensify_cluster](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/docdb_cluster) | resource |
| [aws_docdb_cluster_instance.licensify_cluster_instances](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/docdb_cluster_instance) | resource |
| [aws_docdb_cluster_parameter_group.licensify_parameter_group](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/docdb_cluster_parameter_group) | resource |
| [aws_docdb_subnet_group.licensify_cluster_subnet](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/docdb_subnet_group) | resource |
| [terraform_remote_state.infra_networking](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_security](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_security_groups](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_environment"></a> [aws\_environment](#input\_aws\_environment) | AWS environment | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"eu-west-1"` | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | Retention period in days for DocumentDB automatic snapshots | `string` | `"1"` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Instance count used for Licensify DocumentDB resources | `string` | `"3"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type used for Licensify DocumentDB resources | `string` | `"db.r5.large"` | no |
| <a name="input_master_password"></a> [master\_password](#input\_master\_password) | Password of master user on Licensify DocumentDB cluster | `string` | n/a | yes |
| <a name="input_master_username"></a> [master\_username](#input\_master\_username) | Username of master user on Licensify DocumentDB cluster | `string` | n/a | yes |
| <a name="input_profiler"></a> [profiler](#input\_profiler) | Whether to log slow queries to CloudWatch. Must be either 'enabled' or 'disabled'. | `string` | `"enabled"` | no |
| <a name="input_profiler_threshold_ms"></a> [profiler\_threshold\_ms](#input\_profiler\_threshold\_ms) | Queries which take longer than this number of milliseconds are logged to CloudWatch if profiler is enabled. Minimum is 50. | `string` | `"300"` | no |
| <a name="input_remote_state_bucket"></a> [remote\_state\_bucket](#input\_remote\_state\_bucket) | S3 bucket we store our terraform state in | `string` | n/a | yes |
| <a name="input_remote_state_infra_networking_key_stack"></a> [remote\_state\_infra\_networking\_key\_stack](#input\_remote\_state\_infra\_networking\_key\_stack) | Override infra\_networking remote state path | `string` | `""` | no |
| <a name="input_remote_state_infra_security_groups_key_stack"></a> [remote\_state\_infra\_security\_groups\_key\_stack](#input\_remote\_state\_infra\_security\_groups\_key\_stack) | Override infra\_security\_groups stackname path to infra\_vpc remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_security_key_stack"></a> [remote\_state\_infra\_security\_key\_stack](#input\_remote\_state\_infra\_security\_key\_stack) | Override infra\_security stackname path to infra\_vpc remote state | `string` | `""` | no |
| <a name="input_stackname"></a> [stackname](#input\_stackname) | Stackname | `string` | n/a | yes |
| <a name="input_tls"></a> [tls](#input\_tls) | Whether to enable or disable TLS for the Licensify DocumentDB cluster. Must be either 'enabled' or 'disabled'. | `string` | `"enabled"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_licensify_documentdb_endpoint"></a> [licensify\_documentdb\_endpoint](#output\_licensify\_documentdb\_endpoint) | The endpoint of the Licensify DocumentDB |
