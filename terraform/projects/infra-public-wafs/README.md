## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.6 |
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
| [aws_cloudwatch_log_group.public_backend_waf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.public_bouncer_waf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.public_cache_waf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_wafv2_ip_set.govuk_requesting_ips](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_ip_set) | resource |
| [aws_wafv2_ip_set.high_request_rate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_ip_set) | resource |
| [aws_wafv2_ip_set.nat_gateway_ips](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_ip_set) | resource |
| [aws_wafv2_regex_pattern_set.x_always_block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_regex_pattern_set) | resource |
| [aws_wafv2_rule_group.x_always_block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_rule_group) | resource |
| [aws_wafv2_web_acl.backend_public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl) | resource |
| [aws_wafv2_web_acl.bouncer_public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl) | resource |
| [aws_wafv2_web_acl.cache_public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl) | resource |
| [aws_wafv2_web_acl.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl) | resource |
| [aws_wafv2_web_acl_logging_configuration.default_web_acl_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_logging_configuration) | resource |
| [aws_wafv2_web_acl_logging_configuration.public_backend_waf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_logging_configuration) | resource |
| [aws_wafv2_web_acl_logging_configuration.public_bouncer_waf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_logging_configuration) | resource |
| [aws_wafv2_web_acl_logging_configuration.public_cache_waf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_logging_configuration) | resource |
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
| <a name="input_allow_high_request_rate_from_cidrs"></a> [allow\_high\_request\_rate\_from\_cidrs](#input\_allow\_high\_request\_rate\_from\_cidrs) | Source IP netblocks from which we allow a higher rate of requests. | `list(string)` | n/a | yes |
| <a name="input_aws_environment"></a> [aws\_environment](#input\_aws\_environment) | AWS Environment | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"eu-west-1"` | no |
| <a name="input_backend_public_base_rate_limit"></a> [backend\_public\_base\_rate\_limit](#input\_backend\_public\_base\_rate\_limit) | For the backend ALB. Number of requests to allow in a 5 minute period before rate limiting is applied. | `number` | n/a | yes |
| <a name="input_backend_public_base_rate_warning"></a> [backend\_public\_base\_rate\_warning](#input\_backend\_public\_base\_rate\_warning) | For the backend ALB. Allows us to configure a warning level to detect what happens if we reduce the limit. | `number` | n/a | yes |
| <a name="input_backend_public_ja3_denylist"></a> [backend\_public\_ja3\_denylist](#input\_backend\_public\_ja3\_denylist) | For the backend ALB. List of JA3 signatures for which we should block all requests. | `list(string)` | n/a | yes |
| <a name="input_bouncer_public_base_rate_limit"></a> [bouncer\_public\_base\_rate\_limit](#input\_bouncer\_public\_base\_rate\_limit) | For the bouncer ALB. Number of requests to allow in a 5 minute period before rate limiting is applied. | `number` | n/a | yes |
| <a name="input_bouncer_public_base_rate_warning"></a> [bouncer\_public\_base\_rate\_warning](#input\_bouncer\_public\_base\_rate\_warning) | For the bouncer ALB. Allows us to configure a warning level to detect what happens if we reduce the limit. | `number` | n/a | yes |
| <a name="input_cache_public_base_rate_limit"></a> [cache\_public\_base\_rate\_limit](#input\_cache\_public\_base\_rate\_limit) | For the cache ALB. Number of requests to allow in a 5 minute period before rate limiting is applied. | `number` | n/a | yes |
| <a name="input_cache_public_base_rate_warning"></a> [cache\_public\_base\_rate\_warning](#input\_cache\_public\_base\_rate\_warning) | For the cache ALB. Allows us to configure a warning level to detect what happens if we reduce the limit. | `number` | n/a | yes |
| <a name="input_eks_egress_ips"></a> [eks\_egress\_ips](#input\_eks\_egress\_ips) | An array of CIDR blocks for the corresponding EKS environment's NAT gateway IPs | `list(string)` | n/a | yes |
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
| <a name="input_traffic_replay_ips"></a> [traffic\_replay\_ips](#input\_traffic\_replay\_ips) | An array of CIDR blocks that will replay traffic against an environment | `list(string)` | n/a | yes |
| <a name="input_waf_log_retention_days"></a> [waf\_log\_retention\_days](#input\_waf\_log\_retention\_days) | The number of days CloudWatch will retain WAF logs for. | `string` | `"30"` | no |

## Outputs

No outputs.
