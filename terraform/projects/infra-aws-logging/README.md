## Module: projects/infra-aws-logging

Create resources to manage infrastructure logging:
  - Create an S3 bucket which allows AWS infrastructure to send logs to, for
    instance, ELB logs
  - Create resources to export CloudWatch log groups to S3 via Lambda-Kinesis_Firehose


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

