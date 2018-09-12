## Module: projects/infra-monitoring

Create resources to manage infrastructure and app monitoring:
  - Create an S3 bucket which allows AWS infrastructure to send logs to, for
    instance, ELB logs
  - Create resources to export CloudWatch log groups to S3 via Lambda-Kinesis_Firehose
  - Create SNS topic to send infrastructure alerts, and a SQS queue that subscribes to
    the topic
  - Create an IAM role which allows the AWS X-Ray daemon to upload trace data to
    AWS X-Ray (only required while trace data is sent from Carrenza)


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_environment | AWS Environment | string | - | yes |
| aws_region | AWS region | string | `eu-west-1` | no |
| stackname | Stackname | string | `` | no |

## Outputs

| Name | Description |
|------|-------------|
| aws_logging_bucket_arn | ARN of the AWS logging bucket |
| aws_logging_bucket_id | Name of the AWS logging bucket |
| firehose_logs_role_arn | ARN of the Kinesis Firehose stream AWS credentials |
| lambda_logs_role_arn | ARN of the IAM role attached to the Lambda logs Function |
| lambda_rds_logs_to_s3_role_arn | ARN of the IAM role attached to the Lambda RDS logs to S3 Function |
| sns_topic_autoscaling_group_events_arn | ARN of the SNS topic for ASG events |
| sns_topic_cloudwatch_alarms_arn | ARN of the SNS topic for CloudWatch alarms |
| sns_topic_rds_events_arn | ARN of the SNS topic for RDS events |
| xray_daemon_role_arn | ARN of the IAM role with permissions to upload traces to X-Ray |

