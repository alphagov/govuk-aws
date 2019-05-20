## Project: infra-google-mirror-bucket

This project creates a multi-region EU bucket in google cloud, i.e. gcs.




## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| google_environment | Google environment, which is govuk environment. e.g: staging | string | `` | no |
| google_project_id | Google project ID | string | `eu-west2` | no |
| google_region | Google region the provider | string | `eu-west2` | no |
| govuk_mirror_google_reader_aws_access_key_id | AWS access key ID used by google transfer service to access s3 govuk mirror bucket | string | - | yes |
| govuk_mirror_google_reader_aws_secret_access_key | AWS secret access key used by google transfer service to access s3 govuk mirror bucket | string | - | yes |
| location | location where to put the gcs bucket | string | `eu` | no |
| remote_state_bucket | GCS bucket we store our terraform state in | string | - | yes |
| remote_state_infra_google_monitoring_prefix | GCS bucket prefix where the infra-google-monitoring state files are stored | string | - | yes |
| storage_class | the type of storage used for the gcs bucket | string | `multi_regional` | no |

