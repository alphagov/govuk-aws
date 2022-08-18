## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | = 1.1.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_shield_protection.account_public_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/shield_protection) | resource |
| [aws_shield_protection.backend_public_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/shield_protection) | resource |
| [aws_shield_protection.bouncer_public_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/shield_protection) | resource |
| [aws_shield_protection.cache_public_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/shield_protection) | resource |
| [aws_shield_protection.ckan_public_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/shield_protection) | resource |
| [aws_shield_protection.deploy_public_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/shield_protection) | resource |
| [aws_shield_protection.draft_cache_public_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/shield_protection) | resource |
| [aws_shield_protection.email_alert_api_public_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/shield_protection) | resource |
| [aws_shield_protection.graphite_public_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/shield_protection) | resource |
| [aws_shield_protection.licensify_backend_public_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/shield_protection) | resource |
| [aws_shield_protection.licensify_frontend_public_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/shield_protection) | resource |
| [aws_shield_protection.monitoring_public_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/shield_protection) | resource |
| [aws_shield_protection.prometheus_public_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/shield_protection) | resource |
| [aws_shield_protection.sidekiq_monitoring_public_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/shield_protection) | resource |
| [aws_shield_protection.whitehall_backend_public_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/shield_protection) | resource |
| [aws_wafv2_ip_set.nat_gateway_ips](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_ip_set) | resource |
| [aws_wafv2_regex_pattern_set.x_always_block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_regex_pattern_set) | resource |
| [aws_wafv2_rule_group.x_always_block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_rule_group) | resource |
| [aws_wafv2_web_acl.cache_public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl) | resource |
| [aws_wafv2_web_acl.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl) | resource |
| [aws_wafv2_web_acl_association.account_public_web_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_association) | resource |
| [aws_wafv2_web_acl_association.backend_public_web_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_association) | resource |
| [aws_wafv2_web_acl_association.bouncer_public_web_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_association) | resource |
| [aws_wafv2_web_acl_association.cache_public_web_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_association) | resource |
| [aws_wafv2_web_acl_association.ckan_public_web_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_association) | resource |
| [aws_wafv2_web_acl_association.deploy_public_web_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_association) | resource |
| [aws_wafv2_web_acl_association.draft_cache_public_web_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_association) | resource |
| [aws_wafv2_web_acl_association.email_alert_api_public_web_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_association) | resource |
| [aws_wafv2_web_acl_association.graphite_public_web_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_association) | resource |
| [aws_wafv2_web_acl_association.licensify_backend_public_web_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_association) | resource |
| [aws_wafv2_web_acl_association.licensify_frontend_web_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_association) | resource |
| [aws_wafv2_web_acl_association.monitoring_public_web_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_association) | resource |
| [aws_wafv2_web_acl_association.prometheus_public_web_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_association) | resource |
| [aws_wafv2_web_acl_association.sidekiq_monitoring_public_web_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_association) | resource |
| [aws_wafv2_web_acl_association.whitehall_backend_public_web_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_association) | resource |
| [aws_wafv2_web_acl_logging_configuration.default_web_acl_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_logging_configuration) | resource |
| [aws_wafv2_web_acl_logging_configuration.public_cache_web_acl_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_logging_configuration) | resource |
| [terraform_remote_state.infra_database_backups_bucket](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_monitoring](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_networking](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_public_services](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_root_dns_zones](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_security_groups](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_vpc](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_environment"></a> [aws\_environment](#input\_aws\_environment) | AWS Environment | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"eu-west-1"` | no |
| <a name="input_cache_public_base_rate_limit"></a> [cache\_public\_base\_rate\_limit](#input\_cache\_public\_base\_rate\_limit) | Number of requests to allow in a 5 minute period before rate limiting is applied. | `number` | n/a | yes |
| <a name="input_fastly_rate_limit_token"></a> [fastly\_rate\_limit\_token](#input\_fastly\_rate\_limit\_token) | Token used by the CDN to skip rate limiting | `string` | `""` | no |
| <a name="input_remote_state_bucket"></a> [remote\_state\_bucket](#input\_remote\_state\_bucket) | S3 bucket we store our terraform state in | `string` | n/a | yes |
| <a name="input_remote_state_infra_database_backups_bucket_key_stack"></a> [remote\_state\_infra\_database\_backups\_bucket\_key\_stack](#input\_remote\_state\_infra\_database\_backups\_bucket\_key\_stack) | Override path to infra\_database\_backups\_bucket remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_monitoring_key_stack"></a> [remote\_state\_infra\_monitoring\_key\_stack](#input\_remote\_state\_infra\_monitoring\_key\_stack) | Override path to infra\_monitoring remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_networking_key_stack"></a> [remote\_state\_infra\_networking\_key\_stack](#input\_remote\_state\_infra\_networking\_key\_stack) | Override path to infra\_networking remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_public_services_key_stack"></a> [remote\_state\_infra\_public\_services\_key\_stack](#input\_remote\_state\_infra\_public\_services\_key\_stack) | Override path to infra\_public\_services remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_root_dns_zones_key_stack"></a> [remote\_state\_infra\_root\_dns\_zones\_key\_stack](#input\_remote\_state\_infra\_root\_dns\_zones\_key\_stack) | Override path to infra\_root\_dns\_zones remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_security_groups_key_stack"></a> [remote\_state\_infra\_security\_groups\_key\_stack](#input\_remote\_state\_infra\_security\_groups\_key\_stack) | Override path to infra\_security\_groups remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_vpc_key_stack"></a> [remote\_state\_infra\_vpc\_key\_stack](#input\_remote\_state\_infra\_vpc\_key\_stack) | Override path to infra\_vpc remote state | `string` | `""` | no |
| <a name="input_stackname"></a> [stackname](#input\_stackname) | Stackname | `string` | `"govuk"` | no |

## Outputs

No outputs.
