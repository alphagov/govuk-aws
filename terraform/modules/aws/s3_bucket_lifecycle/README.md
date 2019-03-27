
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_environment | AWS Environment | string | - | yes |
| bucket_name | Name of bucket to create | string | - | yes |
| current_expiration_days | Number of days to keep current versions | string | `5` | no |
| enable_current_expiration | Enables current object lifecycle rule | string | `false` | no |
| enable_noncurrent_expiration | Enables this lifecycle rule | string | `false` | no |
| noncurrent_expiration_days | Number of days to keep noncurrent versions | string | `5` | no |
| target_bucketid_for_logs | ID for logging bucket | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| bucket_id |  |

