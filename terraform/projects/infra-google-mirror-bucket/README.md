## Project: infra-google-mirror-bucket

This project creates a multi-region EU bucket in google cloud, i.e. gcs.

## Requirements

| Name | Version |
|------|---------|
| terraform | = 0.11.14 |
| google | = 2.4.1 |

## Providers

| Name | Version |
|------|---------|
| google | = 2.4.1 |
| terraform | n/a |

## Modules

No Modules.

## Resources

| Name |
|------|
| [google_storage_bucket](https://registry.terraform.io/providers/hashicorp/google/2.4.1/docs/resources/storage_bucket) |
| [google_storage_bucket_iam_member](https://registry.terraform.io/providers/hashicorp/google/2.4.1/docs/resources/storage_bucket_iam_member) |
| [google_storage_transfer_job](https://registry.terraform.io/providers/hashicorp/google/2.4.1/docs/resources/storage_transfer_job) |
| [google_storage_transfer_project_service_account](https://registry.terraform.io/providers/hashicorp/google/2.4.1/docs/data-sources/storage_transfer_project_service_account) |
| [terraform_remote_state](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| google\_environment | Google environment, which is govuk environment. e.g: staging | `string` | `""` | no |
| google\_project\_id | Google project ID | `string` | `"eu-west2"` | no |
| google\_region | Google region the provider | `string` | `"eu-west2"` | no |
| govuk\_mirror\_google\_reader\_aws\_access\_key\_id | AWS access key ID used by google transfer service to access s3 govuk mirror bucket | `string` | n/a | yes |
| govuk\_mirror\_google\_reader\_aws\_secret\_access\_key | AWS secret access key used by google transfer service to access s3 govuk mirror bucket | `string` | n/a | yes |
| location | location where to put the gcs bucket | `string` | `"eu"` | no |
| remote\_state\_bucket | GCS bucket we store our terraform state in | `string` | n/a | yes |
| remote\_state\_infra\_google\_monitoring\_prefix | GCS bucket prefix where the infra-google-monitoring state files are stored | `string` | n/a | yes |
| storage\_class | the type of storage used for the gcs bucket | `string` | `"multi_regional"` | no |

## Outputs

No output.
