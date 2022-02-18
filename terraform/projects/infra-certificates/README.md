## Project: infra-certificates

This module creates the environment certificates

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
| [aws_acm_certificate.certificate_external](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate.certificate_internal](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.certificate_external](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/acm_certificate_validation) | resource |
| [aws_acm_certificate_validation.certificate_internal](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/acm_certificate_validation) | resource |
| [aws_route53_record.certificate_external_validation](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.certificate_internal_validation](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [terraform_remote_state.infra_root_dns_zones](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | n/a | yes |
| <a name="input_certificate_external_domain_name"></a> [certificate\_external\_domain\_name](#input\_certificate\_external\_domain\_name) | Domain name for which the external certificate should be issued | `string` | n/a | yes |
| <a name="input_certificate_external_subject_alternative_names"></a> [certificate\_external\_subject\_alternative\_names](#input\_certificate\_external\_subject\_alternative\_names) | List of domains that should be SANs in the external issued certificate | `list` | `[]` | no |
| <a name="input_certificate_internal_domain_name"></a> [certificate\_internal\_domain\_name](#input\_certificate\_internal\_domain\_name) | Domain name for which the internal certificate should be issued | `string` | n/a | yes |
| <a name="input_certificate_internal_subject_alternative_names"></a> [certificate\_internal\_subject\_alternative\_names](#input\_certificate\_internal\_subject\_alternative\_names) | List of domains that should be SANs in the internal issued certificate | `list` | `[]` | no |
| <a name="input_remote_state_bucket"></a> [remote\_state\_bucket](#input\_remote\_state\_bucket) | S3 bucket we store our terraform state in | `string` | n/a | yes |
| <a name="input_remote_state_infra_root_dns_zones_key_stack"></a> [remote\_state\_infra\_root\_dns\_zones\_key\_stack](#input\_remote\_state\_infra\_root\_dns\_zones\_key\_stack) | Override stackname path to infra\_root\_dns\_zones remote state | `string` | `""` | no |
| <a name="input_stackname"></a> [stackname](#input\_stackname) | Stackname | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_external_certificate_arn"></a> [external\_certificate\_arn](#output\_external\_certificate\_arn) | ARN of the external certificate |
| <a name="output_internal_certificate_arn"></a> [internal\_certificate\_arn](#output\_internal\_certificate\_arn) | ARN of the internal certificate |
