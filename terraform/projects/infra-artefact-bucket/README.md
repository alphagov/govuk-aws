 ## Project: artefact-bucket

This creates 3 S3 buckets:

artefact: The bucket that will hold the artefacts
artefact_access_logs: Bucket for logs to go to
artefact_replication_destination: Bucket in another region to replicate to

It creates two IAM roles:
artefact_writer: used by CI to write new artefacts, and deploy instances
to write to "deployed-to-environment" branches

artefact_reader: used by instances to fetch artefacts

This module creates the following.
     - AWS SNS topic
     - AWS S3 Bucket event
     - AWS S3 Bucket policy.
     - AWS Lambda function.
     - AWS SNS subscription
     - AWS IAM roles and polisis for SNS and Lambda.



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| artefact_source | Identifies the source artefact environment | string | - | yes |
| aws_environment | AWS Environment | string | - | yes |
| aws_region | AWS region | string | `eu-west-1` | no |
| aws_s3_access_account | Here we define the account that will have access to the Artefact S3 bucket. | list | - | yes |
| aws_secondary_region | Secondary region for cross-replication | string | `eu-west-2` | no |
| aws_subscription_account_id | The AWS Account ID that will appear on the subscription | string | - | yes |
| aws_subscription_account_region | AWS region of the SNS topic | string | `eu-west-1` | no |
| create_sns_subscription | Indicates whether to create an SNS subscription | string | `false` | no |
| create_sns_topic | Indicates whether to create an SNS Topic | string | `false` | no |
| remote_state_bucket | S3 bucket we store our terraform state in | string | - | yes |
| remote_state_infra_monitoring_key_stack | Override stackname path to infra_monitoring remote state | string | `` | no |
| stackname | Stackname | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| read_artefact_bucket_policy_arn | ARN of the read artefact-bucket policy |
| write_artefact_bucket_policy_arn | ARN of the write artefact-bucket policy |

