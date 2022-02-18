## Project: app-elasticsearch6

Managed Elasticsearch 6 cluster

This project has two gotchas, where we work around things terraform
doesn't support:

- Deploying the cluster across 3 availability zones: terraform has
  some built-in validation which rejects using 3 master nodes and 3
  data nodes across 3 availability zones.  To provision a new
  cluster, only use two of everything, then bump the numbers in the
  AWS console and in the terraform variables - it won't complain
  when you next plan.

  https://github.com/terraform-providers/terraform-provider-aws/issues/7504

- Configuring a snapshot repository: terraform doesn't support this,
  and as far as I can tell doesn't have any plans to.  There's a
  Python script in this directory which sets those up.

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
| [aws_cloudwatch_log_group.elasticsearch6_application_log_group](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.elasticsearch6_index_log_group](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.elasticsearch6_search_log_group](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_resource_policy.elasticsearch6_log_resource_policy](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/cloudwatch_log_resource_policy) | resource |
| [aws_elasticsearch_domain.elasticsearch6](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/elasticsearch_domain) | resource |
| [aws_iam_policy.manual_snapshot_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.manual_snapshot_domain_configuration_policy](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy_attachment.manual_snapshot_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_role.manual_snapshot_role](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role) | resource |
| [aws_iam_service_linked_role.role](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_service_linked_role) | resource |
| [aws_route53_record.service_record](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_s3_bucket.manual_snapshots](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.manual_snapshots_cross_account_access](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/s3_bucket_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.elasticsearch6_log_publishing_policy](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.manual_snapshot_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.manual_snapshots_cross_account_access](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/region) | data source |
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
| <a name="input_cloudwatch_log_retention"></a> [cloudwatch\_log\_retention](#input\_cloudwatch\_log\_retention) | Number of days to retain Cloudwatch logs for | `string` | `90` | no |
| <a name="input_elasticsearch6_dedicated_master_enabled"></a> [elasticsearch6\_dedicated\_master\_enabled](#input\_elasticsearch6\_dedicated\_master\_enabled) | Indicates whether dedicated master nodes are enabled for the cluster | `string` | `"true"` | no |
| <a name="input_elasticsearch6_ebs_encrypt"></a> [elasticsearch6\_ebs\_encrypt](#input\_elasticsearch6\_ebs\_encrypt) | Whether to encrypt the EBS volume at rest | `string` | n/a | yes |
| <a name="input_elasticsearch6_ebs_size"></a> [elasticsearch6\_ebs\_size](#input\_elasticsearch6\_ebs\_size) | The amount of EBS storage to attach | `string` | `32` | no |
| <a name="input_elasticsearch6_ebs_type"></a> [elasticsearch6\_ebs\_type](#input\_elasticsearch6\_ebs\_type) | The type of EBS storage to attach | `string` | `"gp2"` | no |
| <a name="input_elasticsearch6_instance_count"></a> [elasticsearch6\_instance\_count](#input\_elasticsearch6\_instance\_count) | The number of ElasticSearch nodes | `string` | `"6"` | no |
| <a name="input_elasticsearch6_instance_type"></a> [elasticsearch6\_instance\_type](#input\_elasticsearch6\_instance\_type) | The instance type of the individual ElasticSearch nodes, only instances which allow EBS volumes are supported | `string` | `"r4.xlarge.elasticsearch"` | no |
| <a name="input_elasticsearch6_manual_snapshot_bucket_arns"></a> [elasticsearch6\_manual\_snapshot\_bucket\_arns](#input\_elasticsearch6\_manual\_snapshot\_bucket\_arns) | Bucket ARNs this domain can read/write for manual snapshots | `list` | `[]` | no |
| <a name="input_elasticsearch6_master_instance_count"></a> [elasticsearch6\_master\_instance\_count](#input\_elasticsearch6\_master\_instance\_count) | Number of dedicated master nodes in the cluster | `string` | `"2"` | no |
| <a name="input_elasticsearch6_master_instance_type"></a> [elasticsearch6\_master\_instance\_type](#input\_elasticsearch6\_master\_instance\_type) | Instance type of the dedicated master nodes in the cluster | `string` | `"c4.large.elasticsearch"` | no |
| <a name="input_elasticsearch6_snapshot_start_hour"></a> [elasticsearch6\_snapshot\_start\_hour](#input\_elasticsearch6\_snapshot\_start\_hour) | The hour in which the daily snapshot is taken | `string` | `1` | no |
| <a name="input_elasticsearch_subnet_names"></a> [elasticsearch\_subnet\_names](#input\_elasticsearch\_subnet\_names) | Names of the subnets to place the ElasticSearch domain in | `list` | n/a | yes |
| <a name="input_internal_domain_name"></a> [internal\_domain\_name](#input\_internal\_domain\_name) | The domain name of the internal DNS records, it could be different from the zone name | `string` | n/a | yes |
| <a name="input_internal_zone_name"></a> [internal\_zone\_name](#input\_internal\_zone\_name) | The name of the Route53 zone that contains internal records | `string` | n/a | yes |
| <a name="input_remote_state_bucket"></a> [remote\_state\_bucket](#input\_remote\_state\_bucket) | S3 bucket we store our terraform state in | `string` | n/a | yes |
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
| <a name="output_domain_configuration_policy_arn"></a> [domain\_configuration\_policy\_arn](#output\_domain\_configuration\_policy\_arn) | ARN of the policy used to configure the elasticsearch domain |
| <a name="output_manual_snapshots_bucket_arn"></a> [manual\_snapshots\_bucket\_arn](#output\_manual\_snapshots\_bucket\_arn) | ARN of the bucket to store manual snapshots |
| <a name="output_service_dns_name"></a> [service\_dns\_name](#output\_service\_dns\_name) | DNS name to access the Elasticsearch internal service |
| <a name="output_service_endpoint"></a> [service\_endpoint](#output\_service\_endpoint) | Endpoint to submit index, search, and upload requests |
