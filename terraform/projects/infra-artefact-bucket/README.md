 ## Project: artefact-bucket

This creates 3 S3 buckets:

artefact: The bucket that will hold the artefacts
artefact_access_logs: Bucket for logs to go to
artefact_replication_destination: Bucket in another region to replicate to

It creates two IAM roles:
artefact_writer: used by CI to write new artefacts, and deploy instances
to write to "deployed-to-environment" branches

artefact_reader: used by instances to fetch artefacts



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_environment | AWS Environment | string | - | yes |
| aws_region | AWS region | string | `eu-west-1` | no |
| aws_secondary_region | Secondary region for cross-replication | string | `eu-west-2` | no |
| remote_state_bucket | S3 bucket we store our terraform state in | string | - | yes |
| remote_state_infra_monitoring_key_stack | Override stackname path to infra_monitoring remote state | string | `` | no |
| stackname | Stackname | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| read_artefact_bucket_policy_arn | ARN of the read artefact-bucket policy |
| write_artefact_bucket_policy_arn | ARN of the write artefact-bucket policy |

