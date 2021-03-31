## Module: aws/rds\_log\_exporter

This module exports a RDS instance logs to S3 via Lambda function
and scheduled event.

The Lambda function filename needs to be provided. The module creates
a scheduled Cloudwatch event to trigger the Lambda function.

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
| [aws_cloudwatch_event_rule.rds_log_scheduled](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.rds_log_scheduled](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_log_group.lambda_rds_logs_to_s3_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_lambda_function.lambda_rds_logs_to_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.allow_cloudwatch_event](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_lambda_event_schedule_expression"></a> [lambda\_event\_schedule\_expression](#input\_lambda\_event\_schedule\_expression) | Cloudwatch event schedule expression that triggers the Lambda function | `string` | `"rate(5 minutes)"` | no |
| <a name="input_lambda_filename"></a> [lambda\_filename](#input\_lambda\_filename) | The path to the Lambda function's deployment package within the local filesystem | `string` | n/a | yes |
| <a name="input_lambda_log_retention_in_days"></a> [lambda\_log\_retention\_in\_days](#input\_lambda\_log\_retention\_in\_days) | Specifies the number of days you want to retain log events in the Lambda function log group | `string` | `"1"` | no |
| <a name="input_lambda_role_arn"></a> [lambda\_role\_arn](#input\_lambda\_role\_arn) | The ARN of the IAM role attached to the Lambda Function | `string` | n/a | yes |
| <a name="input_rds_instance_id"></a> [rds\_instance\_id](#input\_rds\_instance\_id) | The RDS instance ID | `string` | n/a | yes |
| <a name="input_rds_log_name_prefix"></a> [rds\_log\_name\_prefix](#input\_rds\_log\_name\_prefix) | Download RDS logs that match this prefix | `string` | `"error/"` | no |
| <a name="input_s3_logging_bucket_name"></a> [s3\_logging\_bucket\_name](#input\_s3\_logging\_bucket\_name) | The name of the S3 bucket where we store the logs | `string` | n/a | yes |
| <a name="input_s3_logging_bucket_prefix"></a> [s3\_logging\_bucket\_prefix](#input\_s3\_logging\_bucket\_prefix) | The extra prefix to be added in front of the instance name in the S3 logging bucket. RDS logs will be store in s3\_bucket/prefix/instance\_name/log\_name | `string` | `"rds"` | no |

## Outputs

No outputs.
