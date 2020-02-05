## Module: projects/infra-monitoring

Create resources to manage infrastructure and app monitoring:
  - Create an S3 bucket which allows AWS infrastructure to send logs to, for
    instance, ELB logs
  - Create resources to export CloudWatch log groups to S3 via Lambda-Kinesis\_Firehose
  - Create SNS topic to send infrastructure alerts, and a SQS queue that subscribes to
    the topic
  - Create an IAM user which allows Terraboard to read Terraform state files from S3

## Providers

| Name | Version |
|------|---------|
| aws | 2.46.0 2.46.0 |
| aws.aws\_secondary | 2.46.0 2.46.0 |
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| aws\_environment | AWS Environment | `string` | n/a | yes |
| aws\_region | AWS region | `string` | `"eu-west-1"` | no |
| aws\_secondary\_region | Secondary AWS region | `string` | `"eu-west-2"` | no |
| cyber\_slunk\_aws\_account\_id | AWS account ID of the Cyber S3 bucket where aws logging will be replicated | `string` | `"na"` | no |
| cyber\_slunk\_s3\_bucket\_name | Name of the Cyber S3 bucket where aws logging will be replicated | `string` | `"na"` | no |
| stackname | Stackname | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| aws\_logging\_bucket\_arn | ARN of the AWS logging bucket |
| aws\_logging\_bucket\_id | Name of the AWS logging bucket |
| aws\_secondary\_logging\_bucket\_id | Name of the AWS logging bucket |
| firehose\_logs\_role\_arn | ARN of the Kinesis Firehose stream AWS credentials |
| lambda\_logs\_role\_arn | ARN of the IAM role attached to the Lambda logs Function |
| lambda\_rds\_logs\_to\_s3\_role\_arn | ARN of the IAM role attached to the Lambda RDS logs to S3 Function |
| sns\_topic\_autoscaling\_group\_events\_arn | ARN of the SNS topic for ASG events |
| sns\_topic\_cloudwatch\_alarms\_arn | ARN of the SNS topic for CloudWatch alarms |
| sns\_topic\_rds\_events\_arn | ARN of the SNS topic for RDS events |

