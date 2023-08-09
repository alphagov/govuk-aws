## Project: app-elasticsearch6

Managed Elasticsearch 6 cluster

The snapshot repository configuration is not currently done via Terraform;
see register-snapshot-repository.py.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.elasticsearch6_application_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.elasticsearch6_index_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.elasticsearch6_search_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_resource_policy.elasticsearch6_log_resource_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_resource_policy) | resource |
| [aws_elasticsearch_domain.elasticsearch6](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticsearch_domain) | resource |
| [aws_iam_policy.can_configure_es_snapshots](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.manual_snapshot_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy_attachment.manual_snapshot_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_role.manual_snapshot_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_service_linked_role.role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_service_linked_role) | resource |
| [aws_route53_record.service_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_s3_bucket.manual_snapshots](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_logging.manual_snapshots](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_policy.manual_snapshots_cross_account_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_acm_certificate.govuk_internal](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.can_configure_es_snapshots](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.elasticsearch6_log_publishing_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.es_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.es_can_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.manual_snapshot_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.manual_snapshots_cross_account_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route53_zone.internal](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [terraform_remote_state.infra_monitoring](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_networking](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_root_dns_zones](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_security_groups](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_stack_dns_zones](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_vpc](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_environment"></a> [aws\_environment](#input\_aws\_environment) | AWS Environment | `any` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"eu-west-1"` | no |
| <a name="input_cloudwatch_log_retention"></a> [cloudwatch\_log\_retention](#input\_cloudwatch\_log\_retention) | Number of days to retain Cloudwatch logs for | `number` | `90` | no |
| <a name="input_elasticsearch6_dedicated_master_enabled"></a> [elasticsearch6\_dedicated\_master\_enabled](#input\_elasticsearch6\_dedicated\_master\_enabled) | Indicates whether dedicated master nodes are enabled for the cluster | `string` | `"true"` | no |
| <a name="input_elasticsearch6_ebs_size"></a> [elasticsearch6\_ebs\_size](#input\_elasticsearch6\_ebs\_size) | Size of each node's EBS volume in GB | `number` | `85` | no |
| <a name="input_elasticsearch6_instance_count"></a> [elasticsearch6\_instance\_count](#input\_elasticsearch6\_instance\_count) | Number of ElasticSearch data nodes | `string` | `"6"` | no |
| <a name="input_elasticsearch6_instance_type"></a> [elasticsearch6\_instance\_type](#input\_elasticsearch6\_instance\_type) | Instance type of the ElasticSearch data nodes | `string` | `"r5.xlarge.elasticsearch"` | no |
| <a name="input_elasticsearch6_manual_snapshot_bucket_arns"></a> [elasticsearch6\_manual\_snapshot\_bucket\_arns](#input\_elasticsearch6\_manual\_snapshot\_bucket\_arns) | Bucket ARNs this domain can read/write for manual snapshots | `list(string)` | `[]` | no |
| <a name="input_elasticsearch6_master_instance_count"></a> [elasticsearch6\_master\_instance\_count](#input\_elasticsearch6\_master\_instance\_count) | Number of dedicated master nodes in the cluster | `string` | `"3"` | no |
| <a name="input_elasticsearch6_master_instance_type"></a> [elasticsearch6\_master\_instance\_type](#input\_elasticsearch6\_master\_instance\_type) | Instance type of the dedicated master nodes | `string` | `"c5.large.elasticsearch"` | no |
| <a name="input_elasticsearch6_snapshot_start_hour"></a> [elasticsearch6\_snapshot\_start\_hour](#input\_elasticsearch6\_snapshot\_start\_hour) | The hour in which the daily snapshot is taken | `number` | `1` | no |
| <a name="input_elasticsearch_subnet_names"></a> [elasticsearch\_subnet\_names](#input\_elasticsearch\_subnet\_names) | Names of the subnets to place the ElasticSearch domain in | `list(string)` | n/a | yes |
| <a name="input_internal_domain_name"></a> [internal\_domain\_name](#input\_internal\_domain\_name) | Domain name for internal-only DNS records. Can be different from the zone name. | `any` | n/a | yes |
| <a name="input_internal_zone_name"></a> [internal\_zone\_name](#input\_internal\_zone\_name) | Name of the Route53 zone for internal-only records | `any` | n/a | yes |
| <a name="input_remote_state_bucket"></a> [remote\_state\_bucket](#input\_remote\_state\_bucket) | S3 bucket we store our terraform state in | `any` | n/a | yes |
| <a name="input_remote_state_infra_monitoring_key_stack"></a> [remote\_state\_infra\_monitoring\_key\_stack](#input\_remote\_state\_infra\_monitoring\_key\_stack) | Override stackname path to infra\_monitoring remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_networking_key_stack"></a> [remote\_state\_infra\_networking\_key\_stack](#input\_remote\_state\_infra\_networking\_key\_stack) | Override infra\_networking remote state path | `string` | `""` | no |
| <a name="input_remote_state_infra_root_dns_zones_key_stack"></a> [remote\_state\_infra\_root\_dns\_zones\_key\_stack](#input\_remote\_state\_infra\_root\_dns\_zones\_key\_stack) | Override stackname path to infra\_root\_dns\_zones remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_security_groups_key_stack"></a> [remote\_state\_infra\_security\_groups\_key\_stack](#input\_remote\_state\_infra\_security\_groups\_key\_stack) | Override infra\_security\_groups stackname path to infra\_vpc remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_stack_dns_zones_key_stack"></a> [remote\_state\_infra\_stack\_dns\_zones\_key\_stack](#input\_remote\_state\_infra\_stack\_dns\_zones\_key\_stack) | Override stackname path to infra\_stack\_dns\_zones remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_vpc_key_stack"></a> [remote\_state\_infra\_vpc\_key\_stack](#input\_remote\_state\_infra\_vpc\_key\_stack) | Override infra\_vpc remote state path | `string` | `""` | no |
| <a name="input_stackname"></a> [stackname](#input\_stackname) | Stackname | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_domain_configuration_policy_arn"></a> [domain\_configuration\_policy\_arn](#output\_domain\_configuration\_policy\_arn) | ARN of the policy used to configure the elasticsearch domain |
| <a name="output_manual_snapshots_bucket_arn"></a> [manual\_snapshots\_bucket\_arn](#output\_manual\_snapshots\_bucket\_arn) | ARN of the bucket to store manual snapshots |
| <a name="output_service_dns_name"></a> [service\_dns\_name](#output\_service\_dns\_name) | DNS name to access the Elasticsearch internal service |
| <a name="output_service_endpoint"></a> [service\_endpoint](#output\_service\_endpoint) | Endpoint to submit index, search, and upload requests |
