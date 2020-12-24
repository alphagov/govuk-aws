## Project: app-data-feedback-pipelines

Data feedback pipelines

Smart Survey and Zendesk feedback pipelines, which extract user feedback, cleanse it and push to Google BigQuery.

## Requirements

| Name | Version |
|------|---------|
| terraform | = 0.11.14 |
| aws | 2.46.0 |

## Providers

| Name | Version |
|------|---------|
| aws | 2.46.0 |
| terraform | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_environment | AWS environment | `string` | n/a | yes |
| aws\_region | AWS region | `string` | `"eu-west-1"` | no |
| remote\_state\_app\_knowledge\_graph\_key\_stack | Override app\_knowledge\_graph remote state path | `string` | `""` | no |
| remote\_state\_app\_related\_links\_key\_stack | Override stackname path to app\_related\_links remote state | `string` | `""` | no |
| remote\_state\_bucket | S3 bucket we store our terraform state in | `string` | n/a | yes |
| remote\_state\_infra\_monitoring\_key\_stack | Override stackname path to infra\_monitoring remote state | `string` | `""` | no |
| remote\_state\_infra\_networking\_key\_stack | Override infra\_networking remote state path | `string` | `""` | no |
| remote\_state\_infra\_root\_dns\_zones\_key\_stack | Override stackname path to infra\_root\_dns\_zones remote state | `string` | `""` | no |
| remote\_state\_infra\_security\_groups\_key\_stack | Override infra\_security\_groups stackname path to infra\_vpc remote state | `string` | `""` | no |
| remote\_state\_infra\_stack\_dns\_zones\_key\_stack | Override stackname path to infra\_stack\_dns\_zones remote state | `string` | `""` | no |
| remote\_state\_infra\_vpc\_key\_stack | Override infra\_vpc remote state path | `string` | `""` | no |
| stackname | Stackname | `string` | n/a | yes |

## Outputs

No output.

