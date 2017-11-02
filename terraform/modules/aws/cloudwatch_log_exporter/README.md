## Module: aws/cloudwatch_log_exporter

This module exports a CloudWatch log group to S3 via Lambda
function and Kinesis Firehose.

The lambda function filename needs to be provided and the
module will create a permission to listen to Log events and
a subscription to the specified log group. This function
should:
  - decompress the Cloudwatch log
  - format the data, if needed, so the log entry can later be
parsed by a Logstash filter
  - send the log event to a Kinesis Firehose stream, that will
be configured to store the events in a S3 bucket


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| firehose_bucket_arn | The ARN of the Kinesis Firehose stream S3 bucket | string | - | yes |
| firehose_bucket_prefix | The extra prefix to be added in front of the default time format prefix to the Kinesis Firehose stream S3 bucket | string | - | yes |
| firehose_role_arn | The ARN of the Kinesis Firehose stream AWS credentials | string | - | yes |
| lambda_filename | The path to the Lambda function's deployment package within the local filesystem | string | - | yes |
| lambda_log_retention_in_days | Specifies the number of days you want to retain log events in the Lambda function log group | string | `1` | no |
| lambda_role_arn | The ARN of the IAM role attached to the Lambda Function | string | - | yes |
| log_group_name | The name of the Cloudwatch log group to process | string | - | yes |

