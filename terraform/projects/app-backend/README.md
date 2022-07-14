## Project: app-backend

Backend node

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
| <a name="module_backend"></a> [backend](#module\_backend) | ../../modules/aws/node_group | n/a |
| <a name="module_backend_internal_alb"></a> [backend\_internal\_alb](#module\_backend\_internal\_alb) | ../../modules/aws/lb | n/a |
| <a name="module_backend_internal_alb_rules"></a> [backend\_internal\_alb\_rules](#module\_backend\_internal\_alb\_rules) | ../../modules/aws/lb_listener_rules | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.app_service_records_internal](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.app_service_records_redirected_public_alb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.service_record_internal](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_security_group_rule.collections-publisher-rds_ingress_backend_mysql](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.contacts-admin-rds_ingress_backend_mysql](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.content-data-admin-rds_ingress_backend_postgres](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.content-publisher-rds_ingress_backend_postgres](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.content-tagger-rds_ingress_backend_postgres](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.link-checker-api-rds_ingress_backend_postgres](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.local-links-manager-rds_ingress_backend_postgres](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.release-rds_ingress_backend_mysql](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.search-admin-rds_ingress_backend_mysql](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.service-manual-publisher-rds_ingress_backend_postgres](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.signon-rds_ingress_backend_mysql](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.support-api-rds_ingress_backend_postgres](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [null_resource.user_data](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_acm_certificate.elb_internal_cert](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/acm_certificate) | data source |
| [aws_route53_zone.internal](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/route53_zone) | data source |
| [aws_security_group.collections-publisher-rds](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/security_group) | data source |
| [aws_security_group.contacts-admin-rds](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/security_group) | data source |
| [aws_security_group.content-data-admin-rds](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/security_group) | data source |
| [aws_security_group.content-publisher-rds](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/security_group) | data source |
| [aws_security_group.content-tagger-rds](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/security_group) | data source |
| [aws_security_group.link-checker-api-rds](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/security_group) | data source |
| [aws_security_group.local-links-manager-rds](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/security_group) | data source |
| [aws_security_group.release-rds](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/security_group) | data source |
| [aws_security_group.search-admin-rds](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/security_group) | data source |
| [aws_security_group.service-manual-publisher-rds](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/security_group) | data source |
| [aws_security_group.signon-rds](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/security_group) | data source |
| [aws_security_group.support-api-rds](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/security_group) | data source |
| [terraform_remote_state.infra_monitoring](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_networking](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_root_dns_zones](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_security_groups](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_stack_dns_zones](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_vpc](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_service_records_alb"></a> [app\_service\_records\_alb](#input\_app\_service\_records\_alb) | List of application service names that get traffic via internal alb | `list` | `[]` | no |
| <a name="input_app_service_records_redirected_public_alb"></a> [app\_service\_records\_redirected\_public\_alb](#input\_app\_service\_records\_redirected\_public\_alb) | List of internal application service names that get traffic via public alb | `list` | `[]` | no |
| <a name="input_asg_size"></a> [asg\_size](#input\_asg\_size) | The autoscaling groups desired/max/min capacity | `string` | `"2"` | no |
| <a name="input_aws_environment"></a> [aws\_environment](#input\_aws\_environment) | AWS Environment | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"eu-west-1"` | no |
| <a name="input_elb_internal_certname"></a> [elb\_internal\_certname](#input\_elb\_internal\_certname) | The ACM cert domain name to find the ARN of | `string` | n/a | yes |
| <a name="input_esm_trusty_token"></a> [esm\_trusty\_token](#input\_esm\_trusty\_token) | n/a | `string` | n/a | yes |
| <a name="input_instance_ami_filter_name"></a> [instance\_ami\_filter\_name](#input\_instance\_ami\_filter\_name) | Name to use to find AMI images | `string` | `""` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type used for EC2 resources | `string` | `"m5.2xlarge"` | no |
| <a name="input_internal_domain_name"></a> [internal\_domain\_name](#input\_internal\_domain\_name) | The domain name of the internal DNS records, it could be different from the zone name | `string` | n/a | yes |
| <a name="input_internal_zone_name"></a> [internal\_zone\_name](#input\_internal\_zone\_name) | The name of the Route53 zone that contains internal records | `string` | n/a | yes |
| <a name="input_remote_state_bucket"></a> [remote\_state\_bucket](#input\_remote\_state\_bucket) | S3 bucket we store our terraform state in | `string` | n/a | yes |
| <a name="input_remote_state_infra_monitoring_key_stack"></a> [remote\_state\_infra\_monitoring\_key\_stack](#input\_remote\_state\_infra\_monitoring\_key\_stack) | Override stackname path to infra\_monitoring remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_networking_key_stack"></a> [remote\_state\_infra\_networking\_key\_stack](#input\_remote\_state\_infra\_networking\_key\_stack) | Override infra\_networking remote state path | `string` | `""` | no |
| <a name="input_remote_state_infra_root_dns_zones_key_stack"></a> [remote\_state\_infra\_root\_dns\_zones\_key\_stack](#input\_remote\_state\_infra\_root\_dns\_zones\_key\_stack) | Override stackname path to infra\_root\_dns\_zones remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_security_groups_key_stack"></a> [remote\_state\_infra\_security\_groups\_key\_stack](#input\_remote\_state\_infra\_security\_groups\_key\_stack) | Override infra\_security\_groups stackname path to infra\_vpc remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_stack_dns_zones_key_stack"></a> [remote\_state\_infra\_stack\_dns\_zones\_key\_stack](#input\_remote\_state\_infra\_stack\_dns\_zones\_key\_stack) | Override stackname path to infra\_stack\_dns\_zones remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_vpc_key_stack"></a> [remote\_state\_infra\_vpc\_key\_stack](#input\_remote\_state\_infra\_vpc\_key\_stack) | Override infra\_vpc remote state path | `string` | `""` | no |
| <a name="input_renamed_app_service_records_alb"></a> [renamed\_app\_service\_records\_alb](#input\_renamed\_app\_service\_records\_alb) | List of renamed application service names that get traffic via internal alb | `list` | `[]` | no |
| <a name="input_rules_for_existing_target_groups"></a> [rules\_for\_existing\_target\_groups](#input\_rules\_for\_existing\_target\_groups) | create an additional rule for a target group already created via rules\_host | `map` | `{}` | no |
| <a name="input_stackname"></a> [stackname](#input\_stackname) | Stackname | `string` | n/a | yes |
| <a name="input_user_data_snippets"></a> [user\_data\_snippets](#input\_user\_data\_snippets) | List of user-data snippets | `list` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_service_records_internal_dns_name"></a> [app\_service\_records\_internal\_dns\_name](#output\_app\_service\_records\_internal\_dns\_name) | DNS name to access the app service records |
| <a name="output_backend_alb_internal_address"></a> [backend\_alb\_internal\_address](#output\_backend\_alb\_internal\_address) | AWS' internal DNS name for the backend ELB |
| <a name="output_service_dns_name_internal"></a> [service\_dns\_name\_internal](#output\_service\_dns\_name\_internal) | DNS name to access the node service |
