## Project: app-search

Search application servers

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
| <a name="module_alarms-elb-search-internal"></a> [alarms-elb-search-internal](#module\_alarms-elb-search-internal) | ../../modules/aws/alarms/elb |  |
| <a name="module_search"></a> [search](#module\_search) | ../../modules/aws/node_group |  |

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.learntorank-generation](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/autoscaling_group) | resource |
| [aws_ecr_repository.repo](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/ecr_repository_policy) | resource |
| [aws_elb.search_elb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/elb) | resource |
| [aws_iam_instance_profile.learntorank-generation](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.scale-learntorank-generation-asg-policy](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.search_relevancy_bucket_access](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.sitemaps_bucket_access](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.use_sagemaker](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.learntorank](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.learntorank-bucket](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.learntorank-ecr](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.learntorank-sagemaker](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.scale-learntorank-generation](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.search_relevancy_bucket_access_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.sitemaps_bucket_access_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.use_sagemaker](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_key_pair.learntorank-generation-key](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/key_pair) | resource |
| [aws_launch_template.learntorank-generation](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/launch_template) | resource |
| [aws_route53_record.app_service_records](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.service_record](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_s3_bucket.search_relevancy_bucket](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.sitemaps_bucket](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/s3_bucket) | resource |
| [null_resource.user_data](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_acm_certificate.elb_cert](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/acm_certificate) | data source |
| [aws_ami.ubuntu_bionic](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/ami) | data source |
| [aws_iam_policy_document.ecr-usage](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.learntorank-assume-role](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.scale-learntorank-generation-asg](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.search_relevancy_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.sitemaps_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.use_sagemaker](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/iam_policy_document) | data source |
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
| <a name="input_app_service_records"></a> [app\_service\_records](#input\_app\_service\_records) | List of application service names that get traffic via this loadbalancer | `list` | `[]` | no |
| <a name="input_asg_desired_capacity"></a> [asg\_desired\_capacity](#input\_asg\_desired\_capacity) | The desired capacity of the autoscaling group | `string` | `"2"` | no |
| <a name="input_asg_max_size"></a> [asg\_max\_size](#input\_asg\_max\_size) | The maximum size of the autoscaling group | `string` | `"2"` | no |
| <a name="input_asg_min_size"></a> [asg\_min\_size](#input\_asg\_min\_size) | The minimum size of the autoscaling group | `string` | `"2"` | no |
| <a name="input_aws_environment"></a> [aws\_environment](#input\_aws\_environment) | AWS Environment | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"eu-west-1"` | no |
| <a name="input_concourse_aws_account_id"></a> [concourse\_aws\_account\_id](#input\_concourse\_aws\_account\_id) | AWS account ID which contains the Concourse role | `string` | n/a | yes |
| <a name="input_elb_internal_certname"></a> [elb\_internal\_certname](#input\_elb\_internal\_certname) | The ACM cert domain name to find the ARN of | `string` | n/a | yes |
| <a name="input_instance_ami_filter_name"></a> [instance\_ami\_filter\_name](#input\_instance\_ami\_filter\_name) | Name to use to find AMI images | `string` | `""` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type used for EC2 resources | `string` | `"c5.xlarge"` | no |
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
| <a name="input_user_data_snippets"></a> [user\_data\_snippets](#input\_user\_data\_snippets) | List of user-data snippets | `list` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecr_repository_url"></a> [ecr\_repository\_url](#output\_ecr\_repository\_url) | URL of the ECR repository |
| <a name="output_ltr_role_arn"></a> [ltr\_role\_arn](#output\_ltr\_role\_arn) | LTR role ARN |
| <a name="output_search_elb_dns_name"></a> [search\_elb\_dns\_name](#output\_search\_elb\_dns\_name) | DNS name to access the search service |
| <a name="output_service_dns_name"></a> [service\_dns\_name](#output\_service\_dns\_name) | DNS name to access the node service |
