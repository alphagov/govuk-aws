## Module: s3-bucket-lifecycle

This module creates s3 buckets with predefined lifecycle rules

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_environment"></a> [aws\_environment](#input\_aws\_environment) | AWS Environment | `string` | n/a | yes |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Name of bucket to create | `string` | n/a | yes |
| <a name="input_current_expiration_days"></a> [current\_expiration\_days](#input\_current\_expiration\_days) | Number of days to keep current versions | `string` | `"5"` | no |
| <a name="input_enable_current_expiration"></a> [enable\_current\_expiration](#input\_enable\_current\_expiration) | Enables current object lifecycle rule | `string` | `"false"` | no |
| <a name="input_enable_noncurrent_expiration"></a> [enable\_noncurrent\_expiration](#input\_enable\_noncurrent\_expiration) | Enables this lifecycle rule | `string` | `"false"` | no |
| <a name="input_noncurrent_expiration_days"></a> [noncurrent\_expiration\_days](#input\_noncurrent\_expiration\_days) | Number of days to keep noncurrent versions | `string` | `"5"` | no |
| <a name="input_target_bucketid_for_logs"></a> [target\_bucketid\_for\_logs](#input\_target\_bucketid\_for\_logs) | ID for logging bucket | `string` | n/a | yes |
| <a name="input_target_prefix_for_logs"></a> [target\_prefix\_for\_logs](#input\_target\_prefix\_for\_logs) | Prefix for logs written to the s3 bucket | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | n/a |
