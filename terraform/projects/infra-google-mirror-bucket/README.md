## Project: infra-google-mirror-bucket

This project creates a multi-region EU bucket in google cloud, i.e. gcs.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | = 0.11.15 |
| <a name="requirement_google"></a> [google](#requirement\_google) | = 2.4.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | = 2.4.1 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_storage_bucket.govuk-mirror](https://registry.terraform.io/providers/hashicorp/google/2.4.1/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_iam_member.s3-sync-bucket](https://registry.terraform.io/providers/hashicorp/google/2.4.1/docs/resources/storage_bucket_iam_member) | resource |
| [google_storage_transfer_job.s3-bucket-daily-sync](https://registry.terraform.io/providers/hashicorp/google/2.4.1/docs/resources/storage_transfer_job) | resource |
| [google_storage_transfer_project_service_account.default](https://registry.terraform.io/providers/hashicorp/google/2.4.1/docs/data-sources/storage_transfer_project_service_account) | data source |
| [terraform_remote_state.infra_google_monitoring](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_google_environment"></a> [google\_environment](#input\_google\_environment) | Google environment, which is govuk environment. e.g: staging | `string` | `""` | no |
| <a name="input_google_project_id"></a> [google\_project\_id](#input\_google\_project\_id) | Google project ID | `string` | `"eu-west2"` | no |
| <a name="input_google_region"></a> [google\_region](#input\_google\_region) | Google region the provider | `string` | `"eu-west2"` | no |
| <a name="input_govuk_mirror_google_reader_aws_access_key_id"></a> [govuk\_mirror\_google\_reader\_aws\_access\_key\_id](#input\_govuk\_mirror\_google\_reader\_aws\_access\_key\_id) | AWS access key ID used by google transfer service to access s3 govuk mirror bucket | `string` | n/a | yes |
| <a name="input_govuk_mirror_google_reader_aws_secret_access_key"></a> [govuk\_mirror\_google\_reader\_aws\_secret\_access\_key](#input\_govuk\_mirror\_google\_reader\_aws\_secret\_access\_key) | AWS secret access key used by google transfer service to access s3 govuk mirror bucket | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | location where to put the gcs bucket | `string` | `"eu"` | no |
| <a name="input_remote_state_bucket"></a> [remote\_state\_bucket](#input\_remote\_state\_bucket) | GCS bucket we store our terraform state in | `string` | n/a | yes |
| <a name="input_remote_state_infra_google_monitoring_prefix"></a> [remote\_state\_infra\_google\_monitoring\_prefix](#input\_remote\_state\_infra\_google\_monitoring\_prefix) | GCS bucket prefix where the infra-google-monitoring state files are stored | `string` | n/a | yes |
| <a name="input_storage_class"></a> [storage\_class](#input\_storage\_class) | the type of storage used for the gcs bucket | `string` | `"multi_regional"` | no |

## Outputs

No outputs.
