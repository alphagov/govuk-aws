## Project: infra-certificates

This module creates the environment certificates

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws\_region | AWS region | string | n/a | yes |
| certificate\_external\_domain\_name | Domain name for which the external certificate should be issued | string | n/a | yes |
| certificate\_external\_subject\_alternative\_names | List of domains that should be SANs in the external issued certificate | list | `<list>` | no |
| certificate\_internal\_domain\_name | Domain name for which the internal certificate should be issued | string | n/a | yes |
| certificate\_internal\_subject\_alternative\_names | List of domains that should be SANs in the internal issued certificate | list | `<list>` | no |
| remote\_state\_bucket | S3 bucket we store our terraform state in | string | n/a | yes |
| remote\_state\_infra\_root\_dns\_zones\_key\_stack | Override stackname path to infra\_root\_dns\_zones remote state | string | `""` | no |
| stackname | Stackname | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| external\_certificate\_arn | ARN of the external certificate |
| internal\_certificate\_arn | ARN of the internal certificate |

