## Project: infra-google-mirror-bucket

This project creates a multi-region EU bucket in google cloud, i.e. gcs.




## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| google_environment | Google environment, which is govuk environment. e.g: staging | string | `` | no |
| google_project_id | Google project ID | string | `eu-west2` | no |
| google_region | Google region the provider | string | `eu-west2` | no |
| location | location where to put the gcs bucket | string | `eu` | no |
| storage_class | the type of storage used for the gcs bucket | string | `multi_regional` | no |

## Outputs

| Name | Description |
|------|-------------|
| google_logging_bucket_id | Name of the Google logging bucket |

