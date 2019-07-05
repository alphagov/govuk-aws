## Project: app-govuk-attachments

Creates S3 bucket for asset master attachments storage


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| additional_policy_attachment_roles | Additional roles to attach to the readwrite policy, for legacy compatibility. | list | `<list>` | no |
| aws_environment | AWS Environment | string | - | yes |
| aws_region | AWS region | string | `eu-west-1` | no |
| bucket_name |  | string | `govuk-attachments` | no |
| days_to_keep |  | string | `30` | no |
| lifecycle |  | string | `false` | no |
| stackname | Stackname | string | - | yes |
| team |  | string | `Infrastructure` | no |
| username |  | string | `govuk-attachments` | no |
| versioning |  | string | `true` | no |

