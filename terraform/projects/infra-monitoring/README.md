## Module: projects/infra-monitoring

Create resources to manage infrastructure and app monitoring:
  - Create an S3 bucket which allows AWS infrastructure to send logs to, for
    instance, ELB logs
  - Create resources to export CloudWatch log groups to S3 via Lambda-Kinesis_Firehose
  - Create SNS topic to send infrastructure alerts, and a SQS queue that subscribes to
    the topic
  - Create an IAM user which allows Terraboard to read Terraform state files from S3

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_environment | AWS Environment | string | - | yes |
| aws_region | AWS region | string | `eu-west-1` | no |
| aws_secondary_region | Secondary AWS region | string | `eu-west-2` | no |
| cyber_slunk_aws_account_id | AWS account ID of the Cyber S3 bucket where aws logging will be replicated | string | `na` | no |
| cyber_slunk_s3_bucket_name | Name of the Cyber S3 bucket where aws logging will be replicated | string | `na` | no |
| stackname | Stackname | string | `` | no |

## Outputs

| Name | Description |
|------|-------------|
| aws_logging_bucket_arn | ARN of the AWS logging bucket |
| aws_logging_bucket_id | Name of the AWS logging bucket |
| aws_secondary_logging_bucket_id | Name of the AWS logging bucket |
| firehose_logs_role_arn | ARN of the Kinesis Firehose stream AWS credentials |
| lambda_logs_role_arn | ARN of the IAM role attached to the Lambda logs Function |
| lambda_rds_logs_to_s3_role_arn | ARN of the IAM role attached to the Lambda RDS logs to S3 Function |
| sns_topic_autoscaling_group_events_arn | ARN of the SNS topic for ASG events |
| sns_topic_cloudwatch_alarms_arn | ARN of the SNS topic for CloudWatch alarms |
| sns_topic_rds_events_arn | ARN of the SNS topic for RDS events |

