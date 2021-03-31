## Module: projects/infra-monitoring

Create resources to manage infrastructure and app monitoring:
  - Create an S3 bucket which allows AWS infrastructure to send logs to, for
    instance, ELB logs
  - Create resources to export CloudWatch log groups to S3 via Lambda-Kinesis\_Firehose
  - Create SNS topic to send infrastructure alerts, and a SQS queue that subscribes to
    the topic
  - Create an IAM user which allows Terraboard to read Terraform state files from S3

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | = 0.11.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 2.46.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 2.46.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 2.46.0 2.46.0 |
| <a name="provider_aws.aws_secondary"></a> [aws.aws\_secondary](#provider\_aws.aws\_secondary) | 2.46.0 2.46.0 |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.aws-logging_logit-read_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.firehose_logs_policy](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.govuk_aws_logging_replication_policy](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.lambda_logs_to_firehose_policy](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.lambda_rds_logs_to_s3_policy](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy_attachment.aws-logging_logit-read_iam_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_policy_attachment.govuk_aws_logging_replication_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_role.firehose_logs_role](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role) | resource |
| [aws_iam_role.govuk_aws_logging_replication_role](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role) | resource |
| [aws_iam_role.lambda_logs_to_firehose_role](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role) | resource |
| [aws_iam_role.lambda_rds_logs_to_s3_role](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role) | resource |
| [aws_iam_role.rds_enhanced_monitoring](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.firehose_logs_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.lambda_logs_to_firehose_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.lambda_rds_logs_to_s3_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.rds_enhanced_monitoring](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_user.aws-logging_logit-read_iam_user](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_user) | resource |
| [aws_s3_bucket.aws-logging](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.aws-secondary-logging](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/s3_bucket) | resource |
| [aws_sns_topic.notifications](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.notifications_sqs_target](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/sns_topic_subscription) | resource |
| [aws_sqs_queue.notifications](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue_policy.notifications_sqs_queue_policy](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/sqs_queue_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/caller_identity) | data source |
| [aws_elb_service_account.main](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/elb_service_account) | data source |
| [aws_iam_policy_document.rds_enhanced_monitoring](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/iam_policy_document) | data source |
| [template_file.firehose_assume_policy_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.firehose_logs_policy_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.iam_aws_logging_logit_read_policy_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.lambda_logs_to_firehose_policy_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.lambda_rds_logs_to_s3_policy_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.notifications_sqs_queue_policy_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.s3_aws_logging_policy_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.s3_aws_secondary_logging_policy_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.s3_govuk_aws_logging_replication_policy_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.s3_govuk_aws_logging_replication_role_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_environment"></a> [aws\_environment](#input\_aws\_environment) | AWS Environment | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"eu-west-1"` | no |
| <a name="input_aws_secondary_region"></a> [aws\_secondary\_region](#input\_aws\_secondary\_region) | Secondary AWS region | `string` | `"eu-west-2"` | no |
| <a name="input_cyber_slunk_aws_account_id"></a> [cyber\_slunk\_aws\_account\_id](#input\_cyber\_slunk\_aws\_account\_id) | AWS account ID of the Cyber S3 bucket where aws logging will be replicated | `string` | `"na"` | no |
| <a name="input_cyber_slunk_s3_bucket_name"></a> [cyber\_slunk\_s3\_bucket\_name](#input\_cyber\_slunk\_s3\_bucket\_name) | Name of the Cyber S3 bucket where aws logging will be replicated | `string` | `"na"` | no |
| <a name="input_rds_enhanced_monitoring_role_name"></a> [rds\_enhanced\_monitoring\_role\_name](#input\_rds\_enhanced\_monitoring\_role\_name) | Name of the IAM role to create for RDS Enhanced Monitoring. | `string` | `"rds-monitoring-role"` | no |
| <a name="input_stackname"></a> [stackname](#input\_stackname) | Stackname | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_logging_bucket_arn"></a> [aws\_logging\_bucket\_arn](#output\_aws\_logging\_bucket\_arn) | ARN of the AWS logging bucket |
| <a name="output_aws_logging_bucket_id"></a> [aws\_logging\_bucket\_id](#output\_aws\_logging\_bucket\_id) | Name of the AWS logging bucket |
| <a name="output_aws_secondary_logging_bucket_id"></a> [aws\_secondary\_logging\_bucket\_id](#output\_aws\_secondary\_logging\_bucket\_id) | Name of the AWS logging bucket |
| <a name="output_firehose_logs_role_arn"></a> [firehose\_logs\_role\_arn](#output\_firehose\_logs\_role\_arn) | ARN of the Kinesis Firehose stream AWS credentials |
| <a name="output_lambda_logs_role_arn"></a> [lambda\_logs\_role\_arn](#output\_lambda\_logs\_role\_arn) | ARN of the IAM role attached to the Lambda logs Function |
| <a name="output_lambda_rds_logs_to_s3_role_arn"></a> [lambda\_rds\_logs\_to\_s3\_role\_arn](#output\_lambda\_rds\_logs\_to\_s3\_role\_arn) | ARN of the IAM role attached to the Lambda RDS logs to S3 Function |
| <a name="output_rds_enhanced_monitoring_role_arn"></a> [rds\_enhanced\_monitoring\_role\_arn](#output\_rds\_enhanced\_monitoring\_role\_arn) | The ARN of the IAM role for RDS Enhanced Monitoring |
| <a name="output_sns_topic_autoscaling_group_events_arn"></a> [sns\_topic\_autoscaling\_group\_events\_arn](#output\_sns\_topic\_autoscaling\_group\_events\_arn) | ARN of the SNS topic for ASG events |
| <a name="output_sns_topic_cloudwatch_alarms_arn"></a> [sns\_topic\_cloudwatch\_alarms\_arn](#output\_sns\_topic\_cloudwatch\_alarms\_arn) | ARN of the SNS topic for CloudWatch alarms |
| <a name="output_sns_topic_rds_events_arn"></a> [sns\_topic\_rds\_events\_arn](#output\_sns\_topic\_rds\_events\_arn) | ARN of the SNS topic for RDS events |
