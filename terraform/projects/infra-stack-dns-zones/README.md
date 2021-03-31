## Project: infra-stack-dns-zones

This module creates the internal and external DNS zones used by our stacks.

When we select to create a DNS zone, the domain name and ID of the zone that
manages the root domain needs to be provided to register the DNS delegation
and NS servers of the created zone. The domain name of the new zone is created
from the variables provided as <stackname>.<root\_domain\_internal|external\_name>

We can't create a internal DNS zone per stack because on AWS we can't overlap
internal domain names. Instead we use the same internal zone for all the sacks
and we use the name schema `<service>.<stackname>.<root_domain>`

The outputs of this project should be used by the stacks to create the right
service records on the internal and external DNS zones.

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
| [aws_route53_record.external_zone_ns](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_zone.external_zone](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_zone) | resource |
| [aws_route53_zone.external_selected](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/route53_zone) | data source |
| [aws_route53_zone.internal_selected](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/route53_zone) | data source |
| [terraform_remote_state.infra_vpc](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"eu-west-1"` | no |
| <a name="input_create_external_zone"></a> [create\_external\_zone](#input\_create\_external\_zone) | Create an external DNS zone (default true) | `string` | `true` | no |
| <a name="input_remote_state_bucket"></a> [remote\_state\_bucket](#input\_remote\_state\_bucket) | S3 bucket we store our terraform state in | `string` | n/a | yes |
| <a name="input_remote_state_infra_vpc_key_stack"></a> [remote\_state\_infra\_vpc\_key\_stack](#input\_remote\_state\_infra\_vpc\_key\_stack) | Override infra\_vpc remote state path | `string` | `""` | no |
| <a name="input_root_domain_external_name"></a> [root\_domain\_external\_name](#input\_root\_domain\_external\_name) | External DNS root domain name. Override default for Integration, Staging, Production if create\_external\_zone is true | `string` | `"mydomain.external"` | no |
| <a name="input_root_domain_internal_name"></a> [root\_domain\_internal\_name](#input\_root\_domain\_internal\_name) | Internal DNS root domain name. Override default for Integration, Staging, Production if create\_internal\_zone is true | `string` | `"mydomain.internal"` | no |
| <a name="input_stackname"></a> [stackname](#input\_stackname) | Stackname | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_external_domain_name"></a> [external\_domain\_name](#output\_external\_domain\_name) | Route53 External Domain Name |
| <a name="output_external_zone_id"></a> [external\_zone\_id](#output\_external\_zone\_id) | Route53 External Zone ID |
| <a name="output_internal_domain_name"></a> [internal\_domain\_name](#output\_internal\_domain\_name) | Route53 Internal Domain Name |
| <a name="output_internal_zone_id"></a> [internal\_zone\_id](#output\_internal\_zone\_id) | Route53 Internal Zone ID |
