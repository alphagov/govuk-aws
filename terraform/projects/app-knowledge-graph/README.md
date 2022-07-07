## Project: app-knowledge-graph

Knowledge graph

The central knowledge graph which can be used to ask questions of GOV.UK content.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | = 0.11.15 |
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
| [aws_autoscaling_group.knowledge-graph-dev_asg](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/autoscaling_group) | resource |
| [aws_autoscaling_group.knowledge-graph_asg](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/autoscaling_group) | resource |
| [aws_autoscaling_schedule.knowledge-graph_schedule-spin-down](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/autoscaling_schedule) | resource |
| [aws_autoscaling_schedule.knowledge-graph_schedule-spin-up](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/autoscaling_schedule) | resource |
| [aws_elb.knowledge-graph-dev_elb_external](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/elb) | resource |
| [aws_elb.knowledge-graph_elb_external](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/elb) | resource |
| [aws_iam_instance_profile.knowledge-graph_instance_profile](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.knowledge-graph_read_ssm_policy](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.knowledge-graph_register_instance_with_elb_policy](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.read_write_data_infrastructure_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.knowledge-graph_role](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.knowledge-graph_read_content_store_backups_bucket_role_attachment](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.knowledge-graph_read_related_links_bucket_role_attachment](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.knowledge-graph_read_ssm_role_attachment](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.knowledge-graph_register_instance_with_elb_role_attachment](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.read_write_data_infrastructure_bucket_role_attachment](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_launch_template.knowledge-graph-dev_launch_template](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/launch_template) | resource |
| [aws_launch_template.knowledge-graph_launch_template](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/launch_template) | resource |
| [aws_route53_record.knowledge_graph_dev_service_record_external](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/route53_record) | resource |
| [aws_route53_record.knowledge_graph_service_record_external](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/route53_record) | resource |
| [aws_s3_bucket.data_infrastructure_bucket](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/s3_bucket) | resource |
| [aws_acm_certificate.elb_external_cert](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/data-sources/acm_certificate) | data source |
| [aws_ami.neo4j_community_ami](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/data-sources/ami) | data source |
| [aws_ami.ubuntu_server_22](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/data-sources/ami) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.knowledge-graph_read_ssm_policy_document](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.knowledge-graph_register_instance_with_elb_policy_document](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.read_write_data_infrastructure_bucket_policy_document](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/data-sources/iam_policy_document) | data source |
| [aws_route53_zone.external](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/data-sources/route53_zone) | data source |
| [template_file.ec2_assume_policy_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.knowledge-graph-dev_userdata](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.knowledge-graph_userdata](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
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
| <a name="input_elb_external_certname"></a> [elb\_external\_certname](#input\_elb\_external\_certname) | The ACM cert domain name to find the ARN of | `string` | n/a | yes |
| <a name="input_external_domain_name"></a> [external\_domain\_name](#input\_external\_domain\_name) | The domain name of the external DNS records, it could be different from the zone name | `string` | n/a | yes |
| <a name="input_external_zone_name"></a> [external\_zone\_name](#input\_external\_zone\_name) | The name of the Route53 zone that contains external records | `string` | n/a | yes |
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

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_data-infrastructure-bucket_name"></a> [data-infrastructure-bucket\_name](#output\_data-infrastructure-bucket\_name) | Bucket to store data for data platform |
| <a name="output_read_write_data_infrastructure_bucket_policy_arn"></a> [read\_write\_data\_infrastructure\_bucket\_policy\_arn](#output\_read\_write\_data\_infrastructure\_bucket\_policy\_arn) | Policy ARN to read and write to the data-infrastructure-data bucket |
