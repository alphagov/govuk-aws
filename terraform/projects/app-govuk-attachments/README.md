## Project: app-govuk-attachments

Creates S3 bucket for asset master attachments storage

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| additional\_policy\_attachment\_roles | Additional roles to attach to the readwrite policy, for legacy compatibility. | list | `<list>` | no |
| aws\_environment | AWS Environment | string | n/a | yes |
| aws\_region | AWS region | string | `"eu-west-1"` | no |
| bucket\_name |  | string | `"govuk-attachments"` | no |
| days\_to\_keep |  | string | `"30"` | no |
| lifecycle |  | string | `"false"` | no |
| stackname | Stackname | string | n/a | yes |
| team |  | string | `"Infrastructure"` | no |
| username |  | string | `"govuk-attachments"` | no |
| versioning |  | string | `"true"` | no |

