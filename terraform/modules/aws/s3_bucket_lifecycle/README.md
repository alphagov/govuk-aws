## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws\_environment | AWS Environment | string | n/a | yes |
| bucket\_name | Name of bucket to create | string | n/a | yes |
| current\_expiration\_days | Number of days to keep current versions | string | `"5"` | no |
| enable\_current\_expiration | Enables current object lifecycle rule | string | `"false"` | no |
| enable\_noncurrent\_expiration | Enables this lifecycle rule | string | `"false"` | no |
| noncurrent\_expiration\_days | Number of days to keep noncurrent versions | string | `"5"` | no |
| target\_bucketid\_for\_logs | ID for logging bucket | string | n/a | yes |
| target\_prefix\_for\_logs | Prefix for logs written to the s3 bucket | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| bucket\_id |  |

