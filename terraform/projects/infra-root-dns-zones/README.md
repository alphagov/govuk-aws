## Project: infra-root-dns-zones

This module creates the internal and external root DNS zones.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | = 0.11.14 |
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
| [aws_route53_zone.external_zone](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_zone) | resource |
| [aws_route53_zone.internal_zone](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_zone) | resource |
| [aws_route53_zone.internal_zone_dns_validation](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_zone) | resource |
| [terraform_remote_state.infra_vpc](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"eu-west-1"` | no |
| <a name="input_create_external_zone"></a> [create\_external\_zone](#input\_create\_external\_zone) | Create an external DNS zone (default true) | `string` | `true` | no |
| <a name="input_create_internal_zone"></a> [create\_internal\_zone](#input\_create\_internal\_zone) | Create an internal DNS zone (default true) | `string` | `true` | no |
| <a name="input_create_internal_zone_dns_validation"></a> [create\_internal\_zone\_dns\_validation](#input\_create\_internal\_zone\_dns\_validation) | Create a public DNS zone to validate the internal domain certificate (default false) | `string` | `false` | no |
| <a name="input_remote_state_bucket"></a> [remote\_state\_bucket](#input\_remote\_state\_bucket) | S3 bucket we store our terraform state in | `string` | n/a | yes |
| <a name="input_remote_state_infra_vpc_key_stack"></a> [remote\_state\_infra\_vpc\_key\_stack](#input\_remote\_state\_infra\_vpc\_key\_stack) | Override infra\_vpc remote state path | `string` | `""` | no |
| <a name="input_root_domain_external_name"></a> [root\_domain\_external\_name](#input\_root\_domain\_external\_name) | External DNS root domain name. Override default for Integration, Staging, Production if create\_external\_zone is true | `string` | `"mydomain.external"` | no |
| <a name="input_root_domain_internal_name"></a> [root\_domain\_internal\_name](#input\_root\_domain\_internal\_name) | Internal DNS root domain name. Override default for Integration, Staging, Production if create\_internal\_zone is true | `string` | `"mydomain.internal"` | no |
| <a name="input_stackname"></a> [stackname](#input\_stackname) | Stackname | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_external_root_domain_name"></a> [external\_root\_domain\_name](#output\_external\_root\_domain\_name) | Route53 External Root Domain Name |
| <a name="output_external_root_zone_id"></a> [external\_root\_zone\_id](#output\_external\_root\_zone\_id) | Route53 External Root Zone ID |
| <a name="output_internal_root_dns_validation_zone_id"></a> [internal\_root\_dns\_validation\_zone\_id](#output\_internal\_root\_dns\_validation\_zone\_id) | Route53 Zone ID for DNS certificate validation of the internal domain |
| <a name="output_internal_root_domain_name"></a> [internal\_root\_domain\_name](#output\_internal\_root\_domain\_name) | Route53 Internal Root Domain Name |
| <a name="output_internal_root_zone_id"></a> [internal\_root\_zone\_id](#output\_internal\_root\_zone\_id) | Route53 Internal Root Zone ID |
