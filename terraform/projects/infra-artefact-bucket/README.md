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
| artefact\_source | Identifies the source artefact environment | string | n/a | yes |
| aws\_environment | AWS Environment | string | n/a | yes |
| aws\_region | AWS region | string | `"eu-west-1"` | no |
| aws\_s3\_access\_account | Here we define the account that will have access to the Artefact S3 bucket. | list | n/a | yes |
| aws\_secondary\_region | Secondary region for cross-replication | string | `"eu-west-2"` | no |
| aws\_subscription\_account\_id | The AWS Account ID that will appear on the subscription | string | n/a | yes |
| aws\_subscription\_account\_region | AWS region of the SNS topic | string | `"eu-west-1"` | no |
| create\_sns\_subscription | Indicates whether to create an SNS subscription | string | `"false"` | no |
| create\_sns\_topic | Indicates whether to create an SNS Topic | string | `"false"` | no |
| remote\_state\_bucket | S3 bucket we store our terraform state in | string | n/a | yes |
| remote\_state\_infra\_monitoring\_key\_stack | Override stackname path to infra\_monitoring remote state | string | `""` | no |
| replication\_setting | Whether replication is Enabled or Disabled | string | `"Enabled"` | no |
| stackname | Stackname | string | n/a | yes |
| whole\_bucket\_lifecycle\_rule\_integration\_enabled | Set to true in Integration data to only apply these rules for Integration | string | `"false"` | no |

## Outputs

| Name | Description |
|------|-------------|
| read\_artefact\_bucket\_policy\_arn | ARN of the read artefact-bucket policy |
| write\_artefact\_bucket\_policy\_arn | ARN of the write artefact-bucket policy |

