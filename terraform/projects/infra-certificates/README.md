## Project: infra-certificates

This module creates the environment certificates


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_region | AWS region | string | - | yes |
| certificate_external_domain_name | Domain name for which the external certificate should be issued | string | - | yes |
| certificate_external_subject_alternative_names | List of domains that should be SANs in the external issued certificate | list | `<list>` | no |
| certificate_internal_domain_name | Domain name for which the internal certificate should be issued | string | - | yes |
| certificate_internal_subject_alternative_names | List of domains that should be SANs in the internal issued certificate | list | `<list>` | no |
| remote_state_bucket | S3 bucket we store our terraform state in | string | - | yes |
| remote_state_infra_root_dns_zones_key_stack | Override stackname path to infra_root_dns_zones remote state | string | `` | no |
| stackname | Stackname | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| external_certificate_arn | ARN of the external certificate |
| internal_certificate_arn | ARN of the internal certificate |

