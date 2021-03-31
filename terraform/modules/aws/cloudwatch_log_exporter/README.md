## Module: aws/cloudwatch\_log\_exporter

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
| [aws_cloudwatch_log_group.lambda_logs_to_firehose_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_subscription_filter.log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_subscription_filter) | resource |
| [aws_kinesis_firehose_delivery_stream.logs_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_firehose_delivery_stream) | resource |
| [aws_lambda_function.lambda_logs_to_firehose](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.allow_cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_firehose_bucket_arn"></a> [firehose\_bucket\_arn](#input\_firehose\_bucket\_arn) | The ARN of the Kinesis Firehose stream S3 bucket | `string` | n/a | yes |
| <a name="input_firehose_bucket_prefix"></a> [firehose\_bucket\_prefix](#input\_firehose\_bucket\_prefix) | The extra prefix to be added in front of the default time format prefix to the Kinesis Firehose stream S3 bucket | `string` | n/a | yes |
| <a name="input_firehose_role_arn"></a> [firehose\_role\_arn](#input\_firehose\_role\_arn) | The ARN of the Kinesis Firehose stream AWS credentials | `string` | n/a | yes |
| <a name="input_lambda_filename"></a> [lambda\_filename](#input\_lambda\_filename) | The path to the Lambda function's deployment package within the local filesystem | `string` | n/a | yes |
| <a name="input_lambda_log_retention_in_days"></a> [lambda\_log\_retention\_in\_days](#input\_lambda\_log\_retention\_in\_days) | Specifies the number of days you want to retain log events in the Lambda function log group | `string` | `"1"` | no |
| <a name="input_lambda_role_arn"></a> [lambda\_role\_arn](#input\_lambda\_role\_arn) | The ARN of the IAM role attached to the Lambda Function | `string` | n/a | yes |
| <a name="input_log_group_name"></a> [log\_group\_name](#input\_log\_group\_name) | The name of the Cloudwatch log group to process | `string` | n/a | yes |

## Outputs

No outputs.
