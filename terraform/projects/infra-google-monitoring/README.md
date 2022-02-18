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

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_storage_bucket.google-logging](https://registry.terraform.io/providers/hashicorp/google/2.4.1/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_acl.google-logging-acl](https://registry.terraform.io/providers/hashicorp/google/2.4.1/docs/resources/storage_bucket_acl) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_google_environment"></a> [google\_environment](#input\_google\_environment) | Google environment, which is govuk environment. e.g: staging | `string` | `""` | no |
| <a name="input_google_project_id"></a> [google\_project\_id](#input\_google\_project\_id) | Google project ID | `string` | `"eu-west2"` | no |
| <a name="input_google_region"></a> [google\_region](#input\_google\_region) | Google region the provider | `string` | `"eu-west2"` | no |
| <a name="input_location"></a> [location](#input\_location) | location where to put the gcs bucket | `string` | `"eu"` | no |
| <a name="input_storage_class"></a> [storage\_class](#input\_storage\_class) | the type of storage used for the gcs bucket | `string` | `"multi_regional"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_google_logging_bucket_id"></a> [google\_logging\_bucket\_id](#output\_google\_logging\_bucket\_id) | Name of the Google logging bucket |
