## Project: wraith-bucket

This creates 2 S3 buckets

wraith-logs: The bucket that will hold the logs produced by wraith
wraith_access_logs: Bucket for logs to go to


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_environment | AWS Environment | string | - | yes |
| aws_region | AWS region | string | `eu-west-1` | no |

## Outputs

| Name | Description |
|------|-------------|
| write_wraith_bucket_policy_arn | ARN of the write wraith-bucket policy |

