## Project: app-locations-api

Locations API node

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | = 0.11.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 2.46.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 2.46.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_locations-api"></a> [locations-api](#module\_locations-api) | ../../modules/aws/node_group | n/a |
| <a name="module_locations_api_internal_alb"></a> [locations\_api\_internal\_alb](#module\_locations\_api\_internal\_alb) | ../../modules/aws/lb | n/a |
| <a name="module_locations_api_internal_alb_rules"></a> [locations\_api\_internal\_alb\_rules](#module\_locations\_api\_internal\_alb\_rules) | ../../modules/aws/lb_listener_rules | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.service_record_internal](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_security_group_rule.locations-api-rds_ingress_locations_api_postgres](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_acm_certificate.elb_internal_cert](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/acm_certificate) | data source |
| [aws_route53_zone.internal](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/route53_zone) | data source |
| [aws_security_group.locations-api-rds](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/security_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_asg_size"></a> [asg\_size](#input\_asg\_size) | The autoscaling groups desired/max/min capacity | `string` | `"2"` | no |
| <a name="input_aws_environment"></a> [aws\_environment](#input\_aws\_environment) | AWS Environment | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"eu-west-1"` | no |
| <a name="input_elb_internal_certname"></a> [elb\_internal\_certname](#input\_elb\_internal\_certname) | The ACM cert domain name to find the ARN of | `string` | n/a | yes |
| <a name="input_instance_ami_filter_name"></a> [instance\_ami\_filter\_name](#input\_instance\_ami\_filter\_name) | Name to use to find AMI images | `string` | `""` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type used for EC2 resources | `string` | `"m5.large"` | no |
| <a name="input_internal_domain_name"></a> [internal\_domain\_name](#input\_internal\_domain\_name) | The domain name of the internal DNS records, it could be different from the zone name | `string` | n/a | yes |
| <a name="input_internal_zone_name"></a> [internal\_zone\_name](#input\_internal\_zone\_name) | The name of the Route53 zone that contains internal records | `string` | n/a | yes |
| <a name="input_stackname"></a> [stackname](#input\_stackname) | Stackname | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_service_records_internal_dns_name"></a> [app\_service\_records\_internal\_dns\_name](#output\_app\_service\_records\_internal\_dns\_name) | DNS name to access the app service records |
| <a name="output_locations_api_alb_internal_address"></a> [locations\_api\_alb\_internal\_address](#output\_locations\_api\_alb\_internal\_address) | AWS' internal DNS name for the locations api ELB |
| <a name="output_service_dns_name_internal"></a> [service\_dns\_name\_internal](#output\_service\_dns\_name\_internal) | DNS name to access the node service |
