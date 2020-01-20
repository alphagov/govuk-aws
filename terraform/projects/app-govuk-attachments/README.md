## Project: app-govuk-attachments

Creates S3 bucket for asset master attachments storage

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| additional\_policy\_attachment\_roles | Additional roles to attach to the readwrite policy, for legacy compatibility. | `list` | `[]` | no |
| aws\_environment | AWS Environment | `string` | n/a | yes |
| aws\_region | AWS region | `string` | `"eu-west-1"` | no |
| bucket\_name | n/a | `string` | `"govuk-attachments"` | no |
| days\_to\_keep | n/a | `string` | `30` | no |
| lifecycle | n/a | `string` | `false` | no |
| stackname | Stackname | `string` | n/a | yes |
| team | n/a | `string` | `"Infrastructure"` | no |
| username | n/a | `string` | `"govuk-attachments"` | no |
| versioning | n/a | `string` | `"true"` | no |

## Outputs

No output.

