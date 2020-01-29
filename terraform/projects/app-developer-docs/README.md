## Project: app-developer-docs

Creates S3 bucket for govuk-developer-docs

Migrated from:  
https://github.com/alphagov/govuk-terraform-provisioning/tree/master/projects/developer_docs

## Providers

| Name | Version |
|------|---------|
| aws | 2.46.0 |
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| aws\_environment | AWS Environment | `string` | n/a | yes |
| aws\_region | AWS region | `string` | `"eu-west-1"` | no |
| aws\_replica\_region | AWS region | `string` | `"eu-west-2"` | no |
| bucket\_name | n/a | `string` | `"govuk-developer-documentation"` | no |
| stackname | Stackname | `string` | n/a | yes |

## Outputs

No output.

