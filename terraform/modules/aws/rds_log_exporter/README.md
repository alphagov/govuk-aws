## Module: aws/rds_log_exporter

This module exports a RDS instance logs to S3 via Lambda function
and scheduled event.

The Lambda function filename needs to be provided. The module creates
a scheduled Cloudwatch event to trigger the Lambda function.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| lambda\_event\_schedule\_expression | Cloudwatch event schedule expression that triggers the Lambda function | string | `"rate(5 minutes)"` | no |
| lambda\_filename | The path to the Lambda function's deployment package within the local filesystem | string | n/a | yes |
| lambda\_log\_retention\_in\_days | Specifies the number of days you want to retain log events in the Lambda function log group | string | `"1"` | no |
| lambda\_role\_arn | The ARN of the IAM role attached to the Lambda Function | string | n/a | yes |
| rds\_instance\_id | The RDS instance ID | string | n/a | yes |
| rds\_log\_name\_prefix | Download RDS logs that match this prefix | string | `"error/"` | no |
| s3\_logging\_bucket\_name | The name of the S3 bucket where we store the logs | string | n/a | yes |
| s3\_logging\_bucket\_prefix | The extra prefix to be added in front of the instance name in the S3 logging bucket. RDS logs will be store in s3\_bucket/prefix/instance\_name/log\_name | string | `"rds"` | no |

