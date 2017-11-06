## Module: aws/rds_log_exporter

This module exports a RDS instance logs to S3 via Lambda function
and scheduled event.

The Lambda function filename needs to be provided. The module creates
a scheduled Cloudwatch event to trigger the Lambda function.


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| lambda_event_schedule_expression | Cloudwatch event schedule expression that triggers the Lambda function | string | `rate(5 minutes)` | no |
| lambda_filename | The path to the Lambda function's deployment package within the local filesystem | string | - | yes |
| lambda_log_retention_in_days | Specifies the number of days you want to retain log events in the Lambda function log group | string | `1` | no |
| lambda_role_arn | The ARN of the IAM role attached to the Lambda Function | string | - | yes |
| rds_instance_id | The RDS instance ID | string | - | yes |
| rds_log_name_prefix | Download RDS logs that match this prefix | string | `error/` | no |
| s3_logging_bucket_name | The name of the S3 bucket where we store the logs | string | - | yes |
| s3_logging_bucket_prefix | The extra prefix to be added in front of the instance name in the S3 logging bucket. RDS logs will be store in s3_bucket/prefix/instance_name/log_name | string | `rds` | no |

