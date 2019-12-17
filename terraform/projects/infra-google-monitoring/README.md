## Project: infra-google-mirror-bucket

This project creates a multi-region EU bucket in google cloud, i.e. gcs.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| google\_environment | Google environment, which is govuk environment. e.g: staging | string | `""` | no |
| google\_project\_id | Google project ID | string | `"eu-west2"` | no |
| google\_region | Google region the provider | string | `"eu-west2"` | no |
| location | location where to put the gcs bucket | string | `"eu"` | no |
| storage\_class | the type of storage used for the gcs bucket | string | `"multi_regional"` | no |

## Outputs

| Name | Description |
|------|-------------|
| google\_logging\_bucket\_id | Name of the Google logging bucket |

